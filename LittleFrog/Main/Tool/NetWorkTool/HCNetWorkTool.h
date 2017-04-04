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

+ (void)netWorkToolGetWithUrl:(NSString *)url parameters:(NSDictionary *)parameters promptView:(UIView *)view response:(void(^)(id response))success;

@end
