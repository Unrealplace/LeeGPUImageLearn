//
//  OLCameraManager.h
//  GPUImageDemo
//
//  Created by NicoLin on 2018/3/28.
//  Copyright © 2018年 NicoLin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@protocol OLCameraManagerDelegate <NSObject>

@optional
- (void)cameraCapturePhoto:(UIImage *)img;

@end

@interface OLCameraManager : NSObject


- (void)showVideoViewWith:(CGRect)frame target:(id<OLCameraManagerDelegate>)delegate superView:(UIView*)superView;

- (void)startRecordVideo;

- (void)stopRecordVideo;

- (void)captureSinglePhoto;

@end
