//
//  PhotoPickerVC.h
//  ArtCamera
//
//  Created by NicoLin on 2016/11/25.
//  Copyright © 2016年 NicoLin. All rights reserved.
//

@import Photos;

typedef void(^photoPickerHandler)(UIImage * photo);

typedef enum :NSInteger{
    ACFaceSDKFunctionTypeCameraUse = 0,
    ACFaceSDKFunctionTypeAlertUse ,
}ACFaceSDKFunctionType;

@class ACPhotoPickerController;

@protocol ACPhotoPickerControllerDelegate <NSObject>
- (void)photoPickerController:(ACPhotoPickerController*)controller
             withFunctionType:(ACFaceSDKFunctionType)functionType
         andCompletionHandler:(void(^)(UIImage *image))compleationHandler ;

@end


@interface ACPhotoPickerController : UIViewController

@property (nonatomic, assign) CGSize maximumSize; //选中图片最大尺寸，默认为2048*2048

@property (nonatomic, assign) BOOL needFaceTips;    //是否从换脸进入

//选图回调
- (void)selectPhotoWithPickAction:(photoPickerHandler)pickAction;

@property (nonatomic,strong)id <ACPhotoPickerControllerDelegate> delegate ;



@end
