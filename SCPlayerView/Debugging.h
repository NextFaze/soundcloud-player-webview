//
//  Debugging.h
//
//  Created by Andrew Williams on 14/09/10.
//  Copyright 2010 2moro mobile. All rights reserved.
//

// "DEBUG=1" needs to be added to the "Preprocessor Macros" for the Debug configuration

#ifdef DEBUG
	#define LOG_MEMORY_STATS [Debugging printMemoryStats]
	#define LOG(format, ...) NSLog(@"%s:%@", __PRETTY_FUNCTION__,[NSString stringWithFormat:format, ## __VA_ARGS__])
#else
	#define LOG_MEMORY_STATS
	#define LOG(format, ...)
#endif


#import <Foundation/Foundation.h>

@interface Debugging : NSObject {
	
}

+(void) printMemoryStats;

@end
