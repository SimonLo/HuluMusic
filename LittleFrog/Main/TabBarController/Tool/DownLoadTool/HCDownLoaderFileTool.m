//
//  HCDownLoaderFileTool.m
//  HCDownLoaderDemo
//
//  Created by Simon Lo on 2017/3/22.
//  Copyright © 2017年 Simon Lo. All rights reserved.
//

#import "HCDownLoaderFileTool.h"

@implementation HCDownLoaderFileTool

+ (BOOL)isFileExists: (NSString *)path {
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

+ (long long)fileSizeWithPath: (NSString *)path {
    
    if (![self isFileExists:path]) {
        return 0;
    }
    
    NSDictionary *fileInfo = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
    
    long long size = [fileInfo[NSFileSize] longLongValue];
    
    return size;
}

+ (void)moveFile:(NSString *)fromPath toPath: (NSString *)toPath {
    
    if (![self isFileExists:fromPath]) {
        return;
    }
    
    [[NSFileManager defaultManager] moveItemAtPath:fromPath toPath:toPath error:nil];
    
    
}

+ (void)removeFileAtPath: (NSString *)path {
    
    if (![self isFileExists:path]) {
        return;
    }
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    
}


@end
