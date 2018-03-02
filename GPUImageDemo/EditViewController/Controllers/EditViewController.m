//
//  EditViewController.m
//  GPUImageDemo
//
//  Created by NicoLin on 2018/2/28.
//  Copyright © 2018年 NicoLin. All rights reserved.
//

#import "EditViewController.h"
#import "PanelViewController.h"
#import "BottomBarViewController.h"
#import "LookUpViewController.h"
#import "MaskViewController.h"

@interface EditViewController ()

@property (nonatomic,strong)UIButton * changeTypeBtn;
@property (nonatomic,strong) LookUpViewController * lookUpView;
@property (nonatomic,strong) MaskViewController * maskView;
@property (nonatomic,strong) PanelViewController * panelView;
@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    [self setui];
    
}

- (void)setui {
    
    _panelView = [[PanelViewController alloc] init];
    _panelView.view.frame = CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.width);
    [self.view addSubview:_panelView.view];
    [self addChildViewController:_panelView];
    
    BottomBarViewController * bottomBarView = [[BottomBarViewController alloc] init];
    bottomBarView.view.frame = CGRectMake(0, CGRectGetMaxY(_panelView.view.frame), self.view.bounds.size.width, 100);
    [self.view addSubview:bottomBarView.view];
    [self addChildViewController:bottomBarView];
    
    _lookUpView = [[LookUpViewController alloc] init];
    _lookUpView.view.frame = CGRectMake(0, CGRectGetMaxY(bottomBarView.view.frame), self.view.bounds.size.width, 80);
    [self.view addSubview:_lookUpView.view];
    [self addChildViewController:_lookUpView];
    
    _maskView = [[MaskViewController alloc] init];
    _maskView.view.hidden = YES;
    _maskView.view.frame = CGRectMake(0, CGRectGetMaxY(bottomBarView.view.frame), self.view.bounds.size.width, 80);
    [self.view addSubview:_maskView.view];
    [self addChildViewController:_maskView];
    
    self.changeTypeBtn = [UIButton new];
    self.changeTypeBtn.frame = CGRectMake(20, CGRectGetMaxY(_lookUpView.view.frame)+5, 80, 44);
    [self.changeTypeBtn setTitle:@"色彩滤镜" forState:UIControlStateNormal];
    self.changeTypeBtn.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:self.changeTypeBtn];
    [self.changeTypeBtn addTarget:self action:@selector(changeTypeBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    __weak typeof(self) weakself = self;
//    self.panelView.changeImgBlock(nil, nil);
    bottomBarView.selectImgBlock = ^(UIImage *front, UIImage *back) {
        weakself.panelView.changeImgBlock(front, back);
    };
    _lookUpView.lookUpClickBlock = ^(UIImage *lookUpImg) {
       weakself.panelView.changeLkpBlock(lookUpImg);

    };
    _maskView.maskClickBlock = ^(UIImage *maskImg) {
        weakself.panelView.changeMaskBlock(maskImg);
    };
    
}

- (void)changeTypeBtnClick:(UIButton*)sender {
    _maskView.view.hidden = !_maskView.view.hidden;
    _lookUpView.view.hidden = !_lookUpView.view.hidden;
    if (_maskView.view.hidden) {
        [self.changeTypeBtn setTitle:@"色彩滤镜" forState:UIControlStateNormal];
        _panelView.frontAndMaskBlock(YES, NO);
    }else {
        _panelView.frontAndMaskBlock(NO, YES);
        [self.changeTypeBtn setTitle:@"遮罩滤镜" forState:UIControlStateNormal];
    }
}


@end
