//
//  PHAsset+AC.h
//  CameraDemo
//
//  Created by NicoLin on 2018/1/5.
//  Copyright © 2018年 NicoLin. All rights reserved.
//

#import <Photos/Photos.h>

@interface PHAsset (AC)
/**
 *  获取最新一张图片
 */
+ (PHAsset *)latestAsset;
@end
