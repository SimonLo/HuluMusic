//
//  HCSongListContentView.h
//  LittleFrog
//
//  Created by Simon Lo on 2017/4/4.
//  Copyright © 2017年 HuangCong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCSongListContentView : UIView
@property (nonatomic,strong) NSMutableArray *songListArray;
@property (nonatomic,strong) UIImage *backImage;
@property (nonatomic,assign) NSInteger playingIndex;

@property (nonatomic,copy) void(^closeButtonClickBlock)(void);
@property (nonatomic,copy) void(^didSelectSongBlock)(NSInteger index);
@property (nonatomic,copy) void(^didDeleteSongModelBlock)(NSInteger index);

@end
