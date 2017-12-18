#import "GPUImageOutput.h"
#import "GPUImageFilter.h"

//GPUImageFilterGroup继承自GPUImageOutput ，实现了GPUImageInput协议。
//因此，可以自身可以作为独立的滤镜参与响应链中。
//相比GPUImageFilterPipeline，GPUImageFilterGroup功能更强大。

//GPUImageFilterPipeline、GPUImageFilterGroup 都可用于组合滤镜，
//GPUImageFilterPipeline相对比较简单，可定制程度较低，而GPUImageFilterGroup则功能比较强大，可定制程度高。
//在选用的时候可以根据自己的需求，选用不同的滤镜组合。



@interface GPUImageFilterGroup : GPUImageOutput <GPUImageInput>
{
    NSMutableArray *filters; //滤镜数组
    BOOL isEndProcessing; // 是否结束了处理图片进程
}

@property(readwrite, nonatomic, strong) GPUImageOutput<GPUImageInput> *terminalFilter; // 最终的滤镜
@property(readwrite, nonatomic, strong) NSArray *initialFilters; // 初始化滤镜数组
@property(readwrite, nonatomic, strong) GPUImageOutput<GPUImageInput> *inputFilterToIgnoreForUpdates; 

// 增加新的滤镜链
- (void)addFilter:(GPUImageOutput<GPUImageInput> *)newFilter;
// 返回对应位置的滤镜
- (GPUImageOutput<GPUImageInput> *)filterAtIndex:(NSUInteger)filterIndex;
// 返回滤镜个数
- (NSUInteger)filterCount;

@end
