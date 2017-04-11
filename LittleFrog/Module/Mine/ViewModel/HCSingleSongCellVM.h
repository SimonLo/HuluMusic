//
//  HCSingleSongCellVM.h
//  LittleFrog
//
//  Created by Simon Lo on 2017/4/9.
//  Copyright © 2017年 HuangCong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HCMusicModel.h"
#import "HCSingleSongCell.h"

@interface HCSingleSongCellVM : NSObject

// 原始数据
@property (nonatomic, strong) HCMusicModel *mucicV;

- (void)bindWithCell: (HCSingleSongCell *)cell;

@end
