//
//  ALAsset+AC.m
//  CameraDemo
//
//  Created by NicoLin on 2018/1/5.
//  Copyright © 2018年 NicoLin. All rights reserved.
//

#import "ALAsset+AC.h"

@implementation ALAsset (AC)
- (UIImage *)thumbnailImage {
    return [[UIImage alloc]initWithCGImage:[self aspectRatioThumbnail]];
}
- (UIImage *)originalImage {
    
    CGImageRef ref = [[self defaultRepresentation] fullScreenImage];
    return [[UIImage alloc]initWithCGImage:ref];
}
- (NSTimeInterval)createTimeInterval {
    return [[self valueForProperty:ALAssetPropertyDate] timeIntervalSince1970];
}

- (NSURL *)assetURL {
    return [self valueForProperty:ALAssetPropertyAssetURL];
}
@end
