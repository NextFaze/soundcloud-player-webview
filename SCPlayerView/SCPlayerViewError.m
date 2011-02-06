//
//  SCPlayerViewError.m
//  soundcloud-player-webview
//
//  Created by Andrew on 5/02/11.
//  Copyright 2011 2moro mobile. All rights reserved.
//

#import "SCPlayerViewError.h"

#define ERROR_DOMAIN @"soundcloud-player-webview"

@implementation SCPlayerViewError

+ (NSError *)errorWithCode:(int)code description:(NSString *)description {
	// Make and return custom domain error.
	NSArray *objArray = [NSArray arrayWithObjects:description, nil];
	NSArray *keyArray = [NSArray arrayWithObjects:NSLocalizedDescriptionKey, nil];
	NSDictionary *eDict = [NSDictionary dictionaryWithObjects:objArray forKeys:keyArray];
	return [SCPlayerViewError errorWithDomain:ERROR_DOMAIN code:code userInfo:eDict];
}

+ (void)notifyDelegate:(id<SCPlayerViewControllerDelegate>)delegate error:(NSError *)error {
	if([delegate respondsToSelector:@selector(scplayerViewController:didFailLoadWithError:)])
		[delegate scplayerViewController:self didFailLoadWithError:error];
}

+ (void)notifyDelegate:(id<SCPlayerViewControllerDelegate>)delegate errorCode:(int)code description:(NSString *)description {
	NSError *error = [self errorWithCode:code description:description];
	[self notifyDelegate:delegate error:error];
}

@end
