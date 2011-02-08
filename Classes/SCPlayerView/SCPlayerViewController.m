//
//  SCPlayerWebViewController.m
//  soundcloud-player-webview
//
//  Created by Andrew Williams on 4/02/11.
//  Copyright 2011 2moro mobile. All rights reserved.
//

#import "SCPlayerViewController.h"
#import "NSObject+JSON.h"
#import "SCPlayerViewError.h"

#define DEFAULT_WIDTH 300
#define SERVER_API @"http://api.soundcloud.com"

@implementation SCPlayerViewController

@synthesize view, clientKey, delegate;

#pragma mark -

- (id)initWithFrame:(CGRect)f {
	if(self = [super init]) {
		f.size.height = SCPlayerViewHeight;  // fixed height
		
		view = [[SCPlayerView alloc] initWithFrame:f];
		view.delegate = self;
		
		clientKey = nil;
		apiResponse = nil;
		delegate = nil;
	}
	return self;
}

- (id)init {
	return [self initWithFrame:CGRectMake(0, 0, DEFAULT_WIDTH, SCPlayerViewHeight)];
}

- (void)dealloc {
	delegate = nil;
	view.delegate = nil;
	
	[clientKey release];
	[view release];
	[apiResponse release];
	
	[super dealloc];
}

#pragma mark -

- (NSString *)readFile:(NSString *)filename {	
	NSString *bundleRoot = [[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"SCPlayerView" ofType:@"bundle"]] bundlePath];
	NSString *path = [NSString stringWithFormat:@"%@/%@", bundleRoot, filename];
	SCPLAYER_LOG(@"path: %@", path);
	NSString *text = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
	return text;
}

// fetch given resource via the api
- (void)apiRequest:(NSString *)resource params:(NSDictionary *)params {
	NSMutableDictionary *dict = params ? [NSMutableDictionary dictionaryWithDictionary:params] : [NSMutableDictionary dictionary];

	[dict setValue:clientKey forKey:@"consumer_key"];
	[dict setValue:@"json" forKey:@"format"];

	NSMutableArray *paramList = [NSMutableArray array];
	for(NSString *key in [dict allKeys]) {
		NSString *param = [NSString stringWithFormat:@"%@=%@", key, [dict valueForKey:key]];
		[paramList addObject:param];
	}

	if(apiResponse) [apiResponse release];
	apiResponse = [[NSMutableData alloc] init];
	
	NSString *path = [NSString stringWithFormat:@"%@%@?%@", SERVER_API, resource, [paramList componentsJoinedByString:@"&"]];
	NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:path]];
	
	[view setLoading:YES];

	SCPLAYER_LOG(@"path: %@", path);
	NSURLConnection *connection = [NSURLConnection connectionWithRequest:req delegate:self];
	[connection start];
}

#pragma mark NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	SCPLAYER_LOG(@"error: %@", error);
	[SCPlayerViewError notifyDelegate:delegate error:error];
	[view setLoading:NO];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[apiResponse appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSString *json = [[NSString alloc] initWithData:apiResponse encoding:NSUTF8StringEncoding];
	id value = [json JSONValue];
	SCPLAYER_LOG(@"value: %@", value);
	
	NSDictionary *data = nil;
	
	if([value isKindOfClass:[NSArray class]]) {
		NSArray *valueArr = value;
		data = [valueArr count] > 0 ? [valueArr objectAtIndex:0] : nil;
	}
	else {
		data = value;
	}
	
	if(data) {
		// check for error
		NSString *errorValue = [data valueForKey:@"error"];
		if(errorValue) {
			[SCPlayerViewError notifyDelegate:delegate errorCode:103 description:errorValue];
			[view setLoading:NO];
			return;
		}
		
		// "waveform_url" = "http://waveforms.soundcloud.com/8zzRnWS2Hhmb_m.png";
		NSString *waveform_url = [data valueForKey:@"waveform_url"];
		NSString *trackId = [[data valueForKey:@"id"] stringValue];
		NSString *trackCode = nil;
		NSRange trackCodeRange = [waveform_url rangeOfString:@"soundcloud.com/.*?_m.png" options:NSRegularExpressionSearch|NSCaseInsensitiveSearch];

		if(trackCodeRange.location != NSNotFound) {
			trackCode = [waveform_url substringWithRange:NSMakeRange(trackCodeRange.location + 15, trackCodeRange.length - 15 - 6)];
		}
		
		if(trackCode) {
			SCPLAYER_LOG(@"track id: %@, code: %@", trackId, trackCode);
			
			NSString *html = [self readFile:@"scplayer.html"];

			html = [html stringByReplacingOccurrencesOfString:@"$trackId" withString:trackId];
			html = [html stringByReplacingOccurrencesOfString:@"$trackCode" withString:trackCode];
			
			// now we have track id and track code, we can create the view
			[view load:html];
		} else {
			// could not determine track code
			[SCPlayerViewError notifyDelegate:delegate errorCode:104 description:@"unable to determine track code"];
			[view setLoading:NO];
			return;			
		}
	}
}

