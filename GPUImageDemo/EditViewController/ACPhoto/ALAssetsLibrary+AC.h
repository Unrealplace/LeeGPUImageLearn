//
//  ALAssetsLibrary+AC.h
//  CameraDemo
//
//  Created by NicoLin on 2018/1/5.
//  Copyright © 2018年 NicoLin. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>

@interface ALAssetsLibrary (AC)
/**
 *  获取最新一张图片
 *
 *  @param block 回调
 */
- (void)latestAsset:(void(^_Nullable)(ALAsset * _Nullable asset,NSError *_Nullable error)) block;
@end
