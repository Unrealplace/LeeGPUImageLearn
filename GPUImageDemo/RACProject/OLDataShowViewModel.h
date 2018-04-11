//
//  OLDataShowViewModel.h
//  GPUImageDemo
//
//  Created by NicoLin on 2018/4/11.
//  Copyright © 2018年 NicoLin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface OLDataShowViewModel : NSObject

@property (nonatomic,strong)RACSignal *dataShowSignal;
@property (nonatomic,strong)RACSignal *errorSignal;
@property (nonatomic,strong)RACSignal *neverSignal;
@property (nonatomic,strong)RACSignal *emptySignal;
@property (nonatomic,strong)RACSignal *returnSignal;
@property (nonatomic,strong)RACSignal *concatSignal;
@property (nonatomic,strong)RACSignal *zipSignal;
@property (nonatomic,strong)RACSignal *conditionsSignal;
@property (nonatomic,strong)RACSignal *mergeSignal;
@property (nonatomic,strong)RACSignal *combineSignal;

@end
