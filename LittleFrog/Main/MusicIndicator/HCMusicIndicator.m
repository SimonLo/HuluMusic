//
//  HCMusicIndicator.m
//  LittleFrog
//
//  Created by huangcong on 16/4/23.
//  Copyright © 2016年 HuangCong. All rights reserved.
//

#import "HCMusicIndicator.h"

@implementation HCMusicIndicator
static id _indicator;
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _indicator = [super allocWithZone:zone];
    });
    return _indicator;
}

+ (instancetype)shareIndicator
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _indicator = [[self alloc] initWithFrame:CGRectMake(HCScreenWidth - 44, 0, 44, 44)];
    });
    return _indicator;
}
@end
