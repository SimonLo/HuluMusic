//
//  HCPlayerQueue.m
//  LittleFrog
//
//  Created by huangcong on 16/4/25.
//  Copyright © 2016年 HuangCong. All rights reserved.
//

#import "HCPlayerQueue.h"

@implementation HCPlayerQueue
static id _playerQueue;
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _playerQueue = [super allocWithZone:zone];
    });
    return _playerQueue;
}

+ (instancetype)sharePlayerQueue
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _playerQueue = [[self alloc] init];
    });
    return _playerQueue;
}
@end
