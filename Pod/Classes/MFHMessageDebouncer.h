//
//  NSObject+MFHMessageDebouncer.h
//  MFHMessageDebouncerTest
//
//  Created by Matthew Holden on 9/12/14.
//  Copyright (c) 2014 Matt Holden. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (MFHMessageDebouncer)
- (instancetype)debounceWithDelay:(NSTimeInterval)delay;

/** 
 Used to debounce all messages originating from a speicifc call site,
 regardles of the specific object instance receiving the message.

 Only the last receiver to receive a message before the delay expires will receive a message.
 
 @notes Do not use this method directly, instead, use the convenience MFHDebouncerForCallSite(...) macro
 */
- (instancetype)debounceCallSite:(int*)callSiteToken delay:(NSTimeInterval)delay;
@end

#define MFHDebouncedCallSite(_receiver, _delay)         \
    ({                                                  \
        static int __mfh_token__;                       \
        [(_receiver) debounceCallSite:(&__mfh_token__)  \
                                delay:(_delay)];        \
    })