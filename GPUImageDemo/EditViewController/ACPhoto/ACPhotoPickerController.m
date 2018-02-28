//
//  PhotoPickerVC.m
//  ArtCamera
//
//  Created by NicoLin on 2016/11/25.
//  Copyright © 2016年 NicoLin. All rights reserved.
//

#import "ACPhotoPickerController.h"
#import "ACPhotoAlbumController.h"
#import "ACPhotoPickerCell.h"
#import "UICollectionView+Convenience.h"
#import "NSIndexSet+Convenience.h"
#import "ACPhotoDetailController.h"
#import "ACAlbumBtn.h"
#import "UIView+ACCameraFrame.h"
#import "UIImage+ACCameraFixOrientation.h"
#import "ACCommon.h"

@interface ACPhotoPickerController ()<PHPhotoLibraryChangeObserver,UICollectionViewDelegate,UICollectionViewDataSource,UIViewControllerPreviewingDelegate,UINavigationControllerDelegate>

@property (nonatomic, copy) photoPickerHandler pickAction;//选择照片回调

@property (nonatomic, strong)UIView * naviView;

@property (nonatomic, strong)ACAlbumBtn * albumBtn;

//相片缩略图集合
@property (nonatomic, strong) UICollectionView *photoCollections;

@property (nonatomic, strong)ACPhotoAlbumController * albumVC;

//PhotoKits Property
@property (nonatomic, strong) PHCachingImageManager *imageManager;

@property (nonatomic, strong)PHFetchResult *allPhotos;

@property (nonatomic, assign)CGSize thumbnailSize; //相片缩略图大小

@property (nonatomic, strong) NSIndexPath *selectIndexPath;

@property (nonatomic, strong) UILabel *topShowLabel;

@property (nonatomic, strong) UIButton *bottomShowBtn;


@property (nonatomic, assign) NSInteger startTimeStamp;
@property (nonatomic, assign) NSInteger endTimeStamp;

@property CGRect previousPreheatRect;

@end

@implementation ACPhotoPickerController

#pragma mark - View lifeCycle
- (void)dealloc {
//    self.photoCollections.delegate = nil;
//    self.photoCollections.dataSource = nil;
    NSLog(@"%s",__func__);
    
}

- (void)loadView {
    [super loadView];
//    self.view.backgroundColor = ACRGBColor(51, 51, 51);
    
    [self.view addSubview:self.photoCollections];
    [self.view addSubview:self.naviView];
//    [self.view addSubview:self.topShowLabel];
//    [self.view addSubview:self.bottomShowBtn];
    
}

- (void)setNeedFaceTips:(BOOL)needFaceTips {
    _needFaceTips = needFaceTips;
    self.topShowLabel.hidden = !needFaceTips;
}

-(BOOL)prefersStatusBarHidden{
    
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.baiduStatName = @"相册";
    
    self.maximumSize = CGSizeMake(2048.0f, 2048.0f);
    
    [self checkAuthorizationStatusWithResult:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
            
            //PhotkitSetUp
            self.imageManager = [[PHCachingImageManager alloc] init];
            [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
            //获取相册
            [self loadPhotos];
            [self resetCachedAssets];
        }
        else if (status == PHAuthorizationStatusDenied) {
            
//            __weak typeof(self) weakSelf = self;
            
//            @weakify(self)
//            [ACAlertManager alertWithTitle:@"相机权限未开启" message:@"相机权限未开启，请进入系统【设置】>【隐私】>【相机】中打开开关,开启相机功能" ensureAction:^{
////                @strongify(self)
//                //跳入当前App设置界面,
//                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
//                [weakSelf closePhotoPicker];
//            } cancelAction:^{
//
//            }];
            
            
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.startTimeStamp = [NSDate timeIntervalSinceReferenceDate];
    self.navigationController.navigationBarHidden = YES;

}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self checkAuthorizationStatusWithResult:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
            [self updateCachedAssets];
        }
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.endTimeStamp = [NSDate timeIntervalSinceReferenceDate];

    if (self.needFaceTips) {
//        [[SensorsAnalyticsSDK sharedInstance] track:@"$AppViewScreen" withProperties:@{@"$screen_name" : @"P520_B02_M01_P02_L1",
//                                                                                  @"event_duration" : @(self.endTimeStamp - self.startTimeStamp)
//                                                                                  }];
    }
}

