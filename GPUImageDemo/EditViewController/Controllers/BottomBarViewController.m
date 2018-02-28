//
//  BottomBarViewController.m
//  GPUImageDemo
//
//  Created by NicoLin on 2018/2/28.
//  Copyright © 2018年 NicoLin. All rights reserved.
//

#import "BottomBarViewController.h"
#import "ACPhotoPickerController.h"

@interface BottomBarViewController ()

//@property (nonatomic,strong)UIButton * frontBtn;

@property (nonatomic,strong)UIButton * backBtn;

@end

@implementation BottomBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.frontBtn];
    [self.view addSubview:self.backBtn];
    

}
- (void)loadView {
    [super loadView];
    self.view.bounds = CGRectMake(0, 0, 375, 100);
    
}

- (UIButton*)frontBtn {
    if (!_frontBtn) {
        _frontBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 0, 100, 100)];
        [_frontBtn addTarget:self action:@selector(frontBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _frontBtn.backgroundColor = [UIColor purpleColor];
        [_frontBtn setTitle:@"前景" forState:UIControlStateNormal];
        [_frontBtn setBackgroundImage:[UIImage imageNamed:@"img_levitation_front_2"] forState:UIControlStateNormal];
    }
    return _frontBtn;
}

- (UIButton*)backBtn {
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] initWithFrame:CGRectMake(375-120, 0, 100, 100)];
        [_backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _backBtn.backgroundColor = [UIColor purpleColor];
        [_backBtn setTitle:@"背景" forState:UIControlStateNormal];
        [_backBtn setBackgroundImage:[UIImage imageNamed:@"img_levitation_back_0"] forState:UIControlStateNormal];

    }
    return  _backBtn;
}

- (void)frontBtnClick:(UIButton*)btn {
    
    ACPhotoPickerController * photo = [[ACPhotoPickerController alloc] init];
    [self.navigationController pushViewController:photo animated:YES];
    [photo selectPhotoWithPickAction:^(UIImage *photo) {
        if (self.selectImgBlock) {
            self.selectImgBlock(photo,nil);
        }
        [_frontBtn setBackgroundImage:photo forState:UIControlStateNormal];

    }];
   
    
}

- (void)backBtnClick:(UIButton*)btn {
   
    ACPhotoPickerController * photo = [[ACPhotoPickerController alloc] init];
    [self.navigationController pushViewController:photo animated:YES];
    [photo selectPhotoWithPickAction:^(UIImage *photo) {
        if (self.selectImgBlock) {
            self.selectImgBlock(nil,photo);
        }
        [_backBtn setBackgroundImage:photo forState:UIControlStateNormal];
    }];
    
}


@end
