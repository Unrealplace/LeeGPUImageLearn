#import "GPUImageTwoInputFilter.h"

//GPUImageLookupFilter 是GPUImage中的颜色查找滤镜，在一般的相机应用中使用得最广泛，它的作用是通过颜色变换从而产生出新风格的图片。
//接下来就看一下颜色超招标如何在GPUImage实现的。以下是源码内容：

@interface GPUImageLookupFilter : GPUImageTwoInputFilter
{
    GLint intensityUniform;
}

//LUT （Lookup Tables）即查找表 。
//LUT是个非常简单的数值转换表，不同的色彩输入数值“映射”到一套输出数值，用来改变图像的色彩。
//例如：红色在LUT中可能被映射成蓝色，于是，应用LUT的图像中每个红的地方将由蓝色取代。
//不过，LUT的实际应用要比这种情况更微妙一些。LUT通常用来矫正域外色的问题。
//例如，一个以RGB色彩空间存储的图像要打印到纸上时，必须首先将文件转换为CMYK色彩空间。
//这可以用一个LUT将每个RGB色彩转换为等效的CMYK色彩，或者与域外色最接近的色彩（LUT还能够用缩放的方法在一定程度改变所有的色彩，因此可使图像在视觉上与原来相同）。
//另外需要注意的一个问题是，尽管查找表经常效率很高，但是如果所替换的计算相当简单的话就会得不偿失，这不仅仅因为从内存中提取结果需要更多的时间，而且因为它增大了所需的内存并且破坏了高速缓存。
//如果查找表太大，那么几乎每次访问查找表都会导致高速缓存缺失，这在处理器速度超过内存速度的时候愈发成为一个问题。



// How To Use:
// 1) Use your favourite photo editing application to apply a filter to lookup.png from GPUImage/framework/Resources.
// For this to work properly each pixel color must not depend on other pixels (e.g. blur will not work).
// If you need more complex filter you can create as many lookup tables as required.
// E.g. color_balance_lookup_1.png -> GPUImageGaussianBlurFilter -> color_balance_lookup_2.png
// 2) Use you new lookup.png file as a second input for GPUImageLookupFilter.

// See GPUImageAmatorkaFilter, GPUImageMissEtikateFilter, and GPUImageSoftEleganceFilter for example.

// Additional Info:
// Lookup texture is organised as 8x8 quads of 64x64 pixels representing all possible RGB colors:
//for (int by = 0; by < 8; by++) {
//    for (int bx = 0; bx < 8; bx++) {
//        for (int g = 0; g < 64; g++) {
//            for (int r = 0; r < 64; r++) {
//                image.setPixel(r + bx * 64, g + by * 64, qRgb((int)(r * 255.0 / 63.0 + 0.5),
//                                                              (int)(g * 255.0 / 63.0 + 0.5),
//                                                              (int)((bx + by * 8.0) * 255.0 / 63.0 + 0.5)));
//            }
//        }
//    }
//}

// Opacity/intensity of lookup filter ranges from 0.0 to 1.0, with 1.0 as the normal setting
@property(readwrite, nonatomic) CGFloat intensity;

@end
