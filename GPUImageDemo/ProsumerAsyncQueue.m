//
//  ProsumerAsyncQueue.m
//  beautyCamera
//
//  Created by lion on 13-12-18.
//
//

#import "ProsumerAsyncQueue.h"

static BOOL _isDone = NO;
static float _newValue = 0.0f;

@implementation ProsumerAsyncQueue

+ (void)begin:(ProsumerBlock)begin dealWithValue:(float)value process:(ProsumerBlock)process  finishEvery:(ProsumerBlock)finish1 finishOnce:(ProsumerBlock)finish2
{
    dispatch_queue_t serialQueue = dispatch_queue_create("serialQueue", DISPATCH_QUEUE_SERIAL);
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    dispatch_async(serialQueue, ^{
        @autoreleasepool {
            dispatch_async(dispatch_get_main_queue(), ^{
                begin();
            });
            
            [ProsumerAsyncQueue prosumer:value block:process];
            dispatch_async(dispatch_get_main_queue(), ^{
                finish1();
                if (!_isDone) finish2();
            });
        }
    });
    
}

+ (void)prosumer:(float)value block:(ProsumerBlock)block
{
    _newValue = value;//会一直刷新
    
    //手没松开
    if (!_isDone) {
        _isDone = YES;
         [self iterationBlock:(value) block:block];
        _isDone = NO;
    }
}


//迭代
+ (void)iterationBlock:(float)value block:(ProsumerBlock)block {
    float tmpValue = value;
    @autoreleasepool {
        block();
    }
    if (!isFloatEqual(tmpValue, _newValue)) {
        [self iterationBlock:(_newValue) block:block];
    }
}

@end
