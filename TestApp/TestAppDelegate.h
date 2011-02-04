//
//  TestAppDelegate.h
//  soundcloud-player-webview
//
//  Created by Andrew Williams on 5/10/10.
//  Copyright 2010 2moro mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestAppDelegate : NSObject <UIApplicationDelegate> {
	UINavigationController *navigationController;
	UIWindow *window;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end
