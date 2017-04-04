//
//  HCSongListContentView.h
//  LittleFrog
//
//  Created by Simon Lo on 2017/4/4.
//  Copyright © 2017年 HuangCong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCSongListContentView : UIView
@property (nonatomic,strong) NSArray *songListArray;
@property (nonatomic,assign) NSInteger playingIndex;

@property (nonatomic,copy) void(^closeButtonClickBlock)(void);
@property (nonatomic,copy) void(^didSelectSongBlock)(NSInteger index);

@end
