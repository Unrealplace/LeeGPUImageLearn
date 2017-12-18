#import <Foundation/Foundation.h>
#import "GPUImageOutput.h"

//GPUImageFilterPipeline 继承自NSObject，它的主要作用是管理滤镜链，自身不能参与响应链中。
//可以用来构建简单的滤镜组合。
//如果滤镜比较复杂或是涉及到多个纹理的处理，GPUImageFilterGroup则是更好的选择。
@interface GPUImageFilterPipeline : NSObject
{
    NSString *stringValue;
}

// 滤镜数组
@property (strong) NSMutableArray *filters;
// 输入源
@property (strong) GPUImageOutput *input;
// 输出源
@property (strong) id <GPUImageInput> output;

- (id) initWithOrderedFilters:(NSArray*) filters input:(GPUImageOutput*)input output:(id <GPUImageInput>)output;
- (id) initWithConfiguration:(NSDictionary*) configuration input:(GPUImageOutput*)input output:(id <GPUImageInput>)output;
- (id) initWithConfigurationFile:(NSURL*) configuration input:(GPUImageOutput*)input output:(id <GPUImageInput>)output;

// filter的增加、删除、替换
- (void) addFilter:(GPUImageOutput<GPUImageInput> *)filter;
- (void) addFilter:(GPUImageOutput<GPUImageInput> *)filter atIndex:(NSUInteger)insertIndex;
- (void) replaceFilterAtIndex:(NSUInteger)index withFilter:(GPUImageOutput<GPUImageInput> *)filter;
- (void) replaceAllFilters:(NSArray *) newFilters;
- (void) removeFilter:(GPUImageOutput<GPUImageInput> *)filter;
- (void) removeFilterAtIndex:(NSUInteger)index;
- (void) removeAllFilters;

// 由final filter生成图片
- (UIImage *) currentFilteredFrame;
// 由final filter生成图片 ，控制图片方向
- (UIImage *) currentFilteredFrameWithOrientation:(UIImageOrientation)imageOrientation;
- (CGImageRef) newCGImageFromCurrentFilteredFrame;

@end
