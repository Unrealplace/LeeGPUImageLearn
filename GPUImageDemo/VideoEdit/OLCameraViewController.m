//
//  OLCameraViewController.m
//  GPUImageDemo
//
//  Created by NicoLin on 2018/3/28.
//  Copyright © 2018年 NicoLin. All rights reserved.
//

#import "OLCameraViewController.h"
#import "OLTopToolView.h"
#import "OLBottomToolView.h"
#import "OLCameraManager.h"
#import "OLPhotoEditorViewController.h"

@interface OLCameraViewController ()<OLTopToolViewDelegate,OLBottomToolViewDelegate,OLCameraManagerDelegate>

/**
 顶部操作工具栏
 */
@property (nonatomic,strong)OLTopToolView *topToolView;

/**
 底部操作工具栏
 */
@property (nonatomic,strong)OLBottomToolView *bottomToolView;

/**
 镜头管理
 */
@property (nonatomic,strong)OLCameraManager  *cameraManager;


@end

@implementation OLCameraViewController



- (void)viewDidLoad {
    [super viewDidLoad];

    [self initCameraAndToolBar];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}


/**
 初始化镜头和操作工具栏
 */
- (void)initCameraAndToolBar {
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.cameraManager showVideoViewWith:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)
                                   target:self
                                superView:self.view];
    [self.view addSubview:self.topToolView];
    [self.view addSubview:self.bottomToolView];
    
}

- (OLCameraManager*)cameraManager {
    if (!_cameraManager) {
        _cameraManager = [[OLCameraManager alloc] init];
    }
    return _cameraManager;
}

#pragma mark 顶部工具栏 及其代理方法
- (OLTopToolView*)topToolView {
    if (!_topToolView) {
        _topToolView = [[OLTopToolView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
        _topToolView.delegate = self;
    }
    return _topToolView;
}

- (void)topToolViewClickBack:(OLTopToolView *)topToolView {
    if ([self.navigationController respondsToSelector:@selector(popViewControllerAnimated:)]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark 底部工具栏 及其代理方法
- (OLBottomToolView*)bottomToolView {
    if (!_bottomToolView) {
        _bottomToolView = [[OLBottomToolView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 100, self.view.bounds.size.width, 100)];
        _bottomToolView.delegate = self;
    }
    return _bottomToolView;
}

- (void)bottomToolViewSelectFilter:(OLBottomToolView *)bottomToolView {
    
}

- (void)bottomTooleViewSelectDynamicPaster:(OLBottomToolView *)bottomToolView {
    
    
}

- (void)bottomToolViewClickRecordBtn:(OLRecordButton *)recordBtn recordType:(OLRecordType)recordTye bottomView:(OLBottomToolView *)bottomToolView{
    switch (recordTye) {
            case OLRecordTypeVideoCapture:
        {
            UIButton * btn = (UIButton*)recordBtn;
            btn.selected = !btn.selected;
            if (!btn.selected) {
                [self.cameraManager stopRecordVideo];
            }else {
                [self.cameraManager startRecordVideo];
            }
            
        }
            break;
            case OLRecordTypeEmojiCapture:
            break;
            case OLRecordTypeSingleCapture:
        {
            [self.cameraManager captureSinglePhoto];
        }
            break;
            case OLRecordTypeMutipleCapture:
            break;
            
        default:
            break;
    }
    
}

#pragma mark 镜头代理方法

- (void)cameraCapturePhoto:(UIImage *)img {
    NSLog(@"%@",img);
    OLPhotoEditorViewController * photoVC = [OLPhotoEditorViewController new];
    photoVC.editorImg = img;
    [self.navigationController pushViewController:photoVC animated:YES];
    
}


@end
