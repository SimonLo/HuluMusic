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

@implementation HCNetWorkTool
+ (void)netWorkToolGetWithUrl:(NSString *)url parameters:(NSDictionary *)parameters promptView:(UIView *)view response:(void (^)(id))success
{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status <= 0) {
            MBProgressHUD *netPrompt = [MBProgressHUD showHUDAddedTo:view animated:YES];
            netPrompt.mode = MBProgressHUDModeText;
            netPrompt.labelText = @"没有网络了";
            [netPrompt hide:YES afterDelay:2];
        }else{
            MBProgressHUD *netPrompt = [MBProgressHUD showHUDAddedTo:view animated:YES];
            netPrompt.mode = MBProgressHUDModeIndeterminate;
            netPrompt.labelText = @"正在加载中";
            //加载数据
            AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
            manger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"application/javascript",nil];
            [manger GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (responseObject) {
                    [netPrompt removeFromSuperview];
                    if (success) {
                        success(responseObject);
                    }
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [netPrompt removeFromSuperview];
                HCLog(@"%@",error);
            }];
        }
    }];
}
@end
