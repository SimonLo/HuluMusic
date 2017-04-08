//
//  HCDownLoaderFileTool.h
//  HCDownLoadLib
//
//  Created by SimonLo on 2016/11/26.
//  Copyright © 2016年 SimonLo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HCDownLoaderFileTool : NSObject

+ (BOOL)isFileExists: (NSString *)path;

+ (long long)fileSizeWithPath: (NSString *)path;

+ (void)moveFile:(NSString *)fromPath toPath: (NSString *)toPath;

+ (void)removeFileAtPath: (NSString *)path;

@end
