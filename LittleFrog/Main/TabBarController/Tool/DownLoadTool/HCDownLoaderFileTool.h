//
//  HCDownLoaderFileTool.h
//  HCDownLoaderDemo
//
//  Created by Simon Lo on 2017/3/22.
//  Copyright © 2017年 Simon Lo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HCDownLoaderFileTool : NSObject

+ (BOOL)isFileExists: (NSString *)path;

+ (long long)fileSizeWithPath: (NSString *)path;

+ (void)moveFile:(NSString *)fromPath toPath: (NSString *)toPath;

+ (void)removeFileAtPath: (NSString *)path;

@end
