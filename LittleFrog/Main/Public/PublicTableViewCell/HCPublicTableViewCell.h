//
//  HCPublicTableViewCell.h
//  LittleFrog
//
//  Created by huangcong on 16/4/23.
//  Copyright © 2016年 HuangCong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NAKPlaybackIndicatorView.h>
@class HCPublicSongDetailModel,HCPublicTableViewCell;
@protocol PublicTableViewCellDelegate <NSObject>
- (void)clickButton:(UIButton *)button openMenuOfCell:(HCPublicTableViewCell *)cell;
- (void)clickCellMenuItemAtIndex:(NSInteger)index Cell:(HCPublicTableViewCell *)cell;
- (void)clickIndicatorView;
@end
@interface HCPublicTableViewCell : UITableViewCell
@property (nonatomic ,weak) id<PublicTableViewCellDelegate> delegate;
@property (nonatomic ,assign) BOOL isOpenMenu;
@property (nonatomic ,assign) BOOL bePic;
@property (nonatomic ,weak) UIButton *menuButton;
@property (nonatomic, assign) NAKPlaybackIndicatorViewState indicatorViewState;
@property (nonatomic ,weak) HCPublicSongDetailModel *detailModel;
- (void)setUpCellMenu;
+ (instancetype)publicTableViewCellcellWithTableView:(UITableView *)tableView;
@end
