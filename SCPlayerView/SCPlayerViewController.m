//
//  SCPlayerWebViewController.m
//  soundcloud-player-webview
//
//  Created by Andrew Williams on 4/02/11.
//  Copyright 2011 2moro mobile. All rights reserved.
//

#import "SCPlayerViewController.h"
#import "NSObject+JSON.h"

#define DEFAULT_WIDTH 300
#define SERVER_API @"http://api.soundcloud.com"

@implementation SCPlayerViewController

@synthesize view, clientKey;

#pragma mark -

- (id)initWithWidth:(CGFloat)width {
	if(self = [super init]) {
		view = [[SCPlayerView alloc] initWithFrame:CGRectMake(0, 0, width, 32)];
		clientKey = nil;
		apiResponse = nil;
	}
	return self;
}

- (id)init {
	return [self initWithWidth:DEFAULT_WIDTH];
}

- (void)dealloc {
	[clientKey release];
	[view release];
	[apiResponse release];
	
	[super dealloc];
}

#pragma mark -

- (NSString *)readFile:(NSString *)filename {	
	NSString *bundleRoot = [[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"SCPlayerView" ofType:@"bundle"]] bundlePath];
	NSString *path = [NSString stringWithFormat:@"%@/%@", bundleRoot, filename];
	NSLog(@"path: %@", path);
	NSString *text = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
	return text;
}

// fetch given resource via the api
- (void)apiRequest:(NSString *)resource params:(NSDictionary *)params {
	NSMutableDictionary *dict = params ? [NSMutableDictionary dictionaryWithDictionary:params] : [NSMutableDictionary dictionary];
	if(clientKey) [dict setValue:clientKey forKey:@"consumer_key"];
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

	NSLog(@"path: %@", path);
	NSURLConnection *connection = [NSURLConnection connectionWithRequest:req delegate:self];
	[connection start];
}

#pragma mark NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"error: %@", error);
	// TODO: notify delegate
	[view setLoading:NO];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[apiResponse appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSString *json = [[NSString alloc] initWithData:apiResponse encoding:NSUTF8StringEncoding];
	id value = [json JSONValue];
	NSLog(@"value: %@", value);
	
	NSDictionary *data = nil;
	
	if([value isKindOfClass:[NSArray class]]) {
		NSArray *valueArr = value;
		data = [valueArr count] > 0 ? [valueArr objectAtIndex:0] : nil;
	}
	else {
		data = value;
	}
	
	if(data) {
		// "waveform_url" = "http://waveforms.soundcloud.com/8zzRnWS2Hhmb_m.png";
		NSString *waveform_url = [data valueForKey:@"waveform_url"];
		NSString *trackId = [[data valueForKey:@"id"] stringValue];
		NSString *trackCode = nil;
		NSRange trackCodeRange = [waveform_url rangeOfString:@"soundcloud.com/.*?_m.png" options:NSRegularExpressionSearch|NSCaseInsensitiveSearch];
		if(trackCodeRange.location != NSNotFound) {
			trackCode = [waveform_url substringWithRange:NSMakeRange(trackCodeRange.location + 15, trackCodeRange.length - 15 - 6)];
		}
		
		if(trackCode) {
			NSLog(@"track id: %@, code: %@", trackId, trackCode);
			
			NSString *html = [self readFile:@"scplayer.html"];

			html = [html stringByReplacingOccurrencesOfString:@"$trackId" withString:trackId];
			html = [html stringByReplacingOccurrencesOfString:@"$trackCode" withString:trackCode];
			
			// now we have track id and track code, we can create the view
			[view load:html];
		}
	}
}

#pragma mark -

- (void)loadTrack:(NSString *)track {
	if(track == nil) return;

	NSString *req = nil;
	NSDictionary *params = nil;
	NSRange trackIdRange = [track rangeOfString:@"^\\d+$" options:NSRegularExpressionSearch];
	
	if(trackIdRange.location != NSNotFound) {
		// looks like a track id
		req = [NSString stringWithFormat:@"/tracks/%@", track];
	}
	else {
		// do a search
		req = @"/tracks";
		params = [NSDictionary dictionaryWithObjectsAndKeys:track, @"q", nil];
	}
	[self apiRequest:req params:params];
}

@end
