//
//  SCPlayerViewError.h
//  soundcloud-player-webview
//
//  Created by Andrew on 5/02/11.
//  Copyright 2011 2moro mobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCPlayerViewControllerDelegate.h"

@interface SCPlayerViewError : NSError {

}

+ (SCPlayerViewError *)errorWithCode:(int)code description:(NSString *)description;
+ (void)notifyDelegate:(id<SCPlayerViewControllerDelegate>)delegate error:(NSError *)error;
+ (void)notifyDelegate:(id<SCPlayerViewControllerDelegate>)delegate errorCode:(int)code description:(NSString *)description;

@end
