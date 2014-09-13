//
//  NSObject+MFHMessageDebouncer.m
//  MFHMessageDebouncerTest
//
//  Created by Matthew Holden on 9/12/14.
//  Copyright (c) 2014 Matt Holden. All rights reserved.
//

#import "NSObject+MFHMessageDebouncer.h"
#import "MFHDebouncedMessageProxy.h"

@interface MFHDebouceProxy_
@end

@implementation NSObject (MFHMessageDebouncer)

- (instancetype)debounceWithDelay:(NSTimeInterval)delay
{
    return [MFHDebouncedMessageProxy mfh_proxyForObject:self delay:delay];
}
@end
