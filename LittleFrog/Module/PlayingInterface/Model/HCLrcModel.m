//
//  HCLrcModel.m
//  LittleFrog
//
//  Created by huangcong on 16/4/24.
//  Copyright © 2016年 HuangCong. All rights reserved.
//

#import "HCLrcModel.h"

@implementation HCLrcModel
- (instancetype)initWithLrcString:(NSString *)lrcString
{
    if (self = [super init]) {
        //以]为界将歌词时间分割
        self.text = [[lrcString componentsSeparatedByString:@"]"] lastObject];
        NSString *timeString = [[[lrcString componentsSeparatedByString:@"]"] firstObject] substringFromIndex:1];
        self.time = [self timeWithString:timeString];
    }
    return self;
}
- (NSTimeInterval)timeWithString:(NSString *)timeString
{
    //将时间分离出来
    NSInteger minute = [[[timeString componentsSeparatedByString:@":"] firstObject] integerValue];
    NSInteger second = [[[[[timeString componentsSeparatedByString:@":"] lastObject] componentsSeparatedByString:@"."] firstObject] integerValue];
    NSInteger millsSecond = [[[[[timeString componentsSeparatedByString:@":"] lastObject] componentsSeparatedByString:@"."] lastObject] integerValue];
    
    return minute * 60 + second + millsSecond * 0.01;
}

+ (instancetype)lrcModelWithLrcString:(NSString *)lrcString
{
    return [[self alloc] initWithLrcString:lrcString];
}
@end
