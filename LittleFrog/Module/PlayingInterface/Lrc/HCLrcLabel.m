//
//  HCLrcLabel.m
//  LittleFrog
//
//  Created by huangcong on 16/4/24.
//  Copyright © 2016年 HuangCong. All rights reserved.
//

#import "HCLrcLabel.h"

@implementation HCLrcLabel
- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGRect drawRect = CGRectMake(0, 0, self.bounds.size.width * self.progress, self.bounds.size.height);
    [[UIColor redColor] set];
    UIRectFillUsingBlendMode(drawRect, kCGBlendModeSourceIn);
}
@end
