//
//  PanelViewController.h
//  GPUImageDemo
//
//  Created by NicoLin on 2018/2/28.
//  Copyright © 2018年 NicoLin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PanelChangeImgBlock)(UIImage * front , UIImage * back);

typedef void(^PanelPanBlock)(CATransform3D tranform);

typedef void(^PanelLookUpChangeBlock)(UIImage * lookUpImg);

typedef void(^PanelMaskChangeBlock)(UIImage * maskImg);

@interface PanelViewController : UIViewController

@property (nonatomic,copy)PanelChangeImgBlock changeImgBlock;
@property (nonatomic,copy)PanelPanBlock panTranformBlock;
@property (nonatomic,copy)PanelLookUpChangeBlock changeLkpBlock;
@property (nonatomic,copy)PanelMaskChangeBlock changeMaskBlock;

@end
