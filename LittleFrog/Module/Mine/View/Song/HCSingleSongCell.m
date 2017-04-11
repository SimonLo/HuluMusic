//
//  HCSingleSongCell.m
//  LittleFrog
//
//  Created by Simon Lo on 2017/4/9.
//  Copyright © 2017年 HuangCong. All rights reserved.
//

#import "HCSingleSongCell.h"

@implementation HCSingleSongCell

static NSString *const cellID = @"downLoadMusic";
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    HCSingleSongCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
