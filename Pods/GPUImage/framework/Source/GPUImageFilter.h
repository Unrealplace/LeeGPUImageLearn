#import "GPUImageOutput.h"

#define STRINGIZE(x) #x
#define STRINGIZE2(x) STRINGIZE(x)
#define SHADER_STRING(text) @ STRINGIZE2(text)

#define GPUImageHashIdentifier #
#define GPUImageWrappedLabel(x) x
#define GPUImageEscapedHashIdentifier(a) GPUImageWrappedLabel(GPUImageHashIdentifier)a

extern NSString *const kGPUImageVertexShaderString;
extern NSString *const kGPUImagePassthroughFragmentShaderString;

////在 GPUImage 中主要用到了3维向量、4维向量、4x4矩阵、3x3矩阵，对应OpenGL中的vec3、vec4、mat4、mat3。
//之所以使用这些向量、矩阵，是为了方便向着色器传值。
//在 GPUImageFilter 中定义了一组传值的接口，在需要向着色器传值的时候很方便。具体向量定义如下：

struct GPUVector4 {
    GLfloat one;
    GLfloat two;
    GLfloat three;
    GLfloat four;
};
typedef struct GPUVector4 GPUVector4;

struct GPUVector3 {
    GLfloat one;
    GLfloat two;
    GLfloat three;
};
typedef struct GPUVector3 GPUVector3;

struct GPUMatrix4x4 {
    GPUVector4 one;
    GPUVector4 two;
    GPUVector4 three;
    GPUVector4 four;
};
typedef struct GPUMatrix4x4 GPUMatrix4x4;

struct GPUMatrix3x3 {
    GPUVector3 one;
    GPUVector3 two;
    GPUVector3 three;
};
typedef struct GPUMatrix3x3 GPUMatrix3x3;

/** GPUImage's base filter class
 
 GPUImageFilter 是GPUImage中很重要、很基础的类，它可以处理帧缓存对象的输入输出，但是对纹理并不添加任何特效，也就是说只是简单的让纹理通过。
 它更多的是作为其它滤镜的基类，一些具体的滤镜由它的子类去完成。
 同时它也只能处理单个帧缓存对象的输入，处理多个帧缓存对象的输入也是由它的子类去完成。以下是源码内容：
 
 
 Filters and other subsequent elements in the chain conform to the GPUImageInput protocol, which lets them take in the supplied or processed texture from the previous link in the chain and do something with it. Objects one step further down the chain are considered targets, and processing can be branched by adding multiple targets to a single output or filter.
 */

//GPUImageFilter 本身并不实现相关的滤镜特效，只是简单的输出输入的纹理样式。
//GPUImageFilter 更多的是作为其它滤镜的基类，它提供了许多最基础的接口，以及控制了整个滤镜链的基本流程。
//GPUImageFilter 继承自 GPUImageOutput 实现了 GPUImageInput 协议，可以将输入的纹理经过相关处理后输出，从而对纹理应用相关特效。
//在一个响应链中可以有多个 GPUImageFilter，从而实现了叠加滤镜的效果。


//GPUImageFilter 中有两个比较重要的实例变量 firstInputFramebuffer、filterProgram。
//firstInputFramebuffer 表示输入帧缓存对象，filterProgram 表示GL程序。
@interface GPUImageFilter : GPUImageOutput <GPUImageInput>
{
    // 输入帧缓存对象
    GPUImageFramebuffer *firstInputFramebuffer;
    // GL程序
    GLProgram *filterProgram;
    // 属性变量
    GLint filterPositionAttribute, filterTextureCoordinateAttribute;
    // 纹理统一变量
    GLint filterInputTextureUniform;
    // GL清屏颜色
    GLfloat backgroundColorRed, backgroundColorGreen, backgroundColorBlue, backgroundColorAlpha;
    // 结束处理操作
    BOOL isEndProcessing;
    
    CGSize currentFilterSize;
    // 屏幕旋转方向
    GPUImageRotationMode inputRotation;
    
    BOOL currentlyReceivingMonochromeInput;
    
