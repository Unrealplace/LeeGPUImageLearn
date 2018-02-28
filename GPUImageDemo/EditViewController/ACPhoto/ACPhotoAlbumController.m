//
//  PhotoAlbumVC.m
//  ArtCamera
//
//  Created by NicoLin on 2016/11/25.
//  Copyright © 2016年 NicoLin. All rights reserved.
//

#import "ACPhotoAlbumController.h"
#import "ACPhotoAlbumCell.h"
#import "ACPhotoPickerController.h"
#import "ACCommon.h"

@import Photos;

@interface ACPhotoAlbumController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) photoAlbumHandler albumHandler;//选择相册回调

@property (nonatomic, strong) PHFetchOptions * fechOptions;
@property (nonatomic, strong) PHImageRequestOptions * requestOption;
@property (nonatomic, strong) UITableView * albumTableView;

@property (nonatomic, strong) NSMutableArray * albums;

@end

@implementation ACPhotoAlbumController

#pragma mark - View lifeCycle
-(void)dealloc
{
    _albumTableView.delegate = nil;
    _albumTableView.dataSource = nil;
}

- (void)loadView {
    [super loadView];
    UIVisualEffectView *visualEffectView    = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    visualEffectView.backgroundColor        = [UIColor colorWithWhite:0 alpha:0.6];
    visualEffectView.frame                  = self.view.bounds;
    [self.view addSubview:visualEffectView];
    [self.view addSubview:self.albumTableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                //获取手机照片库
                 [self photokitSetUp];
            }else{
                //弹出提示信息
            }
        }];
    }else if(status == PHAuthorizationStatusAuthorized){
        //获取手机照片库
         [self photokitSetUp];
    }else{
        //弹出提示信息
        //[self alertMsg];
    }

}

#pragma mark - getter 
- (UITableView *)albumTableView {
    if (!_albumTableView) {
        _albumTableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_albumTableView];
        _albumTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _albumTableView.showsVerticalScrollIndicator = NO;
        _albumTableView.delegate = self;
        _albumTableView.dataSource = self;
        _albumTableView.backgroundColor = [UIColor clearColor];
        [_albumTableView registerClass:[ACPhotoAlbumCell class] forCellReuseIdentifier:NSStringFromClass([ACPhotoAlbumCell class])];
        _albumTableView.contentInset = UIEdgeInsetsMake(NAVI_HEIGHT, 0, 15.0f, 0);
    }
    return _albumTableView;
}

- (NSMutableArray *)albums {
    if (!_albums) {
        _albums = [NSMutableArray array];
    }
    
    return _albums;
}

#pragma mark - album data source
- (void)photokitSetUp {
    //相册照片查询条件（顺序）
    _fechOptions = [[PHFetchOptions alloc] init];
    _fechOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    _fechOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d",PHAssetMediaTypeImage];
    
    PHFetchResult * userAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    [userAlbums enumerateObjectsUsingBlock:^(PHAssetCollection *collection, NSUInteger idx, BOOL * _Nonnull stop) {
        PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:_fechOptions];
        if (fetchResult.count > 0) {
            [self.albums addObject:collection];
        }
    }];
    
    PHFetchResult *favoritesAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumFavorites options:nil];
    [favoritesAlbums enumerateObjectsUsingBlock:^(PHAssetCollection *collection, NSUInteger idx, BOOL * _Nonnull stop) {
        PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:_fechOptions];
        if (fetchResult.count > 0) {
            [self.albums addObject:collection];
        }
    }];
    
    PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    [topLevelUserCollections enumerateObjectsUsingBlock:^(PHCollection *collection, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([collection isKindOfClass:[PHAssetCollection class]]) {
            PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
            PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:_fechOptions];
            if (fetchResult.count > 0) {
                [self.albums addObject:collection];
            }
        }
    }];
    
    //相册图片选取条件（参数）
    _requestOption = [[PHImageRequestOptions alloc] init];
    _requestOption.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
    _requestOption.networkAccessAllowed = NO;
    _requestOption.resizeMode = PHImageRequestOptionsResizeModeFast;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_albumTableView reloadData];
    });
}

#pragma mark - UITableViewDelegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.albums.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ACPhotoAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ACPhotoAlbumCell class]) forIndexPath:indexPath];

        PHCollection *collection = self.albums[indexPath.item];
        PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
        PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:_fechOptions];
    
        if (fetchResult.count > 0) {
            PHAsset *asset = fetchResult[0];
            cell.localIdentifier = asset.localIdentifier;
            [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(100*[UIScreen mainScreen].scale, 100*[UIScreen mainScreen].scale) contentMode:PHImageContentModeAspectFit options:_requestOption resultHandler:^(UIImage *result, NSDictionary *info) {
        
                if ([cell.localIdentifier isEqualToString:asset.localIdentifier])
                {
                    cell.thumbImageView.image = result;
                }
            }];
        }
        cell.photoCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)fetchResult.count];
        cell.albumNameLabel.text = collection.localizedTitle;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //子相册筛选结果
    PHCollection *collection = self.albums[indexPath.row];
    PHFetchResult * result = [PHAsset fetchAssetsInAssetCollection:(PHAssetCollection *)collection options:_fechOptions];
    if (result && self.albumHandler) {
        self.albumHandler(result,collection.localizedTitle);
    }
}

//选图回调
- (void)selectAlbumWithAlbumHandler:(photoAlbumHandler)albumHandler {
    self.albumHandler = albumHandler;
}


@end
