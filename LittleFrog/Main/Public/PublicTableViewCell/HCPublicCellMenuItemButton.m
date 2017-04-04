//
//  HCPublicCellMenuItemButton.m
//  LittleFrog
//
//  Created by huangcong on 16/4/23.
//  Copyright © 2016年 HuangCong. All rights reserved.
//

#import "HCPublicCellMenuItemButton.h"
#import "HCPublicCellIconModel.h"
@implementation HCPublicCellMenuItemButton
- (instancetype)initWithFrame:(CGRect)frame model:(HCPublicCellIconModel *)model
{
    if (self = [super initWithFrame:frame]) {
        [self settingItemButtonWithModel:model];
    }
    return self;
}
- (void)settingItemButtonWithModel:(HCPublicCellIconModel *)model
{
    //图片
    UIImageView *image = [[UIImageView alloc] init];
    image.bounds = CGRectMake(0, 0, 20, 20);
    image.center = CGPointMake(self.frame.size.width/2, 20);
    image.image = [UIImage imageNamed:model.icon];
    [self addSubview:image];
    
    //文案
    UILabel *title = [[UILabel alloc] init];
    title.bounds = CGRectMake(0, 0, self.frame.size.width, 20);
    title.center = CGPointMake(self.frame.size.width/2, self.frame.size.height - title.frame.size.height/2+ 4);
    title.text = model.title;
    title.textAlignment = NSTextAlignmentCenter;
    title.font = HCSmallFont;
    title.textColor = HCMainColor;
    [self addSubview:title];
}
@end
