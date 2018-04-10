//
//  OLRACMainViewController.m
//  GPUImageDemo
//
//  Created by NicoLin on 2018/4/10.
//  Copyright © 2018年 NicoLin. All rights reserved.
//

#import "OLRACMainViewController.h"
#import "OLLoginViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface OLRACMainViewController ()
@property (weak, nonatomic) IBOutlet UITextField *passWordTF;
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (strong, nonatomic)UIButton *loginBtn;

@property (nonatomic,strong)OLLoginViewModel *loginViewModel;
@end

@implementation OLRACMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self.loginBtn setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:self.loginBtn];
    
}

- (OLLoginViewModel*)loginViewModel {
    if (!_loginViewModel) {
        _loginViewModel = [[OLLoginViewModel alloc] init];
    }
    return _loginViewModel;
}

- (void)viewWillConfigureParameters {
    
    @weakify(self);
    [self.userNameTF.rac_textSignal subscribeNext:^(NSString * x) {
        @strongify(self);
        self.loginViewModel.userName = x;
    }];
    
    [self.passWordTF.rac_textSignal subscribeNext:^(id x) {
        @strongify(self);
        self.loginViewModel.passWord = x;
    }];
    
    
    // Creates a one-way binding so that self.createEnabled will be
    // true whenever self.password and self.passwordConfirmation
    // are equal.
    //
    // RAC() is a macro that makes the binding look nicer.
    //
    // +combineLatest:reduce: takes an array of signals, executes the block with the
    // latest value from each signal whenever any of them changes, and returns a new
    // RACSignal that sends the return value of that block as values.
    // 这种写法有问题不知道为什么
//    RAC(self.loginBtn,enabled) = self.loginViewModel.validateLoginInputs;

    //登陆按钮点击的操作步骤
    self.loginBtn.rac_command  = self.loginViewModel.loginRequestCommand;
    //判断是否正在执行
    [self.loginBtn.rac_command.executing subscribeNext:^(id x) {
        if ([x boolValue]) {
            NSLog(@"login......");
        } else {
            NSLog(@"end logining--%@",x);
        }
    }];
    //执行结果
    [self.loginBtn.rac_command.executionSignals.flatten subscribeNext:^(id x) {
        NSLog(@"result:%@",x);
    }];
    
    //错误处理
    [self.loginBtn.rac_command.errors subscribeNext:^(id x) {
        NSLog(@"error:%@",x);
    }];
    

}

- (UIButton*)loginBtn {
    if (!_loginBtn) {
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginBtn.frame = CGRectMake(0, 0, 100, 100);
        _loginBtn.center = self.view.center;
    }
    return _loginBtn;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
