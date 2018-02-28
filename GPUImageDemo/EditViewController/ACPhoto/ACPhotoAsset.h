//
//  ACAsset.h
//  CameraDemo
//
//  Created by NicoLin on 2018/1/5.
//  Copyright © 2018年 NicoLin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class ALAsset;
@class PHAsset;
@interface ACPhotoAsset : NSObject
@property (assign, nonatomic, readonly) NSTimeInterval creationTimeInterval;//创建时间戳
@property (strong, nonatomic, readonly, nonnull) UIImage *image;//原图
/**
 *  初始化
 *
 *  @param asset 相片信息 ALAsset PHAsset
 *
 */
- (instancetype _Nonnull)initWithALAsset:(ALAsset * _Nonnull)asset;
- (instancetype _Nonnull)initWithPHAsset:(PHAsset * _Nonnull)asset image:(UIImage * _Nonnull)image;
- (instancetype _Nonnull)initWithCreation:(NSTimeInterval)creation image:(UIImage * _Nonnull)image;
@end
