//
//  OLLoginViewModel.m
//  GPUImageDemo
//
//  Created by NicoLin on 2018/4/10.
//  Copyright © 2018年 NicoLin. All rights reserved.
//

#import "OLLoginViewModel.h"

@interface OLLoginViewModel ()

@end
@implementation OLLoginViewModel

- (void)dealloc {
    
}

- (instancetype)init {
    if (self = [super init]) {
        //直接监听变化并打印
        [RACObserve(self, userName) subscribeNext:^(id x) {
            NSLog(@"%@",x);
        } error:^(NSError *error) {
            NSLog(@"%@",error);
        }];
        
        // 当满足过滤要求时候才能继续下一步的block 代码
        //
        // -filter returns a new RACSignal that only sends a new value when its block
        // returns YES.
        [[RACObserve(self, userName) filter:^BOOL(NSString* value) {
            return [value length]>5;
        }] subscribeNext:^(id x) {
            NSLog(@"长度大于5-->%@",x);
        } error:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    }
    return self;
}


//有效性判断
- (RACSignal *)validateLoginInputs {
    
    if (!_validateLoginInputs) {
        _validateLoginInputs = [RACSignal combineLatest:@[RACObserve(self, userName),
                                                          RACObserve(self, passWord)]
                                                 reduce:^id(NSString *username,NSString *password){
                                                     return @(username.length > 0 && password.length > 0);
                                                 }];
    }
    return _validateLoginInputs;
    
}

- (RACCommand*)loginRequestCommand {
    if (!_loginRequestCommand) {
        _loginRequestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return  [self.checkUserRegisterSignal concat:self.loginSuccessSignal];
        }];
        _loginRequestCommand.allowsConcurrentExecution = YES;
    }
    return _loginRequestCommand;
}

- (RACSignal*)checkUserRegisterSignal {
    if (!_checkUserRegisterSignal) {
        _checkUserRegisterSignal = [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (arc4random()%2) {
                        [subscriber sendNext:@{@"user":self.userName,@"password":self.passWord}];
                    }else {
                        [subscriber sendError:[NSError errorWithDomain:NSNetServicesErrorDomain code:1009 userInfo:nil]];
                    }
                    [subscriber sendCompleted];
                });
            });
            
            return nil;
        }]publish]autoconnect]  ;
    }
    return _checkUserRegisterSignal;
}

- (RACSignal*)loginSuccessSignal {
    if (!_loginSuccessSignal) {
        _loginSuccessSignal = [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (arc4random()%2) {
                        [subscriber sendNext:@{@"login":@"successs"}];
                    }else {
                        [subscriber sendError:[NSError errorWithDomain:NSNetServicesErrorDomain code:1001 userInfo:nil]];
                    }
                    [subscriber sendCompleted];
                });
            });
            return nil;
        }] publish]autoconnect]   ;
    }
    return _loginSuccessSignal;
}

@end
