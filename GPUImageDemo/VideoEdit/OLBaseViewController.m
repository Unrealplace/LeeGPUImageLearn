//
//  OLBaseViewController.m
//  GPUImageDemo
//
//  Created by NicoLin on 2018/3/28.
//  Copyright © 2018年 NicoLin. All rights reserved.
//

#import "OLBaseViewController.h"

@interface OLBaseViewController ()

@end

@implementation OLBaseViewController

- (void)dealloc {
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
 
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}



@end
