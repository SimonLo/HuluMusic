//
//  HCMusicModel.m
//  LittleFrog
//
//  Created by huangcong on 16/4/24.
//  Copyright © 2016年 HuangCong. All rights reserved.
//

#import "HCMusicModel.h"

@implementation HCMusicModel
+ (NSArray *)mj_allowedPropertyNames
{
    return @[@"songName",@"artistName",@"albumName",@"songPicSmall",@"songPicBig",@"songPicRadio",@"songLink",@"lrcLink",@"showLink",@"songId"];
}
@end
