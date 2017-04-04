//
//  HCSearchInfoModel.m
//  LittleFrog
//
//  Created by huangcong on 16/4/28.
//  Copyright © 2016年 HuangCong. All rights reserved.
//

#import "HCSearchInfoModel.h"

@implementation HCSearchInfoModel
+ (NSArray *)mj_allowedPropertyNames
{
    return @[@"song",@"artist",@"album",@"song_info",@"artist_info",@"album_info",@"song_list",@"album_list",@"artist_list",@"total"];
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"song":@"HCSearchListModel",
             @"artist":@"HCSearchListModel",
             @"album":@"HCSearchListModel",
    
             @"song_list":@"HCSearchListModel",
             @"album_list":@"HCSearchListModel",
             @"artist_list":@"HCSearchListModel"
             };
}
@end
