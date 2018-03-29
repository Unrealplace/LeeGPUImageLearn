//
//  OLTestMVVMViewController.m
//  GPUImageDemo
//
//  Created by NicoLin on 2018/3/29.
//  Copyright © 2018年 NicoLin. All rights reserved.
//

#import "OLTestMVVMViewController.h"
#import "OLViewModel.h"
#import "OLTestButton.h"

@interface OLTestMVVMViewController ()
@property (nonatomic,strong)OLViewModel *viewModel;
@property (nonatomic,strong)OLTestButton *clickBtn;
@end

@implementation OLTestMVVMViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.clickBtn];
    
}

- (OLViewModel*)viewModel {
    if (!_viewModel) {
        _viewModel = [[OLViewModel alloc] init];
    }
    return _viewModel;
}

- (OLTestButton*)clickBtn {
    @weakify(self);
    if (!_clickBtn) {
        @strongify(self);
        _clickBtn = [[OLTestButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
        _clickBtn.backgroundColor = [UIColor redColor];
        [[_clickBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [self.viewModel.dataChangeSingle sendNext:[NSString stringWithFormat:@"%d",arc4random() %100]];
            [_clickBtn setTitle:self.viewModel.dataArray[0] forState:UIControlStateNormal];
        }];
    }
    return _clickBtn;
}

@end