#pragma mark - 相册权限
- (void)checkAuthorizationStatusWithResult:(void (^)(PHAuthorizationStatus status))result
{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
            dispatch_async(dispatch_get_main_queue(), ^{
                if (result) {
                    result(status);
                }
             });
        }];
    }
    else {
        if (result) {
            result(status);
        }
    }
}

#pragma mark - getter & setter
- (UIView *)naviView {
    if (!_naviView) {
        _naviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.ca_width, NAVI_HEIGHT + NAVI_TOP_PADDING)];
        
        UIVisualEffectView * naviBgView = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        naviBgView.frame = CGRectMake(0, 0, _naviView.ca_width, _naviView.ca_height);
        naviBgView.backgroundColor = ACRGBAColor(51, 51, 51, 0.95);
        [_naviView addSubview:naviBgView];
        
        CGFloat btnSize = DeviceIsX ? 44.0f : _naviView.ca_height;
        UIButton * closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, NAVI_TOP_PADDING + (NAVI_HEIGHT - btnSize) / 2, btnSize, btnSize)];
        [closeBtn setImage:[UIImage imageNamed:@"editor_back"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(closePhotoPicker) forControlEvents:UIControlEventTouchUpInside];
        [_naviView addSubview:closeBtn];
        
        ACAlbumBtn * albumBtn = [ACAlbumBtn buttonWithType:UIButtonTypeCustom];
        albumBtn.frame = CGRectMake((_naviView.ca_width - 80.0f)/2, NAVI_TOP_PADDING, 80.0f, NAVI_HEIGHT);
        [albumBtn.titleLabel setFont:ACFont(16.0f)];
        [albumBtn setImage:[UIImage imageNamed:@"editor_album_open"] forState:UIControlStateNormal];
        [albumBtn setImage:[UIImage imageNamed:@"editor_album_close"] forState:UIControlStateSelected];
        [albumBtn setAlbumTitle:@"所有照片"];
        [albumBtn addTarget:self action:@selector(albumBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_naviView addSubview:albumBtn];
        _albumBtn = albumBtn;
    }
    return _naviView;
}

- (UICollectionView *)photoCollections
{
    if (_photoCollections == nil)
    {
        CGFloat colum = 3.0, spacing = 1.5f;
        CGFloat value = floorf((self.view.ca_width - (colum - 1) * spacing) / colum);
        
        UICollectionViewFlowLayout *layout  = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize                     = CGSizeMake(value, value);
        layout.minimumInteritemSpacing      = spacing;
        layout.minimumLineSpacing           = spacing;
        layout.sectionInset                 = UIEdgeInsetsMake(NAVI_HEIGHT, 0, 0, 0);

        //计算相片缩略图大小
        CGFloat scale = [UIScreen mainScreen].scale;
        self.thumbnailSize = CGSizeMake(value * scale, value * scale);
        
        _photoCollections = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
        _photoCollections.collectionViewLayout = layout;
        _photoCollections.backgroundColor = ACRGBColor(51, 51, 51);
        _photoCollections.showsVerticalScrollIndicator = NO;
        _photoCollections.showsHorizontalScrollIndicator = NO;
        _photoCollections.dataSource = self;
        _photoCollections.delegate = self;
        [_photoCollections registerClass:[ACPhotoPickerCell class] forCellWithReuseIdentifier:NSStringFromClass([ACPhotoPickerCell class])];
        _photoCollections.decelerationRate = 0.5f;
    }
    return _photoCollections;
}

- (UILabel *)topShowLabel {
    if (!_topShowLabel) {
        _topShowLabel = [UILabel new];
        _topShowLabel.frame = CGRectMake(0, NAVI_TOP_PADDING + 64, 280, 35);
        _topShowLabel.ca_centerX = self.view.ca_centerX;
        _topShowLabel.backgroundColor = [UIColor blackColor];
        _topShowLabel.textAlignment = NSTextAlignmentCenter;
        _topShowLabel.textColor = [UIColor whiteColor];
        _topShowLabel.text = @"五官清晰可辨的正面照效果更好";
    }
    return _topShowLabel;
}
- (void)setAllPhotos:(PHFetchResult *)allPhotos {
    if (_allPhotos != allPhotos) {
        _allPhotos = allPhotos;
        
        [self.photoCollections reloadData];
        if (_allPhotos.count <= 0) {
            self.albumBtn.enabled = NO;
        }
    }
}

