//
//  HCRankSongModel.m
//  LittleFrog
//
//  Created by huangcong on 16/4/26.
//  Copyright © 2016年 HuangCong. All rights reserved.
//

#import "HCRankSongModel.h"
#import "HCRankListModel.h"
@implementation HCRankSongModel
+ (NSArray *)mj_allowedPropertyNames
{
    return @[@"title",@"author"];
}
@end
