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
@end
