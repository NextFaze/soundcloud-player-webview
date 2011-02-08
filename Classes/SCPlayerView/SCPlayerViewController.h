//
//  SCPlayerWebViewController.h
//  soundcloud-player-webview
//
//  Created by Andrew Williams on 4/02/11.
//  Copyright 2011 2moro mobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCPlayerView.h"
#import "SCPlayerViewControllerDelegate.h"
#import "SCPlayerViewError.h"

@interface SCPlayerViewController : NSObject <UIWebViewDelegate> {
	SCPlayerView *view;
	NSString *clientKey;
	NSMutableData *apiResponse;
	id<SCPlayerViewControllerDelegate> delegate;
}

@property (nonatomic, retain) SCPlayerView *view;
@property (nonatomic, retain) NSString *clientKey;
@property (nonatomic, assign) id<SCPlayerViewControllerDelegate> delegate;

- (id)initWithFrame:(CGRect)f;

- (void)loadTrack:(NSString *)track;
- (void)loadPermalink:(NSString *)url;
- (void)loadHTMLObject:(NSString *)html;

@end

