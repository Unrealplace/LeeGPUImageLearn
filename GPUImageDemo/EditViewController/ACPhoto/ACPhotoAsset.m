//
//  ACAsset.m
//  CameraDemo
//
//  Created by NicoLin on 2018/1/5.
//  Copyright © 2018年 NicoLin. All rights reserved.
//

#import "ACPhotoAsset.h"
#import "ALAsset+AC.h"
#import "PHAsset+AC.h"

@implementation ACPhotoAsset
- (instancetype _Nonnull)initWithALAsset:(ALAsset * _Nonnull)asset {
    return [self initWithCreation:asset.createTimeInterval image:asset.originalImage];
}
- (instancetype _Nonnull)initWithPHAsset:(PHAsset * _Nonnull)asset image:(UIImage * _Nonnull)image {
    return [self initWithCreation:asset.creationDate.timeIntervalSince1970 image:image];
}
- (instancetype _Nonnull)initWithCreation:(NSTimeInterval)creation image:(UIImage * _Nonnull)image {
    if (self = [super init] ) {
        _image = image;
        _creationTimeInterval = creation;
    }
    return self;
}
@end
