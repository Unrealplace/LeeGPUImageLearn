//
//  OLPhotoEditorToolView.h
//  GPUImageDemo
//
//  Created by NicoLin on 2018/3/29.
//  Copyright © 2018年 NicoLin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OLPhotoEditorToolViewDelegate <NSObject>
@optional
- (void)editorToolViewClickBack;

@end
@interface OLPhotoEditorToolView : UIView

@property (nonatomic,weak)id <OLPhotoEditorToolViewDelegate> delegate;

@end
