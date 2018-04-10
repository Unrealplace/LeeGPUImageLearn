//
//  OLRACBaseViewController.m
//  GPUImageDemo
//
//  Created by NicoLin on 2018/4/10.
//  Copyright © 2018年 NicoLin. All rights reserved.
//

#import "OLRACBaseViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface OLRACBaseViewController ()

@end

@implementation OLRACBaseViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%s",__func__);
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    OLRACBaseViewController *viewController = [super allocWithZone:zone];
    
    @weakify(viewController)
    [[viewController rac_signalForSelector:@selector(viewDidLoad)]
     subscribeNext:^(id x) {
         @strongify(viewController)
         [viewController viewWillAddSubViews];
         [viewController viewWillConstraintSubviews];
         [viewController viewWillConfigureSubviews];
         [viewController viewWillConfigureParameters];
         [viewController viewWillRequest];
         [viewController viewWillConfigureNotifications];
         
//         [viewController layoutCustomNavigationBar];
         [viewController viewDidLayoutCustomNavigationBar];
     }];
    
    return viewController;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    if (@available(iOS 11.0, *)) {
        [UIScrollView appearanceWhenContainedInInstancesOfClasses:@[self.class]].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
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

- (void)viewWillAddSubViews {
    
}

- (void)viewWillConstraintSubviews {
    
}

- (void)viewWillConfigureSubviews {
    
}

- (void)viewWillConfigureParameters {
    
}

- (void)viewWillRequest {
    
}

- (void)viewWillConfigureNotifications {
    
}

- (void)viewDidLayoutCustomNavigationBar {
    
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}


@end
