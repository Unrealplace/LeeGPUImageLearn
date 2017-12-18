//
//  ProsumerAsyncQueue.h
//  beautyCamera
//
//  功能：生产者消费者异步队列
//
//  Created by lion on 13-12-18.
//
//

#import <Foundation/Foundation.h>

#define isFloatEqual(value1, value2) ((value1 > value2 - 0.001) && (value1 < value2 + 0.001))\

typedef void(^ProsumerBlock)(void);

@interface ProsumerAsyncQueue : NSObject

+ (void)begin:(ProsumerBlock)begin dealWithValue:(float)value process:(ProsumerBlock)process  finishEvery:(ProsumerBlock)finish1 finishOnce:(ProsumerBlock)finish2;

@end
