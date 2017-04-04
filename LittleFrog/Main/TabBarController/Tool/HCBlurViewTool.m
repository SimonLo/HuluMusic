//
//  HCBlurViewTool.m
//  LittleFrog
//
//  Created by huangcong on 16/4/24.
//  Copyright © 2016年 HuangCong. All rights reserved.
//

#import "HCBlurViewTool.h"

@implementation HCBlurViewTool
+ (void)blurView:(UIView *)view style:(UIBarStyle)style
{
    UIToolbar *blurView = [[UIToolbar alloc] init];
    blurView.barStyle = style;
    blurView.frame = view.frame;
    [view addSubview:blurView];
}
@end
