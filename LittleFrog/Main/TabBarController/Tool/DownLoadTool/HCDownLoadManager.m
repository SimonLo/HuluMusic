//
//  HCDownLoadManager.m
//  HCDownLoaderDemo
//
//  Created by Simon Lo on 2017/3/22.
//  Copyright © 2017年 Simon Lo. All rights reserved.
//

#import "HCDownLoadManager.h"
#import "NSString+HCMD5.h"

@interface HCDownLoadManager()

@property (nonatomic, strong) NSMutableDictionary <NSString *, HCDownLoader *>*downLoadInfo;

@end

@implementation HCDownLoadManager

// 绝对的单例: 无论通过什么样的方式, 创建, 都是一个对象
// 非绝对的单例
static HCDownLoadManager *_shareInstance;
+ (instancetype)shareInstance {
    if (!_shareInstance) {
        _shareInstance = [[HCDownLoadManager alloc] init];
    }
    return _shareInstance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    if (!_shareInstance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _shareInstance = [super allocWithZone:zone];
        });
    }
    return _shareInstance;
}


- (NSMutableDictionary *)downLoadInfo {
    if (!_downLoadInfo) {
        _downLoadInfo = [NSMutableDictionary dictionary];
    }
    return _downLoadInfo;
}

- (void)downLoadWithURL: (NSURL *)url progress:(DownLoadProgressType)progressBlock success: (DownLoadSuccessType)successBlock failed: (DownLoadFailType)failBlock {
    [self downLoadWithURL:url downLoadInfo:nil progress:progressBlock state:nil success:successBlock failed:failBlock];
}

- (void)downLoadWithURL: (NSURL *)url downLoadInfo: (DownLoadInfoType)downLoadBlock progress:(DownLoadProgressType)progressBlock state:(DownLoadStateChangeType)stateBlock success: (DownLoadSuccessType)successBlock failed: (DownLoadFailType)failBlock {
    
    NSString *md5 = [url.absoluteString md5Str];
    
    HCDownLoader *downLoader = self.downLoadInfo[md5];
    if (downLoader) {
        [downLoader resume];
        return ;
    }
    downLoader = [[HCDownLoader alloc] init];
    [self.downLoadInfo setValue:downLoader forKey:md5];
    
    __weak typeof(self) weakSelf = self;
    [downLoader downLoadWithURL:url downLoadInfo:downLoadBlock progress:progressBlock state:stateBlock success:^(NSString *cacheFilePath) {
        [weakSelf.downLoadInfo removeObjectForKey:md5];
        if(successBlock) {
            successBlock(cacheFilePath);
        }
    } failed:^(NSString *errMsg) {
        [weakSelf.downLoadInfo removeObjectForKey:md5];
        if (failBlock) {
            failBlock(errMsg);
        }
    }];
    
    
    return ;
}


- (HCDownLoader *)downLoadWithURL: (NSURL *)url {
    
    // 文件名称  aaa/a.x  bb/a.x
    NSString *md5 = [url.absoluteString md5Str];
    
    HCDownLoader *downLoader = self.downLoadInfo[md5];
    if (downLoader) {
        [downLoader resume];
        return downLoader;
    }
    downLoader = [[HCDownLoader alloc] init];
    [self.downLoadInfo setValue:downLoader forKey:md5];
    
    __weak typeof(self) weakSelf = self;
    [downLoader downLoadWithURL:url downLoadInfo:nil progress:nil state:nil success:^(NSString *cacheFilePath) {
        [weakSelf.downLoadInfo removeObjectForKey:md5];
    } failed:^(NSString *errMsg){
        [weakSelf.downLoadInfo removeObjectForKey:md5];
    }];
    
    return downLoader;
}

- (HCDownLoader *)getDownLoaderWithURL: (NSURL *)url {
    NSString *md5 = [url.absoluteString md5Str];
    HCDownLoader *downLoader = self.downLoadInfo[md5];
    return downLoader;
}

- (void)pauseWithURL: (NSURL *)url {
    NSString *md5 = [url.absoluteString md5Str];
    HCDownLoader *downLoader = self.downLoadInfo[md5];
    [downLoader pause];
}

- (void)cancelWithURL: (NSURL *)url {
    NSString *md5 = [url.absoluteString md5Str];
    HCDownLoader *downLoader = self.downLoadInfo[md5];
    [downLoader cancel];
}
- (void)cancelAndClearWithURL: (NSURL *)url {
    NSString *md5 = [url.absoluteString md5Str];
    HCDownLoader *downLoader = self.downLoadInfo[md5];
    [downLoader cancelAndClearCache];
}

- (void)pauseAll {
    [[self.downLoadInfo allValues] makeObjectsPerformSelector:@selector(pause)];
}


- (void)resumeAll {
    [[self.downLoadInfo allValues] makeObjectsPerformSelector:@selector(resume)];
}


@end
