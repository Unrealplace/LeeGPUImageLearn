//
//  OLCameraRecordManager.h
//  GPUImageDemo
//
//  Created by NicoLin on 2018/3/28.
//  Copyright © 2018年 NicoLin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GPUImage.h>
@interface OLCameraRecordManager : NSObject



- (void)addTargetToRecordManager:(id<GPUImageInput>)target;

- (void)startRecord;

- (void)stopRecord;

@end
