//
//  OLBottomToolView.h
//  GPUImageDemo
//
//  Created by NicoLin on 2018/3/28.
//  Copyright © 2018年 NicoLin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OLBottomToolView;
@protocol OLBottomToolViewDelegate <NSObject>
@optional

/**
 选取了滤镜
 */
- (void)bottomToolViewSelectFilter:(OLBottomToolView*)bottomToolView;

/**
 选取了动态贴纸
 */
- (void)bottomTooleViewSelectDynamicPaster:(OLBottomToolView*)bottomToolView;
@end
@interface OLBottomToolView : UIView
@property (nonatomic,weak)id <OLBottomToolViewDelegate> delegate;
@end
