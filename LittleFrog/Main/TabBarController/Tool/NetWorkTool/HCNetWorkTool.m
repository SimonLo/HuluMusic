//
//  HCNetWorkTool.m
//  LittleFrog
//
//  Created by huangcong on 16/4/23.
//  Copyright © 2016年 HuangCong. All rights reserved.
//

#import "HCNetWorkTool.h"
#import <AFNetworking.h>
#import <MBProgressHUD.h>

@interface SLHTTPSessionManager : AFHTTPSessionManager

+ (instancetype)shareManager;

@end

@implementation SLHTTPSessionManager

static SLHTTPSessionManager *_shareManager;

+ (instancetype)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_shareManager == nil) {
            NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
            config.timeoutIntervalForRequest = 8.0;
            _shareManager = [[self alloc] initWithSessionConfiguration:config];
        }
    });
    return _shareManager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_shareManager == nil) {
            _shareManager = [super allocWithZone:zone];
        }
    });
    return _shareManager;
}

@end

@implementation HCNetWorkTool
+ (void)netWorkToolGetWithUrl:(NSString *)url parameters:(NSDictionary *)parameters response:(void (^)(id))success failure:(void (^)(id))failure
{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status <= 0) {
            [HCPromptTool promptModeText:@"没有网络了" afterDelay:2];
            if (failure) {
                failure(nil);
            }
        }else{
//            MBProgressHUD *netPrompt = [HCPromptTool promptModeIndeterminatetext:@"正在加载中"];
            //加载数据
            SLHTTPSessionManager *manger = [SLHTTPSessionManager shareManager];
            manger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"application/javascript",nil];
            [manger GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (responseObject) {
//                    [netPrompt removeFromSuperview];
                    if (success) {
                        success(responseObject);
                    }
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                [netPrompt removeFromSuperview];
                HCLog(@"%@",error);
                if (failure) {
                    failure(error);
                }
            }];
        }
    }];
}

+ (void)netWorkToolDownloadWithUrl:(NSString *)string targetPath:(NSSearchPathDirectory)path DomainMask:(NSSearchPathDomainMask)mask endPath:(void(^)(NSURL *endPath))endPath
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDataTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSURL *documentUrl = [[NSFileManager defaultManager] URLForDirectory:path inDomain:mask appropriateForURL:nil create:NO error:nil];
        return [documentUrl URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        HCLog(@"%@",error);
        if (!error && endPath) {
            endPath(filePath);
        }
    }];
    [downloadTask resume];
}
@end
