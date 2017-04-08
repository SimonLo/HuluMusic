//
//  HCMineMusicCell.h
//  LittleFrog
//
//  Created by Simon Lo on 2017/4/8.
//  Copyright © 2017年 HuangCong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCMineMusicCell : UITableViewCell

- (void)updateCellWithIcon:(NSString *)icon title:(NSString *)title totalCount:(NSString *)total downloadCount:(NSString *)download;

@end
