//
//  SCPlayerView.h
//  soundcloud-player-webview
//
//  Created by Andrew Williams on 4/02/11.
//  Copyright 2011 2moro mobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCPlayerViewDebugging.h"

#define SCPlayerViewHeight 32

@interface SCPlayerView : UIView {
	UIActivityIndicatorView *activityView;
	UIWebView *webView;
}

@property (nonatomic, assign) id<UIWebViewDelegate> delegate;

- (void)load:(NSString *)html;
- (void)setLoading:(BOOL)value;
- (void)setActivityStyle:(UIActivityIndicatorViewStyle)style;

@end