#pragma mark - bar item action
- (void)closePhotoPicker
{
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//    [ACStatManager clickForSensorsWithElementContent:@"P520_B01_M01_P03_L1_F00"];

}

- (void)albumBtnDidClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self showAlbumWithStatus:sender.selected];
}

- (void)showAlbumWithStatus:(BOOL)status {
    
    if (!status) {
        if (self.albumVC) {  //相册界面展开时，点击按钮关闭
            
            //动画结束前，按钮不可点击
            _albumBtn.enabled = NO;
            [UIView animateWithDuration:0.3 animations:^{
                 self.albumVC.view.frame = CGRectMake(0, -SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
            } completion:^(BOOL finished) {
                [self.albumVC.view removeFromSuperview];
                self.albumVC = nil;
                _albumBtn.enabled = YES;
            }];
//            [NSObject pop_animate:^{
//                self.albumVC.view.pop_easeInEaseOut.frame = CGRectMake(0, -ACCAMERA_SCREEN_HEIGHT, ACCAMERA_SCREEN_WIDTH, ACCAMERA_SCREEN_HEIGHT);
//            } completion:^(BOOL finished) {
//                [self.albumVC.view removeFromSuperview];
//                self.albumVC = nil;
//                _albumBtn.enabled = YES;
//            }];
        }
    }
    else {
        
        if (!self.albumVC) {
            self.albumVC = [[ACPhotoAlbumController alloc] init];
            __weak typeof(self) weakSelf = self;
//            @weakify(self)
            [self.albumVC selectAlbumWithAlbumHandler:^(PHFetchResult *result, NSString * albumTitle) {
//                @strongify(self)
                [weakSelf.albumBtn setAlbumTitle:albumTitle];
                weakSelf.allPhotos = result;
                [weakSelf showAlbumWithStatus:NO];
            }];
            self.albumVC.view.frame = CGRectMake(0, -SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
//            self.albumVC.view.pop_duration = EditorDropAnimateDuration;
            [self.view addSubview:self.albumVC.view];
            [self.view bringSubviewToFront:self.naviView];
        }
    
        _albumBtn.enabled = NO;
        
        [UIView animateWithDuration:0.3 animations:^{
            self.albumVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);

        } completion:^(BOOL finished) {
            _albumBtn.enabled = YES;

        }];
        
//        [NSObject pop_animate:^{
//            self.albumVC.view.pop_easeInEaseOut.frame = CGRectMake(0, 0, ACCAMERA_SCREEN_WIDTH, ACCAMERA_SCREEN_HEIGHT);
//        } completion:^(BOOL finished) {
//            _albumBtn.enabled = YES;
//        }];
    }
}

#pragma mark - UICollectionViewDelegate Methods
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self changeTheCropContentWithSelectedIndex:indexPath];
    
    if (!self.needFaceTips) {
        //这个是控制消失的效果的
        [self closePhotoPicker];
//        [ACStatManager clickForSensorsWithElementContent:@"P520_B01_M01_P03_L1_F01"];
    }

}

//从相机选相片
- (void)changeTheCropContentWithSelectedIndex:(NSIndexPath *)indexPath
{
    PHImageRequestOptions * imageOptions;
    imageOptions = [[PHImageRequestOptions alloc] init];
    imageOptions.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
    imageOptions.networkAccessAllowed = NO;
    imageOptions.resizeMode = PHImageRequestOptionsResizeModeFast;
    imageOptions.synchronous = YES;
    __weak typeof(self) weakSelf = self;

    [[PHImageManager defaultManager] requestImageForAsset:self.allPhotos[indexPath.item] targetSize:self.maximumSize contentMode:PHImageContentModeAspectFit options:imageOptions resultHandler:^(UIImage *result, NSDictionary *info) {
        if (weakSelf.pickAction) {
            weakSelf.pickAction([result acCameraFixOrientation]);
        }
    }];
}

- (void)selectPhotoWithPickAction:(photoPickerHandler)pickAction {
    self.pickAction = pickAction;
}

