//
//  HCRankListModel.m
//  LittleFrog
//
//  Created by huangcong on 16/4/26.
//  Copyright © 2016年 HuangCong. All rights reserved.
//

#import "HCRankListModel.h"

@implementation HCRankListModel
+ (NSArray *)mj_ignoredPropertyNames
{
    return @[@"count",@"web_url",@"pic_s192",@"pic_s210"];
}
@end
