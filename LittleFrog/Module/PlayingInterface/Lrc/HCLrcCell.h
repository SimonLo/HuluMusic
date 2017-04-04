//
//  HCLrcCell.h
//  LittleFrog
//
//  Created by huangcong on 16/4/24.
//  Copyright © 2016年 HuangCong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HCLrcLabel;
@interface HCLrcCell : UITableViewCell
@property (nonatomic, weak, readonly) HCLrcLabel *lrcLabel;
+ (instancetype)lrcCellWithTableView:(UITableView *)tableView;
@end
