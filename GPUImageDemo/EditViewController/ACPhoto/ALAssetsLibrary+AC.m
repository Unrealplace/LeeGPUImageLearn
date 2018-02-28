//
//  ALAssetsLibrary+AC.m
//  CameraDemo
//
//  Created by NicoLin on 2018/1/5.
//  Copyright © 2018年 NicoLin. All rights reserved.
//

#import "ALAssetsLibrary+AC.h"

@implementation ALAssetsLibrary (AC)
- (void)latestAsset:(void (^)(ALAsset * _Nullable, NSError *_Nullable))block {
    [self enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            [group enumerateAssetsWithOptions:NSEnumerationReverse/*遍历方式*/ usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if (result) {
                    if (block) {
                        block(result,nil);
                    }
                    *stop = YES;
                }
            }];
            *stop = YES;
        }
    } failureBlock:^(NSError *error) {
        if (error) {
            if (block) {
                block(nil,error);
            }
        }
    }];
}
@end
