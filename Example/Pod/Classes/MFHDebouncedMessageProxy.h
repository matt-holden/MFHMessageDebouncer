//
//  MFHDebouncedMessageProxy.h
//  MFHMessageDebouncerTest
//
//  Created by Matthew Holden on 9/12/14.
//  Copyright (c) 2014 Matt Holden. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MFHDebouncedMessageProxy : NSObject
+ (id)mfh_proxyForObject:(NSObject *)object delay:(NSTimeInterval)delay;
@end
