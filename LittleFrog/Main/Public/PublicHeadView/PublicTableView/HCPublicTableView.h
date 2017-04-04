//
//  HCPublicTableView.h
//  LittleFrog
//
//  Created by huangcong on 16/4/27.
//  Copyright © 2016年 HuangCong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCPublicTableView : UITableView

@property(nonatomic,copy)void(^(cellClickShowPlayingInterfaceBlock))(void);

- (void)setSongList:(NSMutableArray *)list songIds:(NSMutableArray *)ids;

@end
