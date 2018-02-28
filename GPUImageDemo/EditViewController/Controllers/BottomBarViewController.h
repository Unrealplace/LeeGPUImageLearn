//
//  BottomBarViewController.h
//  GPUImageDemo
//
//  Created by NicoLin on 2018/2/28.
//  Copyright © 2018年 NicoLin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BottomBarSelectImgBlock)(UIImage*front ,UIImage * back);
@interface BottomBarViewController : UIViewController
@property (nonatomic,strong)UIButton * frontBtn;

@property (nonatomic,copy)BottomBarSelectImgBlock selectImgBlock;

@end
