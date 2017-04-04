//
//  HCNetWorkTool.h
//  LittleFrog
//
//  Created by huangcong on 16/4/23.
//  Copyright © 2016年 HuangCong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface HCNetWorkTool : NSObject

+ (void)netWorkToolGetWithUrl:(NSString *)url parameters:(NSDictionary *)parameters response:(void(^)(id response))success failure:(void(^)(id response))failure;
+ (void)netWorkToolDownloadWithUrl:(NSString *)string targetPath:(NSSearchPathDirectory)path DomainMask:(NSSearchPathDomainMask)mask endPath:(void(^)(NSURL *endPath))endPath;
@end
