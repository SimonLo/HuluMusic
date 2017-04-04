//
//  HCPlayingViewController.h
//  LittleFrog
//
//  Created by huangcong on 16/4/24.
//  Copyright © 2016年 HuangCong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HCMusicModel;
@protocol playingViewControllerDelegate <NSObject>
@optional
- (void)updateIndicatorViewOfVisisbleCells;
@end
@interface HCPlayingViewController : UIViewController
@property (nonatomic ,weak) id<playingViewControllerDelegate> delegate;
@property (nonatomic ,strong) HCMusicModel *currentMusic;

+ (instancetype)sharePlayingVC;
- (void)setSongIdArray:(NSMutableArray *)idArray songListArray:(NSMutableArray *)listArray currentIndex:(NSInteger)index;
- (void)clickIndicator;
@end
