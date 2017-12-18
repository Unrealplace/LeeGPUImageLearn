//
//  MutipleInputVC.m
//  GPUImageDemo
//
//  Created by NicoLin on 2017/12/18.
//  Copyright © 2017年 NicoLin. All rights reserved.
//

#import "MutipleInputVC.h"
#import <GPUImage.h>

@interface MutipleInputVC ()

@property (nonatomic,strong)GPUImageView * twoInputView;

@end

@implementation MutipleInputVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.twoInputView];
    

}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self twoInput];
}

- (GPUImageView*)twoInputView {
    if (!_twoInputView) {
        _twoInputView = [[GPUImageView alloc] initWithFrame:CGRectMake(0, 74, 200, 200)];
        _twoInputView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
    }
    return _twoInputView;
}

//GPUImageTwoInputFilter、GPUImageThreeInputFilter、GPUImageFourInputFilter
//这几个类在我们需要合并多个滤镜处理结果的时候会很有用，在使用的时候也比较简单。
//当然在GPUImage框架中已有很多滤镜继承自这几个类，可以处理多个纹理的输入。

- (void)twoInput {
    
    NSString *const kTwoInputFragmentShaderString = SHADER_STRING
    (
     varying highp vec2 textureCoordinate;
     varying highp vec2 textureCoordinate2;
     
     uniform sampler2D inputImageTexture;
     uniform sampler2D inputImageTexture2;
     
     void main()
     {
         highp vec4 oneInputColor = texture2D(inputImageTexture, textureCoordinate);
         highp vec4 twoInputColor = texture2D(inputImageTexture2, textureCoordinate2);
         
         highp float range = distance(textureCoordinate, vec2(0.5, 0.5));
         
         highp vec4 dstClor = oneInputColor;
         if (range < 0.25) {
             dstClor = twoInputColor;
         }else {
             //dstClor = vec4(vec3(1.0 - oneInputColor), 1.0);
             if (oneInputColor.r < 0.001 && oneInputColor.g < 0.001 && oneInputColor.b < 0.001) {
                 dstClor = vec4(1.0);
             }else {
                 dstClor = vec4(1.0, 0.0, 0.0, 1.0);
             }
         }
         
         gl_FragColor = dstClor;
     }
     );
    
    GPUImagePicture * pic = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"girl1"]];
    // 滤镜
    GPUImageCannyEdgeDetectionFilter *cannyFilter = [[GPUImageCannyEdgeDetectionFilter alloc] init];
    GPUImageGammaFilter *gammaFilter = [[GPUImageGammaFilter alloc] init];
    
    [pic addTarget:cannyFilter];
    [pic addTarget:gammaFilter];
    
    // GPUImageTwoInputFilter
    GPUImageTwoInputFilter *twoFilter = [[GPUImageTwoInputFilter alloc] initWithFragmentShaderFromString:kTwoInputFragmentShaderString];
    
    [cannyFilter addTarget:twoFilter];
    [gammaFilter addTarget:twoFilter];
    [twoFilter addTarget:_twoInputView];
    
    [pic processImage];
}

@end