    // 保存RestorationBlocks的字典
    NSMutableDictionary *uniformStateRestorationBlocks;
    // 信号量
    dispatch_semaphore_t imageCaptureSemaphore;
    
}

@property(readonly) CVPixelBufferRef renderTarget;
@property(readwrite, nonatomic) BOOL preventRendering;
@property(readwrite, nonatomic) BOOL currentlyReceivingMonochromeInput;

/// @name Initialization and teardown

/**
  三个不同的初始化方法
 */
- (id)initWithVertexShaderFromString:(NSString *)vertexShaderString fragmentShaderFromString:(NSString *)fragmentShaderString;
- (id)initWithFragmentShaderFromString:(NSString *)fragmentShaderString;
- (id)initWithFragmentShaderFromFile:(NSString *)fragmentShaderFilename;


- (void)initializeAttributes;

// 变换方法
- (void)setupFilterForSize:(CGSize)filterFrameSize;
- (CGSize)rotatedSize:(CGSize)sizeToRotate forIndex:(NSInteger)textureIndex;
- (CGPoint)rotatedPoint:(CGPoint)pointToRotate forRotation:(GPUImageRotationMode)rotation;





// 查询方法
- (CGSize)sizeOfFBO;
+ (const GLfloat *)textureCoordinatesForRotation:(GPUImageRotationMode)rotationMode;
- (CGSize)outputFrameSize;


// 渲染方法
- (void)renderToTextureWithVertices:(const GLfloat *)vertices textureCoordinates:(const GLfloat *)textureCoordinates;
- (void)informTargetsAboutNewFrameAtTime:(CMTime)frameTime;

// 设置清屏颜色
- (void)setBackgroundColorRed:(GLfloat)redComponent green:(GLfloat)greenComponent blue:(GLfloat)blueComponent alpha:(GLfloat)alphaComponent;


// 传值方法 给uniformName 传不同的值
- (void)setInteger:(GLint)newInteger forUniformName:(NSString *)uniformName;
- (void)setFloat:(GLfloat)newFloat forUniformName:(NSString *)uniformName;
- (void)setSize:(CGSize)newSize forUniformName:(NSString *)uniformName;
- (void)setPoint:(CGPoint)newPoint forUniformName:(NSString *)uniformName;
- (void)setFloatVec3:(GPUVector3)newVec3 forUniformName:(NSString *)uniformName;
- (void)setFloatVec4:(GPUVector4)newVec4 forUniform:(NSString *)uniformName;
- (void)setFloatArray:(GLfloat *)array length:(GLsizei)count forUniform:(NSString*)uniformName;



- (void)setMatrix3f:(GPUMatrix3x3)matrix forUniform:(GLint)uniform program:(GLProgram *)shaderProgram;
- (void)setMatrix4f:(GPUMatrix4x4)matrix forUniform:(GLint)uniform program:(GLProgram *)shaderProgram;
- (void)setFloat:(GLfloat)floatValue forUniform:(GLint)uniform program:(GLProgram *)shaderProgram;
- (void)setPoint:(CGPoint)pointValue forUniform:(GLint)uniform program:(GLProgram *)shaderProgram;
- (void)setSize:(CGSize)sizeValue forUniform:(GLint)uniform program:(GLProgram *)shaderProgram;
- (void)setVec3:(GPUVector3)vectorValue forUniform:(GLint)uniform program:(GLProgram *)shaderProgram;
- (void)setVec4:(GPUVector4)vectorValue forUniform:(GLint)uniform program:(GLProgram *)shaderProgram;
- (void)setFloatArray:(GLfloat *)arrayValue length:(GLsizei)arrayLength forUniform:(GLint)uniform program:(GLProgram *)shaderProgram;
- (void)setInteger:(GLint)intValue forUniform:(GLint)uniform program:(GLProgram *)shaderProgram;

- (void)setAndExecuteUniformStateCallbackAtIndex:(GLint)uniform forProgram:(GLProgram *)shaderProgram toBlock:(dispatch_block_t)uniformStateBlock;
- (void)setUniformsForProgramAtIndex:(NSUInteger)programIndex;

@end
