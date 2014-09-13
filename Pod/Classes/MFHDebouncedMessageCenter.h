//
//  MFHDebouncedMessageCenter.h
//  MFHMessageDebouncerTest
//
//  Created by Matthew Holden on 9/12/14.
//  Copyright (c) 2014 Matt Holden. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MFHDebouncedMessageCenter : NSObject
+ (instancetype)sharedCenter;

- (void)cancelAllEnqueuedInvocations;
- (void)enqueueDebouncedInvocation:(NSInvocation *)invocation delay:(NSTimeInterval)delay callSiteToken:(int *)callSiteToken;
@end
