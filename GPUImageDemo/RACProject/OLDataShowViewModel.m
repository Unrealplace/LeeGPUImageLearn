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

//多个信号合并成一个信号,当其中一个信号发送数据时,组合信号也可以订阅到.
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

// 信号的联合
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

@end
