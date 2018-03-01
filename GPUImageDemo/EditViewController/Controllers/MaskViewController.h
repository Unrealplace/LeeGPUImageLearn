//
//  MaskViewController.h
//  GPUImageDemo
//
//  Created by NicoLin on 2018/3/1.
//  Copyright © 2018年 NicoLin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MaskClickBlock)(UIImage * maskImg);

@interface MaskViewController : UIViewController

@property (nonatomic,copy)MaskClickBlock maskClickBlock;

@end
