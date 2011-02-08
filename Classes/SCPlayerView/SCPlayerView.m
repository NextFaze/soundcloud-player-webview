//
//  SCPlayerView.m
//  soundcloud-player-webview
//
//  Created by Andrew Williams on 4/02/11.
//  Copyright 2011 2moro mobile. All rights reserved.
//

#import "SCPlayerView.h"
#import "SCPlayerViewError.h"

#define BASE_URL @"http://soundcloud.com"

@implementation SCPlayerView

#pragma mark -

// returns a non-scrollable webview
- (UIWebView *)nonScrollableWebView:(CGRect)f {
	UIWebView *wv = [[UIWebView alloc] initWithFrame:f];
	for(UIView *v in wv.subviews){
		if([v isKindOfClass:[UIScrollView class] ]){
			UIScrollView *sv = (UIScrollView *)v;
			sv.scrollEnabled = NO;
			sv.bounces = NO;
		}
	}
	return [wv autorelease];
}

#pragma mark -

- (id)initWithFrame:(CGRect)f {
	if(self = [super initWithFrame:f]) {
		
		self.backgroundColor = [UIColor clearColor];
		
		webView = [[self nonScrollableWebView:CGRectMake(0, 0, f.size.width, SCPlayerViewHeight)] retain];
		webView.delegate = nil;
		webView.backgroundColor = [UIColor clearColor];
		
		activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		activityView.hidesWhenStopped = YES;
		activityView.center = CGPointMake(f.size.width / 2.0, SCPlayerViewHeight / 2.0);
		
		[self addSubview:webView];
		[self addSubview:activityView];
	}
	return self;
}

- (void)dealloc {
	webView.delegate = nil;
	
	[activityView release];
	[webView release];
	[super dealloc];
}

#pragma mark -

- (id<UIWebViewDelegate>)delegate {
	return webView.delegate;
}
- (void)setDelegate:(id <UIWebViewDelegate>)delegate {
	webView.delegate = delegate;
}

- (void)setActivityStyle:(UIActivityIndicatorViewStyle)style {
	activityView.activityIndicatorViewStyle = style;
}

- (void)load:(NSString *)html {
	[webView loadHTMLString:html baseURL:[NSURL URLWithString:BASE_URL]];
}

- (void)setLoading:(BOOL)value {
	if(value) {
		[activityView startAnimating];
	} else {
		[activityView stopAnimating];
	}
}

@end
