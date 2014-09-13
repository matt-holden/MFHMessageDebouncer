//
//  MFHDebouncedMessageProxy.m
//  MFHMessageDebouncerTest
//
//  Created by Matthew Holden on 9/12/14.
//  Copyright (c) 2014 Matt Holden. All rights reserved.
//

#import "MFHDebouncedMessageProxy.h"
#import "MFHDebouncedMessageCenter.h"

@interface MFHDebouncedMessageProxy()
@property (nonatomic) NSTimeInterval delay;
@property (nonatomic) NSObject *proxiedObject;
@property (nonatomic) MFHDebouncedMessageCenter *messageCenter;
@end
@implementation MFHDebouncedMessageProxy
- (id)init { return self; /* Is this needed? */}

+ (id)mfh_proxyForObject:(NSObject *)object delay:(NSTimeInterval)delay
{
    MFHDebouncedMessageProxy *proxy = [[self.class alloc] init];
    [proxy setDelay:delay];
    [proxy setProxiedObject:object];
    [proxy setMessageCenter:[MFHDebouncedMessageCenter sharedCenter]];
    return proxy;
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    [invocation setTarget:self.proxiedObject];
    [self.messageCenter enqueueDebouncedInvocation:invocation delay:self.delay];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
    return [self.proxiedObject methodSignatureForSelector:sel];
}

@end
