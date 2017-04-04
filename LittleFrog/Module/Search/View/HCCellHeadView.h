//
//  HCCellHeadView.h
//  LittleFrog
//
//  Created by huangcong on 16/4/28.
//  Copyright © 2016年 HuangCong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HCCellHeadView;
@protocol cellHeadViewDelegate <NSObject>
- (void)clickCellHeadViewButton;
@end
@interface HCCellHeadView : UITableViewHeaderFooterView
@property (nonatomic ,weak) id<cellHeadViewDelegate> delegate;
- (void)setHeadTitle:(NSString *)title button:(NSString *)button;
+ (instancetype)headViewWithTableView:(UITableView *)tableView;
@end
