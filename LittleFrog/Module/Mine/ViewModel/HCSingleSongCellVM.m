//
//  HCSingleSongCellVM.m
//  LittleFrog
//
//  Created by Simon Lo on 2017/4/9.
//  Copyright © 2017年 HuangCong. All rights reserved.
//

#import "HCSingleSongCellVM.h"
#import "HCSingleSongCell.h"

@interface HCSingleSongCellVM()
@property (nonatomic, weak) HCSingleSongCell *cell;

@end

@implementation HCSingleSongCellVM

- (NSString *)title {
    return self.mucicV.songName;
}

- (void)bindWithCell:(HCSingleSongCell *)cell {
    _cell = cell;
    
    cell.titleLable.text = self.title;
}

@end
