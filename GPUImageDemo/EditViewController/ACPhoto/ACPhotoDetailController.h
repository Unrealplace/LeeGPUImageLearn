//
//  ACPhotoDetailController.h
//  ArtCameraPro
//
//  Created by BeautyHZ on 2017/11/29.
//  Copyright © 2017年 NicoLin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^photoPickBlock)(UIImage * photo);

@interface ACPhotoDetailController : UIViewController

@property (nonatomic, strong) UIImage *photo;

- (void)selectTheImgWithBlock:(photoPickBlock)block;

@end
