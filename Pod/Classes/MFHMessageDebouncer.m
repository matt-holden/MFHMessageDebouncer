//
//  NSObject+MFHMessageDebouncer.m
//  MFHMessageDebouncerTest
//
//  Created by Matthew Holden on 9/12/14.
//  Copyright (c) 2014 Matt Holden. All rights reserved.
//

#import "MFHMessageDebouncer.h"
#import "MFHDebouncedMessageCenter.h"

@interface MFHDebouncedMessageProxy : NSObject
@property (nonatomic) NSTimeInterval delay;
@property (nonatomic) NSObject *proxiedObject;
@property (nonatomic) MFHDebouncedMessageCenter *messageCenter;

// Optional
@property (nonatomic) int  *callSiteToken;
@end

@implementation MFHDebouncedMessageProxy
+ (id)mfh_proxyForObject:(NSObject *)object delay:(NSTimeInterval)delay callSiteToken:(int*)callSiteToken
{
    MFHDebouncedMessageProxy *proxy = [[self.class alloc] init];
    [proxy setDelay:delay];
    [proxy setProxiedObject:object];
    [proxy setMessageCenter:[MFHDebouncedMessageCenter sharedCenter]];

    if (callSiteToken != NULL) {
        NSLog(@"USing call site token: %p", callSiteToken);
        NSLog(@"USing call site token: %d", *callSiteToken);
    }

    [proxy setCallSiteToken:callSiteToken];
    return proxy;
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    [invocation retainArguments];
    [invocation setTarget:self.proxiedObject];
    [self.messageCenter enqueueDebouncedInvocation:invocation delay:self.delay callSiteToken:self.callSiteToken];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
    return [self.proxiedObject methodSignatureForSelector:sel];
}

@end

@implementation NSObject (MFHMessageDebouncer)

- (instancetype)debounceWithDelay:(NSTimeInterval)delay
{
    return [MFHDebouncedMessageProxy mfh_proxyForObject:self delay:delay callSiteToken:NULL];
}

- (instancetype)debounceCallSite:(int*)callSiteToken delay:(NSTimeInterval)delay
{
    return [MFHDebouncedMessageProxy mfh_proxyForObject:self delay:delay callSiteToken:callSiteToken];
}

@end