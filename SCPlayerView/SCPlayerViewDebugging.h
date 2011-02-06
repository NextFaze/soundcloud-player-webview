//
//  SCPlayerViewDebugging.h
//  soundcloud-player-webview
//
//  Created by Andrew on 6/02/11.
//  Copyright 2011 2moro mobile. All rights reserved.
//

#ifdef SCPLAYER_DEBUG
#define SCPLAYER_LOG(format, ...) NSLog(@"%s:%@", __PRETTY_FUNCTION__,[NSString stringWithFormat:format, ## __VA_ARGS__])
#else
#define SCPLAYER_LOG(format, ...)
#endif
