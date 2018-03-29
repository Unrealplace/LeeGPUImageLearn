//
//  OLPhotoEditorViewController.m
//  GPUImageDemo
//
//  Created by NicoLin on 2018/3/29.
//  Copyright © 2018年 NicoLin. All rights reserved.
//

#import "OLPhotoEditorViewController.h"
#import "OLPhotoEditorToolView.h"
#import <GPUImage.h>

@interface OLPhotoEditorViewController ()<OLPhotoEditorToolViewDelegate>

@property (nonatomic,strong)GPUImageView *editorImgView;
@property (nonatomic,strong)OLPhotoEditorToolView *editorToolView;
@property (nonatomic,strong)GPUImagePicture *inputPic;

@end

@implementation OLPhotoEditorViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.editorToolView];
    [self.view addSubview:self.editorImgView];
    [self.inputPic addTarget:self.editorImgView];
    [self.inputPic processImage];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.hidden = YES;

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (GPUImagePicture*)inputPic {
    if (!_inputPic) {
        _inputPic = [[GPUImagePicture alloc] initWithImage:self.editorImg];
    }
    return _inputPic;
}

- (GPUImageView*)editorImgView {
    if (!_editorImgView) {
        _editorImgView = [[GPUImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 100)];
        _editorImgView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
    }
    return _editorImgView;
}

- (OLPhotoEditorToolView*)editorToolView {
    if (!_editorToolView) {
        _editorToolView = [[OLPhotoEditorToolView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 100, self.view.bounds.size.width, 100)];
        _editorToolView.backgroundColor = [UIColor whiteColor];
        _editorToolView.delegate = self;
    }
    return _editorToolView;
}

- (void)editorToolViewClickBack {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