#pragma mark - UITableViewDataSource Methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.allPhotos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ACPhotoPickerCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ACPhotoPickerCell class]) forIndexPath:indexPath];

    //相片区域
    PHAsset *asset = self.allPhotos[indexPath.item];
    cell.representedAssetIdentifier = asset.localIdentifier;
    
    // Add a badge to the cell if the PHAsset represents a Live Photo.
    if (asset.mediaSubtypes & PHAssetMediaSubtypePhotoLive)
    {
        // Add Badge Image to the cell to denote that the asset is a Live Photo.
        //            UIImage *badge = [PHLivePhotoView livePhotoBadgeImageWithOptions:PHLivePhotoBadgeOptionsOverContent];
        //            cell.livePhotoBadgeImage = badge;
    }
    
    PHImageRequestOptions *requestOptions;
    requestOptions = [[PHImageRequestOptions alloc] init];
    requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
    requestOptions.resizeMode = PHImageRequestOptionsResizeModeFast;
    
    // Request an image for the asset from the PHCachingImageManager.
    [self.imageManager requestImageForAsset:asset
                                 targetSize:self.thumbnailSize
                                contentMode:PHImageContentModeAspectFit
                                    options:requestOptions
                              resultHandler:^(UIImage *result, NSDictionary *info) {
                                  // Set the cell's thumbnail image if it's still showing the same asset.
                                  @autoreleasepool {
                                      if ([cell.representedAssetIdentifier isEqualToString:asset.localIdentifier]) {
                                          
                                          cell.thumbnailImage = result;
                                      }
                                  }
                              }];
    
    if ([self respondsToSelector:@selector(traitCollection)])
    {
        if ([self.traitCollection respondsToSelector:@selector(forceTouchCapability)])
        {
            if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable)
            {
                // 支持3D Touch
                [self registerForPreviewingWithDelegate:self sourceView:cell];
                cell.indexPath = indexPath;
            }
            else
            {
                // 不支持3D Touch
            }
        }
    }

    return cell;
}


#pragma mark - Common methods
- (void)loadPhotos {
    
    //获取相册
    PHFetchOptions *allPhotosOptions = [[PHFetchOptions alloc] init];
    allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]]; //时间排序
    allPhotosOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d",PHAssetMediaTypeImage]; //只获取图片资源
    self.allPhotos = [PHAsset fetchAssetsWithOptions:allPhotosOptions];
}

- (void)resetCachedAssets {
    [self.imageManager stopCachingImagesForAllAssets];
    self.previousPreheatRect = CGRectZero;
}

- (void)updateCachedAssets {
    BOOL isViewVisible = [self isViewLoaded] && [[self view] window] != nil;
    if (!isViewVisible) { return; }
    
    // The preheat window is twice the height of the visible rect.
    CGRect preheatRect = self.photoCollections.bounds;
    preheatRect = CGRectInset(preheatRect, 0.0f, -0.5f * CGRectGetHeight(preheatRect));
    
    /*
     Check if the collection view is showing an area that is significantly
     different to the last preheated area.
     */
    CGFloat delta = ABS(CGRectGetMidY(preheatRect) - CGRectGetMidY(self.previousPreheatRect));
    if (delta > CGRectGetHeight(self.photoCollections.bounds) / 3.0f) {
        
        // Compute the assets to start caching and to stop caching.
        NSMutableArray *addedIndexPaths = [NSMutableArray array];
        NSMutableArray *removedIndexPaths = [NSMutableArray array];
        
        [self computeDifferenceBetweenRect:self.previousPreheatRect andRect:preheatRect removedHandler:^(CGRect removedRect) {
            NSArray *indexPaths = [self.photoCollections aapl_indexPathsForElementsInRect:removedRect];
            [removedIndexPaths addObjectsFromArray:indexPaths];
        } addedHandler:^(CGRect addedRect) {
            NSArray *indexPaths = [self.photoCollections aapl_indexPathsForElementsInRect:addedRect];
            [addedIndexPaths addObjectsFromArray:indexPaths];
        }];
        
        NSArray *assetsToStartCaching = [self assetsAtIndexPaths:addedIndexPaths];
        NSArray *assetsToStopCaching = [self assetsAtIndexPaths:removedIndexPaths];
        
        // Update the assets the PHCachingImageManager is caching.
        [self.imageManager startCachingImagesForAssets:assetsToStartCaching
                                            targetSize:self.thumbnailSize
                                           contentMode:PHImageContentModeAspectFill
                                               options:nil];
        [self.imageManager stopCachingImagesForAssets:assetsToStopCaching
                                           targetSize:self.thumbnailSize
                                          contentMode:PHImageContentModeAspectFill
                                              options:nil];
        
        // Store the preheat rect to compare against in the future.
        self.previousPreheatRect = preheatRect;
    }
}

