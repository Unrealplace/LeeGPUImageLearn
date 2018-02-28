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

@interface EditViewController ()

@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    [self setui];
    
}

- (void)setui {
    
    PanelViewController * panelView = [[PanelViewController alloc] init];
    panelView.view.frame = CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.width);
    [self.view addSubview:panelView.view];
    [self addChildViewController:panelView];
    
    BottomBarViewController * bottomBarView = [[BottomBarViewController alloc] init];
    bottomBarView.view.frame = CGRectMake(0, CGRectGetMaxY(panelView.view.frame), self.view.bounds.size.width, 100);
    [self.view addSubview:bottomBarView.view];
    [self addChildViewController:bottomBarView];
    
    panelView.panTranformBlock = ^(CATransform3D tranform) {
        bottomBarView.frontBtn.layer.transform = tranform;
    };
    bottomBarView.selectImgBlock = ^(UIImage *front, UIImage *back) {
        panelView.changeImgBlock(front, back);
    };
    
}




@end
