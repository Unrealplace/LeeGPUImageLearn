//
//  OLDataShowViewModel.m
//  GPUImageDemo
//
//  Created by NicoLin on 2018/4/11.
//  Copyright © 2018年 NicoLin. All rights reserved.
//

#import "OLDataShowViewModel.h"

@interface OLDataShowViewModel()
@property (nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation OLDataShowViewModel

- (instancetype)init {
    if (self = [super init]) {
        self.dataArray = @[].mutableCopy;
    }
    return self;
}

- (RACSignal*)dataShowSignal {
    if (!_dataShowSignal) {
        
        _dataShowSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [self.dataArray addObject:@"666"];
            [subscriber sendNext:self.dataArray];
            [subscriber sendCompleted];
//            RACDisposable:用于取消订阅或者清理资源，当信号发送完成或者发送错误的时候，就会自动触发它。
            return [RACDisposable disposableWithBlock:^{
                [self.dataArray removeAllObjects];
            }];
        }];
       
    }
    return _dataShowSignal;
}
// 信号一被订阅 就会发出error
- (RACSignal*)errorSignal {
    if (!_errorSignal) {
        _errorSignal = [RACSignal error:[NSError errorWithDomain:NSCocoaErrorDomain code:1004 userInfo:@{@"error":@"error"}]];
    }
    return _errorSignal;
}
// 永远不会被执行的信号
- (RACSignal*)neverSignal {
    if (!_neverSignal) {
        _neverSignal = [RACSignal never];
    }
    return _neverSignal;
}

// 空信号
- (RACSignal*)emptySignal {
    if (!_emptySignal) {
        _emptySignal = [RACSignal empty];
    }
    return _emptySignal;
}
//直接返回值的信号
- (RACSignal*)returnSignal {
    if (!_returnSignal) {
        _returnSignal = [RACSignal return:@"this is a return signal"];
    }
    return _returnSignal;
}
// 合并多个信号一个一个有序执行,当任意一个信号发生错误后后面的信号不在执行了
- (RACSignal*)concatSignal {
    if (!_concatSignal) {
        _concatSignal = [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [subscriber sendNext:@"1111"];
                [subscriber sendCompleted];
            });
           
            return nil;
        }] concat:[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [subscriber sendError:[NSError errorWithDomain:NSCocoaErrorDomain code:101010 userInfo:nil]];
                [subscriber sendCompleted];
            });
          
            return nil;
        }]] concat:[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [subscriber sendNext:@"3333"];
                [subscriber sendCompleted];
            });
            return nil;
        }]];
    }
    return _concatSignal;
}
//说明：这段代码会在后台线程立即发起一个请求，然后传递到主线程上更新UI，主线程上执行[RACScheduler mainThreadScheduler]，信号传递:- (RACSignal *)deliverOn:(RACScheduler *)scheduler
- (RACSignal*)startEagerlyWithSchedulerSignal {
    if (!_startEagerlyWithSchedulerSignal) {
        _startEagerlyWithSchedulerSignal = [[RACSignal startEagerlyWithScheduler:[RACScheduler schedulerWithPriority:RACSchedulerPriorityBackground name:@"rac_getimage_name"] block:^(id<RACSubscriber> subscriber) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [subscriber sendNext:[UIImage imageNamed:@"girl2"]];
                [subscriber sendCompleted];
            });
            
        }] deliverOn:[RACScheduler mainThreadScheduler]];
    }
    return _startEagerlyWithSchedulerSignal;
}
// start Eagerly 内部就是 startLazily 实现的 
- (RACSignal*)startLazilyWithSchedulerSignal {
    if (!_startLazilyWithSchedulerSignal) {
        _startLazilyWithSchedulerSignal = [[RACSignal startLazilyWithScheduler:[RACScheduler schedulerWithPriority:RACSchedulerPriorityBackground name:@"rac_getimage_name_www"] block:^(id<RACSubscriber> subscriber) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [subscriber sendNext:[UIImage imageNamed:@"girl2"]];
                [subscriber sendCompleted];
            });
            
        }] deliverOn:[RACScheduler mainThreadScheduler]];
    }
    return _startLazilyWithSchedulerSignal;
}

// 多个信号压缩 成一个信号最后执行完毕后发送所有信号的最终结果
- (RACSignal*)zipSignal {
    
    if (!_zipSignal) {
        RACSignal*signal1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@"zip---signal1"];
            [subscriber sendCompleted];
            return nil;
        }];
        RACSignal*signal2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@"zip---signal2"];
            [subscriber sendCompleted];
            return nil;
        }];
        RACSignal*signal3 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@"zip---signal3"];
            [subscriber sendCompleted];
            return nil;
        }];
        _zipSignal = [[signal1 zipWith:signal2] zipWith:signal3];
    }
    return _zipSignal;
    
}

