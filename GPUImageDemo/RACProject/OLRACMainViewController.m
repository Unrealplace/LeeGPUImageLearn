//
//  OLRACMainViewController.m
//  GPUImageDemo
//
//  Created by NicoLin on 2018/4/10.
//  Copyright © 2018年 NicoLin. All rights reserved.
//

#import "OLRACMainViewController.h"
#import "OLLoginViewModel.h"
#import "OLDataShowViewController.h"
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
    
    //登陆按钮点击的操作步骤
    self.loginBtn.rac_command  = self.loginViewModel.loginRequestCommand;
//    //判断是否正在执行
    [self.loginBtn.rac_command.executing subscribeNext:^(id x) {
        if ([x boolValue]) {
            NSLog(@"login......");
        } else {
            NSLog(@"end logining--%@",x);
            [self.loginViewModel.wiriteToLocalCommand execute:@"hello i am happy to write to local"];
        }
    }];
    //执行结果
    [self.loginBtn.rac_command.executionSignals.flatten subscribeNext:^(id x) {
        NSLog(@"result:%@",x);
        @strongify(self);
        if (x) {
         
        }
    }];
    
    //错误处理
    [self.loginBtn.rac_command.errors subscribeNext:^(id x) {
        NSLog(@"error:%@",x);
    }];
    
    //写入本地的操作信号完成
    [self.loginViewModel.wiriteToLocalCommand.executionSignals.flatten subscribeNext:^(id x) {
        NSLog(@"%@写入本地完成",x);
        OLDataShowViewController * vc = [OLDataShowViewController new];
        [vc.subject subscribeNext:^(id x) {
            
        }];
        [self.navigationController pushViewController:vc animated:YES];
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
