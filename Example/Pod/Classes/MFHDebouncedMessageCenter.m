//
//  MFHDebouncedMessageCenter.h
//  MFHMessageDebouncerTest
//
//  Created by Matthew Holden on 9/12/14.
//  Copyright (c) 2014 Matt Holden. All rights reserved.
//

#import "MFHDebouncedMessageCenter.h"
#import <objc/runtime.h>

@interface NSTimer(WeakThreadReference_)
@property (nonatomic, weak) NSThread *scheduledThread;
@end
static char mfh_timerRefKey;
@implementation NSTimer(WeakThreadReference_)
- (void)setScheduledThread:(NSThread *)scheduledThread
{
    objc_setAssociatedObject(self, &mfh_timerRefKey, scheduledThread, OBJC_ASSOCIATION_ASSIGN);
}
- (NSThread *)scheduledThread
{
    return objc_getAssociatedObject(self, &mfh_timerRefKey);
}
@end

/** Utility function to construct the key that will reference an invocation when added
 to a MFHDebouncedMessageCenter's _delayedMessageTimers dictionary */
NSString * MFHLookupIdentifierForInvocation(NSInvocation *invocation) {
    id target = invocation.target;
    IMP function = [invocation.target methodForSelector:invocation.selector];
    return [NSString stringWithFormat:@"t:%p|IMP:%p", &target, function];
}

@implementation MFHDebouncedMessageCenter {
    NSMapTable *_delayedMessageTimers;
    dispatch_queue_t _serialDictionaryMutationQueue;
}

+ (instancetype)sharedCenter
{
    static dispatch_once_t onceToken;
    static id me;
    dispatch_once(&onceToken, ^{
        me = [[self.class alloc] init];
    });
    return me;
}

- (id)init
{
    self = [super init];
    // We're storing the timers in NSMapTable because entries will be
    // removed automatically when either the value is deallocated,
    // This is so we don't have to remove a timer from the queue after it fires
    _delayedMessageTimers = [NSMapTable mapTableWithKeyOptions:NSMapTableStrongMemory
                                                  valueOptions:NSMapTableWeakMemory];
    _serialDictionaryMutationQueue = dispatch_queue_create("me.mattholden.MFHDebouncedMessageCenterManipulationQueue", DISPATCH_QUEUE_SERIAL);
    return self;
}

- (void)cancelAllEnqueuedInvocations
{
    dispatch_barrier_async(_serialDictionaryMutationQueue, ^{
        for (NSTimer *t in _delayedMessageTimers) {
            [t invalidate];
        }
    });
}

- (void)enqueueDebouncedInvocation:(NSInvocation *)invocation delay:(NSTimeInterval)delay
{
    NSThread *outerThreadRef = [NSThread currentThread];
    NSRunLoop *outerRunLoopRef = [NSRunLoop currentRunLoop];
    NSString *lookupKey = MFHLookupIdentifierForInvocation(invocation);

    dispatch_sync(_serialDictionaryMutationQueue, ^{
        NSTimer *storedTimer = [_delayedMessageTimers objectForKey:lookupKey];
        if (storedTimer) {
            // The NSTimer documentation states that 'invalidate' must be run from the thread
            // that created the timer
            [storedTimer performSelector:@selector(invalidate) onThread:outerThreadRef withObject:nil waitUntilDone:NO];
        }

        dispatch_async(_serialDictionaryMutationQueue, ^{
        // Add to the queue immediately
            NSTimer *timer = [NSTimer timerWithTimeInterval:delay invocation:invocation repeats:NO];
            [timer setScheduledThread:outerThreadRef];
            [outerRunLoopRef addTimer:timer forMode:NSDefaultRunLoopMode];
            [_delayedMessageTimers setObject:timer forKey:lookupKey];
        });
    });
}

#pragma mark 'delayedMessage' dictionary (requires thread safety)

@end
