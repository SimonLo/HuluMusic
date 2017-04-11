//
//  HCSingleSongCell.h
//  LittleFrog
//
//  Created by Simon Lo on 2017/4/9.
//  Copyright © 2017年 HuangCong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCSingleSongCell : UITableViewCell

@property (nonatomic,weak) UILabel *titleLable;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
