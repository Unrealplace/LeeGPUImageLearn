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

@end

@implementation OLDataShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.getDataBtn];
    
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
