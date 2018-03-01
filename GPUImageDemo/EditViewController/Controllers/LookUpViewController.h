//
//  LookUpViewController.h
//  GPUImageDemo
//
//  Created by NicoLin on 2018/3/1.
//  Copyright © 2018年 NicoLin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LookUpClickBlock)(UIImage *lookUpImg);
@interface LookUpViewController : UIViewController

@property (nonatomic,copy)LookUpClickBlock lookUpClickBlock;

@end
