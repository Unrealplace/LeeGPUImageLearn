//
//  OLTopToolView.h
//  GPUImageDemo
//
//  Created by NicoLin on 2018/3/28.
//  Copyright © 2018年 NicoLin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OLTopToolView;

@protocol OLTopToolViewDelegate <NSObject>

@optional

- (void)topToolViewClickBack:(OLTopToolView*)topToolView;

@end
@interface OLTopToolView : UIView

@property (nonatomic,weak)id <OLTopToolViewDelegate> delegate;

@end