//信号的条件执行,只有最后一个信号会被订阅并执行，其它的信号之后被执行,任意信号出错就不会再往下走啦
- (RACSignal*)conditionsSignal {
    
    if (!_conditionsSignal) {
        RACSignal*signal1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//            [subscriber sendNext:@"signal1"];
            [subscriber sendError:[NSError errorWithDomain:NSCocoaErrorDomain code:233535 userInfo:nil]];
            [subscriber sendCompleted];
            return nil;
        }];
        RACSignal*signal2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@"signal2"];
            [subscriber sendCompleted];
            return nil;
        }];
        RACSignal*signal3 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@"signal3"];
            [subscriber sendCompleted];
            return nil;
        }];
        
       _conditionsSignal = [signal1 then:^RACSignal *{
            return [signal3 then:^RACSignal *{
                return signal2;
            }];
        }] ;
    }
    return _conditionsSignal;
    
}

//多个信号合并成一个信号,当其中一个信号发送数据时,组合信号也可以订阅到.就是任意一个信号完成都会触发。
- (RACSignal*)mergeSignal {
    if (!_mergeSignal) {
        RACSignal *signal1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@"merge signal1"];
            [subscriber sendCompleted];
            return nil;
        }];
        RACSignal *signal2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@"merge signal2"];
            [subscriber sendCompleted];
            return nil;
        }];
        RACSignal *signal3 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendError:[NSError errorWithDomain:NSURLErrorDomain code:9701701 userInfo:nil]];
            [subscriber sendCompleted];
            return nil;
        }];
        _mergeSignal = [[signal1 merge:signal2] merge:signal3];
    }
    return _mergeSignal;
}

// 信号的联合 联合之后直接收每个信号的最新的发布内容 ，比如说发布了多个信息，最后一个会显示出来。
- (RACSignal*)combineSignal {
    if (!_combineSignal) {
        RACSignal *signal1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@"combineSignal signal1"];
            [subscriber sendNext:@"combineSignal signal11"];

            [subscriber sendCompleted];
            return nil;
        }];
        RACSignal *signal2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@"combineSignal signal2"];
            [subscriber sendCompleted];
            return nil;
        }];
        _combineSignal = [RACSignal combineLatest:@[signal1,
                                                    signal2]];
    }
    return _combineSignal;
}
// 信号联合后自动拆包得到订阅内容
- (RACSignal*)combineReduceSignal {
    if (!_combineReduceSignal) {
        RACSignal *signal1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@"combineSignalReduce signal1"];
            [subscriber sendNext:@"combineSignalReduce signal11"];
            
            [subscriber sendCompleted];
            return nil;
        }];
        RACSignal *signal2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@"combineSignalReduce signal2"];
            [subscriber sendCompleted];
            return nil;
        }];
        RACSignal *signal3 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@"combineSignalReduce signal3"];
            return nil;
        }];
        // 自动拆包
        _combineReduceSignal = [RACSignal combineLatest:@[signal1,
                                                          signal2,
                                                          signal3]
                                                 reduce:^id(NSString *signal1,NSString*signal2,NSString*signal3){
                                                     return [[signal3 stringByAppendingString:signal2] stringByAppendingString:signal1];
        }];
    }
    return _combineReduceSignal;
}
//设置timer 的 超时
- (RACSignal*)timerSignal {
    if (!_timerSignal) {
       
        //超时操作
        _timerSignal = [[RACSignal createSignal:^RACDisposable *(id subscriber) {
            
            [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [subscriber sendNext:@"timer doing"];
                [subscriber sendCompleted];
                return nil;
            }] delay:5] subscribeNext:^(id x) {
                NSLog(@"timer ending i am coming ~~~");
            }]  ;
            return nil;
        }] timeout:3 onScheduler:[RACScheduler mainThreadScheduler]];
    }
    return _timerSignal;
}
//当信号设置error后重新执行 知道成功
- (RACSignal*)retrySignal {
    if (!_retrySignal) {
      __block  int num = 10;
        _retrySignal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            while (num>0) {
                num--;
                [subscriber sendError:[NSError errorWithDomain:NSURLErrorDomain code:10101 userInfo:nil]];
            }
            [subscriber sendNext:@"retry end"];
            return nil;
        }]retry] ;
    }
    return _retrySignal;
}

- (RACSignal*)conditionDependenceSignal {
    if (!_conditionDependenceSignal) {
        _conditionDependenceSignal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            //每一秒执行一次
            [[RACSignal interval:1 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {
                [subscriber sendNext:@"定时执行啦～～"];
            }];
            
            return nil;
            // 依赖的条件执行效果
        }] takeUntil:[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [subscriber sendNext:@"你的定时任务可以停下啦～"];
                [subscriber sendCompleted];
            });
            return nil;
        }]] ;
    }
    return _conditionDependenceSignal;
}

