//
//  OLRACBaseViewController.h
//  GPUImageDemo
//
//  Created by NicoLin on 2018/4/10.
//  Copyright © 2018年 NicoLin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OLRACBaseViewController : UIViewController
#pragma mark - 以下方法可供子类重写

//以下方法会在viewDidLoad走完之后按顺序执行
- (void)viewWillAddSubViews;
- (void)viewWillConstraintSubviews;
- (void)viewWillConfigureSubviews;
- (void)viewWillConfigureParameters;
- (void)viewWillRequest;
- (void)viewWillConfigureNotifications;
- (void)viewDidLayoutCustomNavigationBar;

@end