#pragma mark UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)wv {
	// set activity view style to white so that it can be seen over the web view (in case web view is reloaded)
	[view setActivityStyle:UIActivityIndicatorViewStyleWhite];
	[view setLoading:NO];
	
	if([delegate respondsToSelector:@selector(scplayerViewControllerDidFinishLoad:)])
		[delegate scplayerViewControllerDidFinishLoad:self];
}

- (void)webView:(UIWebView *)wv didFailLoadWithError:(NSError *)error {
	[view setLoading:NO];
	[SCPlayerViewError notifyDelegate:delegate error:error];
}

#pragma mark -

- (BOOL)checkClientKey {
	if(clientKey == nil) {
		// client key is required
		[SCPlayerViewError notifyDelegate:delegate errorCode:102 description:@"client key is not set"];
		return FALSE;
	}
	return TRUE;
}	

// e.g. http://soundcloud.com/iambrains/brains-onion-mix
- (void)loadPermalink:(NSString *)url {
	[self apiRequest:@"/resolve" params:[NSDictionary dictionaryWithObjectsAndKeys:url, @"url", nil]];
}

// e.g. <object width="100%" height="81" data="http://player.soundcloud.com/player.swf?url=http%3A%2F%2Fsoundcloud.com%2Fiambrains%2Fbrains-onion-mix"
- (void)loadHTMLObject:(NSString *)html {
	
	NSRange rangeObject = [html rangeOfString:@"<object.*?soundcloud.com/player.swf.*?>.*?</object>" 
								options:NSRegularExpressionSearch|NSCaseInsensitiveSearch];
	if(rangeObject.location != NSNotFound) {
		// sound cloud <object> tag found
		NSRange rangeURL = [html rangeOfString:@"url=[^\"]+" options:NSRegularExpressionSearch|NSCaseInsensitiveSearch range:rangeObject];
		if(rangeURL.location != NSNotFound) {
			// found url
			NSString *scurl = [html substringWithRange:NSMakeRange(rangeURL.location + 4, rangeURL.length - 4)];
			scurl = [scurl stringByReplacingOccurrencesOfString:@"%3A" withString:@":"];
			scurl = [scurl stringByReplacingOccurrencesOfString:@"%2F" withString:@"/"];
			
			SCPLAYER_LOG(@"scurl: %@", scurl);

			// see if this is a track reference
			NSRange rangeTrack = [scurl rangeOfString:@"tracks/\\d+" options:NSRegularExpressionSearch|NSCaseInsensitiveSearch];
			if(rangeTrack.location != NSNotFound) {
				// track number found
				NSString *trackId = [scurl substringWithRange:NSMakeRange(rangeTrack.location + 7, rangeTrack.length - 7)];
				[self loadTrack:trackId];
				return;
			} else {
				// have to resolve the permalink to query the track information
				[self loadPermalink:scurl];
				return;
			}
		}
	}
	[SCPlayerViewError notifyDelegate:delegate errorCode:105 description:@"unable to parse sound cloud object HTML"];
}

// accepts track id, sound cloud object html, and track name (uses first match on name).
- (void)loadTrack:(NSString *)track {
	if(track == nil) {
		[SCPlayerViewError notifyDelegate:delegate errorCode:101 description:@"track is undefined"];
		return;
	}
	if(![self checkClientKey]) return;
	
	NSString *req = nil;
	NSDictionary *params = nil;
	NSRange rangeTrackId = [track rangeOfString:@"^\\d+$" options:NSRegularExpressionSearch];
	NSRange rangeObject = [track rangeOfString:@"<object.*?soundcloud.com/player.swf" options:NSRegularExpressionSearch|NSCaseInsensitiveSearch];
	
	if(rangeObject.location != NSNotFound) {
		// looks like html object
		[self loadHTMLObject:track];
		return;
	}
	else if(rangeTrackId.location != NSNotFound) {
		// looks like a track id
		req = [NSString stringWithFormat:@"/tracks/%@", track];
	}
	else {
		// do a search by name
		req = @"/tracks";
		params = [NSDictionary dictionaryWithObjectsAndKeys:track, @"q", nil];
	}
	[self apiRequest:req params:params];
}

@end
