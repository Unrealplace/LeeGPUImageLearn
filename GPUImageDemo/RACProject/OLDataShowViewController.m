//
//  OLDataShowViewController.m
//  GPUImageDemo
//
//  Created by NicoLin on 2018/4/11.
//  Copyright © 2018年 NicoLin. All rights reserved.
//

#import "OLDataShowViewController.h"
#import "OLDataShowViewModel.h"

@interface OLDataShowViewController ()
//@property (nonatomic,strong)UITableView *
@property (nonatomic,strong)UIButton *getDataBtn;
@property (nonatomic,strong)OLDataShowViewModel *dataShowModel;
@property (nonatomic,strong)UIImageView *imgView;
@property (nonatomic,strong)UIImageView *imgView2;

@end

@implementation OLDataShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.getDataBtn];
    [self.view addSubview:self.imgView];
    [self.view addSubview:self.imgView2];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.subject sendNext:@{@"dataShow":@"showCompleted"}];
    
}

- (void)viewWillConfigureParameters {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.dataShowModel.errorSignal subscribeError:^(NSError *error) {
            NSLog(@"%@",error);
        }];
        
        [self.dataShowModel.neverSignal subscribeNext:^(id x) {
            NSLog(@"%@",x);
        }];
        
        [self.dataShowModel.dataShowSignal subscribeNext:^(id x) {
            NSLog(@"%@",x);
        }];
        
        [self.dataShowModel.emptySignal subscribeNext:^(id x) {
            NSLog(@"%@",x);

        } completed:^{
            
        }];
        
        [self.dataShowModel.returnSignal subscribeNext:^(id x) {
            NSLog(@"%@",x);
        } completed:^{
            
        }];
        
        [self.dataShowModel.concatSignal subscribeNext:^(id x) {
            NSLog(@"concat--->%@",x);
        }];
        
        [self.dataShowModel.conditionsSignal subscribeNext:^(id x) {
            NSLog(@"condition--->%@",x);
        } error:^(NSError *error) {
            NSLog(@"condition--->%@",error);
        }];
        
        [self.dataShowModel.mergeSignal subscribeNext:^(id x) {
            NSLog(@"merge--->%@",x);
        } error:^(NSError *error) {
            NSLog(@"merge--->%@",error);
        }];
        

        [self.dataShowModel.zipSignal subscribeNext:^(RACTuple *tuple) {
           //解包RACTuple中的对象
            RACTupleUnpack(NSString * A,NSString*B,NSString*C) = tuple;
            NSLog(@"%@---%@---%@",A,B,C);
            
        } error:^(NSError *error) {
            NSLog(@"zip--->%@",error);
        }];
        
        [self.dataShowModel.combineSignal subscribeNext:^(RACTuple *tuple) {
            
            RACTupleUnpack(NSString *A,NSString *B)=tuple;
            NSLog(@"combine--->%@----%@",A,B);

        }];
        
        [self.dataShowModel.combineReduceSignal subscribeNext:^(id x) {
            NSLog(@"combineReduce---->%@",x);
        }];
 
        RAC(self.imgView,image) = self.dataShowModel.startEagerlyWithSchedulerSignal;

        RAC(self.imgView2,image) = self.dataShowModel.startLazilyWithSchedulerSignal;

        
        [self.dataShowModel.retrySignal subscribeNext:^(id x) {
            NSLog(@"retry--->%@",x);
        }];
        
        [self.dataShowModel.conditionDependenceSignal subscribeNext:^(id x) {
            NSLog(@"conditionDependence--->%@",x);
        }];
        
        [self.dataShowModel.timerSignal subscribeNext:^(id x) {
            NSLog(@"timer--->%@",x);
        } error:^(NSError *error) {
            NSLog(@"timer--->%@",error);
        }];
        
        [self.dataShowModel.mapSignal subscribeNext:^(id x) {
            NSLog(@"map--->%@",x);
        }];
        
        [self.dataShowModel.flattenMapSignal subscribeNext:^(id x) {
            NSLog(@"flattenmap--->%@",x);
        }];
        
        [self.dataShowModel.mapReplaceSignal subscribeNext:^(id x) {
            NSLog(@"mapreplace---%@",x);
        }];
        
//        [[self.dataShowModel.flattenSignal flatten] subscribeNext:^(id x) {
//            NSLog(@"flatten--->%@",x);
//        }];
        
        [self.dataShowModel.filterSignal subscribeNext:^(id x) {
            NSLog(@"filter--->%@",x);
        }];
        [self.dataShowModel.ignoreSignal subscribeNext:^(id x) {
            NSLog(@"ingore--->%@",x);
        }];
        [self.dataShowModel.skipSignal subscribeNext:^(id x) {
            NSLog(@"skip--->%@",x);
        }];
        [self.dataShowModel.takeSignal subscribeNext:^(id x) {
            NSLog(@"take---->%@",x);
        }];
        [self.dataShowModel.takeUntilSignal subscribeNext:^(id x) {
            NSLog(@"takeUntil--->%@",x);
        }];
        [self.dataShowModel.distinctUntilChangedSignal subscribeNext:^(id x) {
            NSLog(@"distinct--->%@",(NSDictionary*)x);
        }];
    });
    
    
    
}


- (OLDataShowViewModel*)dataShowModel {
    if (!_dataShowModel) {
        _dataShowModel = [[OLDataShowViewModel alloc] init];
    }
    return _dataShowModel;
}

- (RACSubject*)subject {
    if (!_subject) {
        _subject = [RACSubject subject];
    }
    return _subject;
}

- (UIImageView*)imgView {
    if (!_imgView) {
        _imgView = [UIImageView new];
        _imgView.frame = CGRectMake(10, 100, 100, 100);
    }
    return _imgView;
}

- (UIImageView*)imgView2 {
    if (!_imgView2) {
        _imgView2 = [UIImageView new];
        _imgView2.frame = CGRectMake(10, 200, 100, 100);
    }
    return _imgView2;
}
- (UIButton*)getDataBtn {
    if (!_getDataBtn) {
        _getDataBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _getDataBtn.backgroundColor = [UIColor redColor];
        _getDataBtn.frame = CGRectMake(0, 0, 100, 100);
        _getDataBtn.center = self.view.center;
        [[_getDataBtn rac_signalForControlEvents:UIControlEventAllEvents] subscribeNext:^(id x) {
           
           
        }];
    }
    return _getDataBtn;
}


@end
