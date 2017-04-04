//
//  HCRankListCell.h
//  LittleFrog
//
//  Created by huangcong on 16/4/26.
//  Copyright © 2016年 HuangCong. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface HCRankListCell : UITableViewCell
@property (nonatomic ,copy) NSString *rankListImage;
+ (instancetype)rankCellWithTableView:(UITableView *)tableView songInfoArray:(NSArray *)info;
@end
