//
//  OLImageBeautyFilter.h
//  GPUImageDemo
//
//  Created by LiYang on 2018/3/28.
//  Copyright © 2018年 NicoLin. All rights reserved.
//

#import <GPUImage/GPUImage.h>

@class GPUImageCombinationFilter;

@interface OLImageBeautyFilter : GPUImageFilterGroup
{
    GPUImageBilateralFilter *bilateralFilter;
    GPUImageCannyEdgeDetectionFilter *cannyEdgeFilter;
    GPUImageHSBFilter *hsbFilter;
    GPUImageCombinationFilter *combinationFilter;

}
@end
