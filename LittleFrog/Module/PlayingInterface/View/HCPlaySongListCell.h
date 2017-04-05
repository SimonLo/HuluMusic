//
//  HCPlaySongListCell.h
//  LittleFrog
//
//  Created by Simon Lo on 2017/4/5.
//  Copyright © 2017年 HuangCong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCPublicSongDetailModel.h"

@interface HCPlaySongListCell : UITableViewCell

@property (nonatomic,copy)void(^didDeleteSongBlock)(void);

- (void)updateCellWithDetailModel:(HCPublicSongDetailModel *)model isPlaying:(BOOL)isPlaying andTotalSongCount:(NSInteger)count;

@end
