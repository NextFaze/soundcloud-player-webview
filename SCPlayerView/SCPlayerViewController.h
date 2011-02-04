//
//  SCPlayerWebViewController.h
//  soundcloud-player-webview
//
//  Created by Andrew Williams on 4/02/11.
//  Copyright 2011 2moro mobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCPlayerView.h"

@interface SCPlayerViewController : NSObject {
	SCPlayerView *view;
	NSString *clientKey;
	NSMutableData *apiResponse;
}

@property (nonatomic, retain) SCPlayerView *view;
@property (nonatomic, retain) NSString *clientKey;

- (id)initWithWidth:(CGFloat)width;

- (void)loadTrack:(NSString *)track;

@end
