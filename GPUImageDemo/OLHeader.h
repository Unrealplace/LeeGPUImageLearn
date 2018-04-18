//
//  OLHeader.h
//  GPUImageDemo
//
//  Created by NicoLin on 2018/4/13.
//  Copyright © 2018年 NicoLin. All rights reserved.
//

#ifndef OLHeader_h
#define OLHeader_h


#define OLog(format, ...) printf("[Class: <%p %s:Line(%d) > Method: %s] + Log-->\n%s\n", self, [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String] )


#endif /* OLHeader_h */
