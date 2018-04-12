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
@property (nonatomic,strong)RACSignal *startEagerlyWithSchedulerSignal;
@property (nonatomic,strong)RACSignal *startLazilyWithSchedulerSignal;
@property (nonatomic,strong)RACSignal *zipSignal;
@property (nonatomic,strong)RACSignal *conditionsSignal;
@property (nonatomic,strong)RACSignal *mergeSignal;
@property (nonatomic,strong)RACSignal *combineSignal;
@property (nonatomic,strong)RACSignal *combineReduceSignal;
@property (nonatomic,strong)RACSignal *timerSignal;
@property (nonatomic,strong)RACSignal *retrySignal;
@property (nonatomic,strong)RACSignal *conditionDependenceSignal;

//2. RACStream(Operation)介绍
//（a）flattenMap：在bind基础上封装的改变方法，用自己提供的block，改变当前流，变成block返回的流对象。
//（b）flatten：在flattenMap基础封装的改变方法，如果当前反应流中的对象也是一个流的话，就可以将当前流变成当前流中的流对象
//（c）map：在flattenMap基础上封装的改变方法，在flattenMap中的block中返回的值必须也是流对象，而map则不需要，它是将流中的对象执行block后，用流的return方法将值变成流对象。
//（d）mapReplace：在map的基础上封装的改变方法，直接替换当前流中的对象，形成一个新的对象流。
//（e）filter：在Map基础上封装的改变封装，过滤掉当前流中不符合要求的对象，将之变为空流
//（f）ignore：在filter基础封装的改变方法，忽略和当前值一样的对象，将之变为空流
//（g）skip：在bind基础上封装的改变方法，忽略当前流前n次的对象值，将之变为空流
//（l）skipUntilBlock：在bind基础封装的改变方法，忽略当前流的对象值（变为空流），直到当前值满足提供的block。
//（m）skipWhileBlock：在bind基础封装的改变方法，忽略当前流的对象值（变为空流），直到当前值不满足提供的block

//（h）take：在bind基础上封装的改变方法，只区当前流中的前n次对象值，之后将流变为空（不是空流）。
//（j）takeUntilBlock：在bind基础封装的改变方法，取当前流的对象值，直到当前值满足提供的block，就会将当前流变为空（不是空流）
//（k）takeWhileBlock：在bind基础封装的改变方法，取当前流的对象值，直到当前值不满足提供的block，就会将当前流变为空（不是空流）

//（i）distinctUntilChanged：在bind基础封装的改变方法，当流中后一次的值和前一次的值不同的时候，才会返回当前值的流，否则返回空流（第一次默认被忽略）


//（n）scanWithStart：reduceWithIndex：在bind基础封装的改变方法，用同样的block执行每次流中的值，并将结果用于后一次执行当中，每次都把block执行后的值变成新的流中的对象。
//（o）startWIth：在contact基础上封装的多流之间的顺序方法，在当前流的值流出之前，加入一个初始值
//（q）reduceEach：将流中的RACTuple对象进行过滤，返回特定的衍生出的一个值对象

@property (nonatomic,strong)RACSignal *mapSignal;
@property (nonatomic,strong)RACSignal *flattenMapSignal;
@property (nonatomic,strong)RACSignal *flattenSignal;
@property (nonatomic,strong)RACSignal *mapReplaceSignal;
@property (nonatomic,strong)RACSignal *filterSignal;
@property (nonatomic,strong)RACSignal *ignoreSignal;
@property (nonatomic,strong)RACSignal *skipSignal;
@property (nonatomic,strong)RACSignal *takeSignal;
@property (nonatomic,strong)RACSignal *takeUntilSignal;
@property (nonatomic,strong)RACSignal *distinctUntilChangedSignal;
@property (nonatomic,strong)RACSignal *startWithSignal;

@end
