//
//  HCPublicCellMenuItemButton.h
//  LittleFrog
//
//  Created by huangcong on 16/4/23.
//  Copyright © 2016年 HuangCong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HCPublicCellIconModel;
@interface HCPublicCellMenuItemButton : UIButton
- (instancetype)initWithFrame:(CGRect)frame model:(HCPublicCellIconModel *)iconModel;
@end
