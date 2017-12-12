#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import "GPUImageContext.h"
#import "GPUImageOutput.h"

extern const GLfloat kColorConversion601[];
extern const GLfloat kColorConversion601FullRange[];
extern const GLfloat kColorConversion709[];
extern NSString *const kGPUImageYUVVideoRangeConversionForRGFragmentShaderString;
extern NSString *const kGPUImageYUVFullRangeConversionForLAFragmentShaderString;
extern NSString *const kGPUImageYUVVideoRangeConversionForLAFragmentShaderString;


//Delegate Protocal for Face Detection. 人脸检测的协议
@protocol GPUImageVideoCameraDelegate <NSObject>

@optional
- (void)willOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer;
@end


/**
 GPUImageVideoCamera继承自GPUImageOutput，实现了 AVCaptureVideoDataOutputSampleBufferDelegate 和 AVCaptureAudioDataOutputSampleBufferDelegate 协议。GPUImageVideoCamera可以调用相机进行视频拍摄，拍摄之后会生成帧缓存对象，我们可以使用GPUImageView显示，也可以使用GPUImageMovieWriter保存为视频文件。同时也提供了GPUImageVideoCameraDelegate 代理，方便我们自己处理CMSampleBuffer。在处理视频的时候会涉及到以下概念：
 
*/
@interface GPUImageVideoCamera : GPUImageOutput <AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate>
{
    NSUInteger numberOfFramesCaptured;
    CGFloat totalFrameTimeDuringCapture;
    
    AVCaptureSession *_captureSession;
    AVCaptureDevice *_inputCamera;
    AVCaptureDevice *_microphone;
    AVCaptureDeviceInput *videoInput;
	AVCaptureVideoDataOutput *videoOutput;

    BOOL capturePaused;
    GPUImageRotationMode outputRotation, internalRotation;
    dispatch_semaphore_t frameRenderingSemaphore;
        
    BOOL captureAsYUV;
    GLuint luminanceTexture, chrominanceTexture; //亮度纹理 和 色度纹理


    __unsafe_unretained id<GPUImageVideoCameraDelegate> _delegate;
}


// AVCaptureSession对象
@property(readonly, retain, nonatomic) AVCaptureSession *captureSession;

// 视频输出的质量、大小的控制参数。如：AVCaptureSessionPreset640x480
@property (readwrite, nonatomic, copy) NSString *captureSessionPreset;

// 视频的帧率  Setting this to 0 or below will set the frame rate back to the default setting for a particular preset.

@property (readwrite) int32_t frameRate;

// 正在使用哪个相机 前置还是后置
@property (readonly, getter = isFrontFacingCameraPresent) BOOL frontFacingCameraPresent;
@property (readonly, getter = isBackFacingCameraPresent) BOOL backFacingCameraPresent;

// 实时日志输出
@property(readwrite, nonatomic) BOOL runBenchmark;

// 正在使用的相机对象，方便设置参数
@property(readonly) AVCaptureDevice *inputCamera;

// 输出图片的方向
@property(readwrite, nonatomic) UIInterfaceOrientation outputImageOrientation;

// 前置相机水平镜像
@property(readwrite, nonatomic) BOOL horizontallyMirrorFrontFacingCamera, horizontallyMirrorRearFacingCamera;

// GPUImageVideoCameraDelegate代理
@property(nonatomic, assign) id<GPUImageVideoCameraDelegate> delegate;


/// @name Initialization and teardown

//GPUImageVideoCamera初始化方法比较少，初始化的时候需要传递视频质量以及使用哪个相机。
//如果直接调用
//- (instancetype)init 则会使用 AVCaptureSessionPreset640x480 和 AVCaptureDevicePositionBack 来初始化。


- (id)initWithSessionPreset:(NSString *)sessionPreset cameraPosition:(AVCaptureDevicePosition)cameraPosition;

/** 将音频捕获添加到会话。添加输入和输出暂时冻结捕获会话，所以你
 如果要设置audioEncodingTarget，可以使用此方法尽早添加音频输入和输出
 后来。返回YES是添加了音频输入和输出，如果已经添加，则返回NO。
 */
- (BOOL)addAudioInputsAndOutputs;

/** 删除此会话中的音频捕获输入和输出。如果音频输入和输出返回YES
 被删除，否则他们还没有被添加。
 */
- (BOOL)removeAudioInputsAndOutputs;

- (void)removeInputsAndOutputs;

// 开始、关闭、暂停、恢复相机捕获
- (void)startCameraCapture;

- (void)stopCameraCapture;

- (void)pauseCameraCapture;

- (void)resumeCameraCapture;



/** 处理视频帧缓存
 */
- (void)processVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer;

/**处理音频帧缓存
 */
- (void)processAudioSampleBuffer:(CMSampleBufferRef)sampleBuffer;


// 获取相机相关参数
- (AVCaptureDevicePosition)cameraPosition;
- (AVCaptureConnection *)videoCaptureConnection;
+ (BOOL)isBackFacingCameraPresent;
+ (BOOL)isFrontFacingCameraPresent;

/** 切换相机
 */
- (void)rotateCamera;


/** 获取平均帧率
 When benchmarking is enabled, this will keep a running average of the time from uploading, processing, and final recording or display
 */
- (CGFloat)averageFrameDurationDuringCapture;
// 重置相关基准
- (void)resetBenchmarkAverage;



@end
