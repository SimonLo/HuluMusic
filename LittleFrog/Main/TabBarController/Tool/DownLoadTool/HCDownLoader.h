//
//  HCDownLoader.h
//  HCDownLoaderDemo
//
//  Created by Simon Lo on 2017/3/22.
//  Copyright © 2017年 Simon Lo. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kDownLoadURLOrStateChangeNotification @"downLoadURLOrStateChangeNotification"

typedef enum : NSUInteger {
    HCDownLoaderStateUnKnown,
    /** 下载暂停 */
    HCDownLoaderStatePause,
    /** 正在下载 */
    HCDownLoaderStateDowning,
    /** 已经下载 */
    HCDownLoaderStateSuccess,
    /** 下载失败 */
    HCDownLoaderStateFailed
} HCDownLoaderState;

typedef void(^DownLoadInfoType)(long long fileSize);
typedef void(^DownLoadProgressType)(float progress);
typedef void(^DownLoadStateChangeType)(HCDownLoaderState state);
typedef void(^DownLoadSuccessType)(NSString *cacheFilePath);
typedef void(^DownLoadFailType)(NSString *msg);

@interface HCDownLoader : NSObject
// 如果当前已经下载, 继续下载, 如果没有下载, 从头开始下载
- (void)downLoadWithURL: (NSURL *)url;

- (void)downLoadWithURL: (NSURL *)url downLoadInfo: (DownLoadInfoType)downLoadBlock progress:(DownLoadProgressType)progressBlock state:(DownLoadStateChangeType)stateBlock success: (DownLoadSuccessType)successBlock failed: (DownLoadFailType)failBlock;

+ (NSString *)downLoadedFileWithURL: (NSURL *)url;
+ (long long)tmpCacheSizeWithURL: (NSURL *)url;
+ (void)clearCacheWithURL: (NSURL *)url;

// 恢复下载
- (void)resume;

// 暂停, 暂停任务, 可以恢复, 缓存没有删除
- (void)pause;

// 取消
- (void)cancel;

// 缓存删除
- (void)cancelAndClearCache;

// 状态
@property (nonatomic, assign, readonly) HCDownLoaderState state;

// 进度
@property (nonatomic, assign) float progress;

// 下载进度
@property (nonatomic, copy) DownLoadProgressType downLoadProgress;

// 文件下载信息 (下载的大小)
@property (nonatomic, copy) DownLoadInfoType downLoadInfo;

// 状态的改变 ()
@property (nonatomic, copy) DownLoadStateChangeType downLoadStateChange;

// 下载成功 (成功路径)
@property (nonatomic, copy) DownLoadSuccessType downLoadSuccess;

// 失败 (错误信息)
@property (nonatomic, copy) DownLoadFailType downLoadError;


@end