//1.FlatternMap中的Block返回信号。
//2.Map中的Block返回对象。
//3.开发中，如果信号发出的值不是信号，映射一般使用Map
//4.开发中，如果信号发出的值是信号，映射一般使用FlatternMap。
//（c）map：在flattenMap基础上封装的改变方法，在flattenMap中的block中返回的值必须也是流对象，而map则不需要，它是将流中的对象执行block后，用流的return方法将值变成流对象。
- (RACSignal*)mapSignal {
    if (!_mapSignal) {
        _mapSignal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSString * name = @"oliver lee come form america";
            [subscriber sendNext:name];
            [subscriber sendCompleted];
            return nil;
        }] map:^id(id value) {
            NSLog(@"map----->%@",value);
            return [value stringByAppendingString:@"from china~~~"];
        }];
    }
    return _mapSignal;
}
//在flattenMap中的block中返回的值必须也是流对象
- (RACSignal*)flattenMapSignal {
    if (!_flattenMapSignal) {
        _flattenMapSignal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSString *name = @"flatten map signal ---";
            [subscriber sendNext:name];
            [subscriber sendCompleted];
            return nil;
        }] flattenMap:^RACStream *(id value) {// 这样好像没有什么作用，有空看下内部原理
            //复杂的使用下
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [subscriber sendNext:[value stringByAppendingString:@"+signal-----signal"]];
                [subscriber sendCompleted];
                return nil;
            }];
            //简单使用一下
//            return [RACSignal return:[value stringByAppendingString:@"this is flatten map use method"]];
        }] ;
    }
    return _flattenMapSignal;
}

- (RACSignal*)flattenSignal {
    if (!_flattenSignal) {
        RACSignal*signal1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@"1"];
            [subscriber sendCompleted];
            return nil;
        }];
        RACSignal*signal2 =[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@"2"];
            [subscriber sendCompleted];
            return nil;
        }];
        RACSignal*signal3 =[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@"3"];
            [subscriber sendCompleted];
            return nil;
        }];
       _flattenSignal =  [[signal1 merge:signal2] merge:signal3];
    }
    return _flattenSignal;
}

//原来的信号被新的信号替换掉
- (RACSignal*)mapReplaceSignal {
    if (!_mapReplaceSignal) {
        _mapReplaceSignal = [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@"not---replace--signal"];
            [subscriber sendCompleted];
            return nil;
        }] mapReplace:[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            [subscriber sendNext:@"replace--signal"];
            [subscriber sendCompleted];
            return nil;
        }]] flatten] ; //信号流中的最后的信号
    }
    return _mapReplaceSignal;
}

// filter 的使用方法
- (RACSignal*)filterSignal {
    if (!_filterSignal) {
        _filterSignal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
           
            for (int i = 0; i<100; i++) {
                [subscriber sendNext:@(i)];
            }
            [subscriber sendCompleted];
            return nil;
        }] filter:^BOOL(id value) {
            return [value intValue]%2 == 0;
        }];
    }
    return _filterSignal;
}

- (RACSignal*)ignoreSignal {
    if (!_ignoreSignal) {
        _ignoreSignal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSArray * numArr = @[@"1",@"1",@"2",@"2"];
            for (int i =0; i< numArr.count; i++) {
                [subscriber sendNext:numArr[i]];
            }
            [subscriber sendCompleted];
            return nil;
        }]ignore:@"1"] ;
    }
    return _ignoreSignal;
}

- (RACSignal*)skipSignal {
    if (!_skipSignal) {
        _skipSignal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            for (int i =0; i<10; i++) {
                [subscriber sendNext:@(i)];
            }
            [subscriber sendCompleted];
            return nil;
        }]skipUntilBlock:^BOOL(id x) {
            return [x intValue]>5;
        }] ;
    }
    return _skipSignal;
}

- (RACSignal*)takeSignal {
    if (!_takeSignal) {
        _takeSignal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            for (int i =0; i<10; i++) {
                [subscriber sendNext:@(i)];
            }
            [subscriber sendCompleted];
            return nil;
        }]take:5] ;
    }
    return _takeSignal;
}

- (RACSignal*)takeUntilSignal {
    if (!_takeUntilSignal) {
        _takeUntilSignal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            for (int i =0; i<10; i++) {
                [subscriber sendNext:@(i)];
            }
            return nil;
        }]takeUntilBlock:^BOOL(id x) { //取多次流直到满足条件
            return [x intValue]==6;
        }] ;
    }
    return _takeUntilSignal;
}

- (RACSignal*)distinctUntilChangedSignal {
    if (!_distinctUntilChangedSignal) {
        _distinctUntilChangedSignal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            for (int i =0; i<5; i++) {
                [subscriber sendNext:@{@"num":@(i)}];
            }
            [subscriber sendCompleted];
            return nil;
        }] distinctUntilChanged] ;
    }
    return _distinctUntilChangedSignal;
}

//- (RACSignal*)startWithSignal {
//    if (!_startWithSignal) {
//        _startWithSignal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//            
//            return nil;
//        }] aggregateWithStart:nil reduceWithIndex:^id(id running, id next, NSUInteger index) {
//            
//        }];
//    }
//}

@end
