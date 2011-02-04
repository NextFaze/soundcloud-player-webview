//
//  SCPlayerView.h
//  soundcloud-player-webview
//
//  Created by Andrew Williams on 4/02/11.
//  Copyright 2011 2moro mobile. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SCPlayerView : UIView <UIWebViewDelegate> {
	UIActivityIndicatorView *activityView;
	UIWebView *webView;
	BOOL webViewLoaded;
}

- (void)load:(NSString *)html;
- (void)setLoading:(BOOL)value;

@end
