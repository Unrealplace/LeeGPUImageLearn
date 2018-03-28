//
//  OLBottomToolView.h
//  GPUImageDemo
//
//  Created by NicoLin on 2018/3/28.
//  Copyright © 2018年 NicoLin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum :NSInteger{
    
    OLRecordTypeMutipleCapture = 1,
    OLRecordTypeSingleCapture ,
    OLRecordTypeVideoCapture ,
    OLRecordTypeEmojiCapture
    
}OLRecordType;

@class OLBottomToolView;
@class OLRecordButton;

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

/**
 点击了记录按钮

 @param recordBtn 记录按钮的对象
 @param recordTye 当前的种类
 */
- (void)bottomToolViewClickRecordBtn:(OLRecordButton*)recordBtn  recordType:(OLRecordType) recordTye bottomView:(OLBottomToolView*)bottomToolView;;

@end
@interface OLBottomToolView : UIView
@property (nonatomic,weak)id <OLBottomToolViewDelegate> delegate;
@end
