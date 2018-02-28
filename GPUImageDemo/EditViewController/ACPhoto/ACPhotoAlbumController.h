//
//  PhotoAlbumVC.h
//  ArtCamera
//
//  Created by NicoLin on 2016/11/25.
//  Copyright © 2016年 NicoLin. All rights reserved.
//

@import Photos;

typedef void(^photoAlbumHandler)(PHFetchResult * result, NSString * albumTitle);

@interface ACPhotoAlbumController : UIViewController

//选图回调
- (void)selectAlbumWithAlbumHandler:(photoAlbumHandler)albumHandler;
@end
