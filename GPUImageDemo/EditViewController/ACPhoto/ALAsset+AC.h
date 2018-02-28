//
//  ALAsset+AC.h
//  CameraDemo
//
//  Created by NicoLin on 2018/1/5.
//  Copyright © 2018年 NicoLin. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import <UIKit/UIKit.h>

@interface ALAsset (AC)
- (UIImage *)thumbnailImage;
- (UIImage *)originalImage;
- (NSTimeInterval)createTimeInterval;
- (NSURL *)assetURL;
@end
