//
//  MFHMessageDebouncerSpec.m
//  MFHMessageDebouncer
//
//  Created by Matthew Holden on 9/13/14.
//  Copyright 2014 Matthew Holden. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "NSObject+MFHMessageDebouncer.h"


SPEC_BEGIN(NSObject_MFHMessageDebouncer_Category_Spec)

describe(@"MFHMessageDebouncer", ^{
    it(@"should let me do this and then I'm going to bed", ^{
        NSMutableArray *myArray = [NSMutableArray new];
        NSTimeInterval const t = .1;
        [[myArray debounceWithDelay:t] addObject:@1];
        [[myArray debounceWithDelay:t] addObject:@2];
        [[myArray debounceWithDelay:t] addObject:@3];
        [[myArray debounceWithDelay:t] addObject:@4];
        [[myArray debounceWithDelay:t] addObject:@5];

        [[theValue([myArray count]) should] equal:theValue(0)];

        [[expectFutureValue(theValue([myArray count])) shouldEventuallyBeforeTimingOutAfter(t + .1)] equal:theValue(1)];
        [[[myArray firstObject] should] equal:@5];


    });
});

SPEC_END