- (NSArray *)assetsAtIndexPaths:(NSArray *)indexPaths {
    
    NSMutableArray *assets = [NSMutableArray arrayWithCapacity:indexPaths.count];
    for (NSIndexPath *indexPath in indexPaths)
    {
        PHAsset *asset = self.allPhotos[indexPath.item];
        [assets addObject:asset];
    }
    return assets;
}

- (void)computeDifferenceBetweenRect:(CGRect)oldRect andRect:(CGRect)newRect removedHandler:(void (^)(CGRect removedRect))removedHandler addedHandler:(void (^)(CGRect addedRect))addedHandler {
    if (CGRectIntersectsRect(newRect, oldRect)) {
        CGFloat oldMaxY = CGRectGetMaxY(oldRect);
        CGFloat oldMinY = CGRectGetMinY(oldRect);
        CGFloat newMaxY = CGRectGetMaxY(newRect);
        CGFloat newMinY = CGRectGetMinY(newRect);
        
        if (newMaxY > oldMaxY) {
            CGRect rectToAdd = CGRectMake(newRect.origin.x, oldMaxY, newRect.size.width, (newMaxY - oldMaxY));
            addedHandler(rectToAdd);
        }
        
        if (oldMinY > newMinY) {
            CGRect rectToAdd = CGRectMake(newRect.origin.x, newMinY, newRect.size.width, (oldMinY - newMinY));
            addedHandler(rectToAdd);
        }
        
        if (newMaxY < oldMaxY) {
            CGRect rectToRemove = CGRectMake(newRect.origin.x, newMaxY, newRect.size.width, (oldMaxY - newMaxY));
            removedHandler(rectToRemove);
        }
        
        if (oldMinY < newMinY) {
            CGRect rectToRemove = CGRectMake(newRect.origin.x, oldMinY, newRect.size.width, (newMinY - oldMinY));
            removedHandler(rectToRemove);
        }
    } else {
        addedHandler(newRect);
        removedHandler(oldRect);
    }
}

#pragma mark - PHPhotoLibraryChangeObserver
- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    // Check if there are changes to the assets we are showing.
    PHFetchResultChangeDetails *collectionChanges = [changeInstance changeDetailsForFetchResult:self.allPhotos];
    if (collectionChanges == nil) {
        return;
    }
    
    /*
     Change notifications may be made on a background queue. Re-dispatch to the
     main queue before acting on the change as we'll be updating the UI.
     */
    dispatch_async(dispatch_get_main_queue(), ^{
        // Get the new fetch result.
        self.allPhotos = [collectionChanges fetchResultAfterChanges];
        
        [self resetCachedAssets];
    });
}

#pragma mark - UIViewControllerPreviewingDelegate
- (nullable UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location
{
    // previewingContext.sourceView: 触发Peek & Pop操作的视图
    // previewingContext.sourceRect: 设置触发操作的视图的不被虚化的区域
    __block ACPhotoDetailController *detailVC = [[ACPhotoDetailController alloc] init];

    ACPhotoPickerCell *cell = (ACPhotoPickerCell *)previewingContext.sourceView;
    PHImageRequestOptions * imageOptions;
    imageOptions = [[PHImageRequestOptions alloc] init];
    imageOptions.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
    imageOptions.networkAccessAllowed = NO;
    imageOptions.resizeMode = PHImageRequestOptionsResizeModeFast;
    imageOptions.synchronous = YES;
    
    [[PHImageManager defaultManager] requestImageForAsset:self.allPhotos[cell.indexPath.item] targetSize:self.maximumSize contentMode:PHImageContentModeAspectFit options:imageOptions resultHandler:^(UIImage *result, NSDictionary *info) {
        @autoreleasepool {
            detailVC.photo = result;
        }
    }];
    __weak typeof(self) weakSelf = self;
    [detailVC selectTheImgWithBlock:^(UIImage *photo) {
        if (weakSelf.pickAction) {
            weakSelf.pickAction(photo);
            [weakSelf closePhotoPicker];
        }
    }];
    
    // 预览区域大小(可不设置)
    detailVC.preferredContentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    
    return detailVC;
}

- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit
{
    
    ACPhotoPickerCell *cell = (ACPhotoPickerCell *)previewingContext.sourceView;
    [self changeTheCropContentWithSelectedIndex:cell.indexPath];
    [self closePhotoPicker];
}

@end
