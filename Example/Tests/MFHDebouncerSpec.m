//
//  MFHMessageDebouncerSpec.m
//  MFHMessageDebouncer
//
//  Created by Matthew Holden on 9/13/14.
//  Copyright 2014 Matthew Holden. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "MFHMessageDebouncer.h"


SPEC_BEGIN(NSObject_MFHMessageDebouncer_Category_Spec)

describe(@"MFHMessageDebouncer", ^{
    context(@"the debounceWithDelay method", ^{
        it(@"should let me debounce an instance of an object", ^{
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

        context(@"should not be affected by multiple invocations from the same call site (when in a loop) to different instances", ^{
            __block NSArray *arrayInstances;
            __block NSTimeInterval delayLength;
            beforeEach(^{
                delayLength = .1f;
                arrayInstances = @[[NSMutableArray new], [NSMutableArray new], [NSMutableArray new]];

                for (int i = 0; i < 3; i++) {
                    for (int j = 0; j < 3; j++) {
                        [[arrayInstances[i] debounceWithDelay:delayLength] addObject:@(j)];
                    }
                }
            });

            it (@"should ignore multiple invocations that happen before the interval has expired", ^{
                // Each array should have one object
                [[expectFutureValue(theValue([arrayInstances[0] count])) shouldEventuallyBeforeTimingOutAfter(delayLength + 1.f)] equal:theValue(1)];
                [[theValue([arrayInstances[1] count]) should] equal:theValue(1)];
                [[theValue([arrayInstances[2] count]) should] equal:theValue(1)];
            });

            it (@"should only care about the final method call", ^{
                // We attempted to insert 0, 1, 2... so we're expecting the *only* object in the array
                // to be the number "2"
                [[expectFutureValue([arrayInstances[0] lastObject]) shouldEventuallyBeforeTimingOutAfter(delayLength + .01)] equal:@2];
                [[expectFutureValue([arrayInstances[1] lastObject]) shouldEventuallyBeforeTimingOutAfter(delayLength + .01)] equal:@2];
                [[expectFutureValue([arrayInstances[2] lastObject]) shouldEventuallyBeforeTimingOutAfter(delayLength + .01)] equal:@2];
            });
        });

        context(@"should allow invocations to any object instance from a single call site to be debounced, resulting"
               "in only the final message being sent to the final receiver after the delay", (^{
            NSArray *arrayInstances = @[[NSMutableArray new], [NSMutableArray new], [NSMutableArray new]];

            NSTimeInterval delay = .05;
            for (int i = 0; i < 3; i++) {
                [MFHDebouncedCallSite(arrayInstances[i], .1) addObject:@(i)];
            }

            // Only the last object that was messaged should have received 'addObject:'
            [[expectFutureValue(arrayInstances[2]) shouldEventuallyBeforeTimingOutAfter((delay * 2.))] haveCountOf:1];
            // No need to wait for final two tests since the above test caused a delay
            [[arrayInstances[1] should] haveCountOf:0];
            [[arrayInstances[0] should] haveCountOf:0];

        }));
    });
});

SPEC_END
