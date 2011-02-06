//
//  SCPlayerViewControllerDelegate.h
//  soundcloud-player-webview
//
//  Created by Andrew Williams on 5/02/11.
//  Copyright 2011 2moro mobile. All rights reserved.
//

@class SCPlayerViewController;

@protocol SCPlayerViewControllerDelegate <NSObject>

@optional
- (void)scplayerViewController:(SCPlayerViewController *)scpvc didFailLoadWithError:(NSError *)error;
- (void)scplayerViewControllerDidFinishLoad:(SCPlayerViewController *)scpvc;

@end

