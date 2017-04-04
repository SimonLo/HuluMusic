//
//  HCPublicTableView.m
//  LittleFrog
//
//  Created by huangcong on 16/4/27.
//  Copyright © 2016年 HuangCong. All rights reserved.
//

#import "HCPublicTableView.h"
#import "HCPublicTableViewCell.h"
#import "HCPlayingViewController.h"
#import "HCMusicIndicator.h"
#import <NAKPlaybackIndicatorView.h>
#import "HCMusicModel.h"
#import "HCPublicSongDetailModel.h"
#import "HCPublicSonglistModel.h"

typedef NS_ENUM(NSInteger) {
    FavoriteItem = 0,
    AlbumItem,
    DownLoadItem,
    SingerOperation,
    DeleteItem
}item;

@interface HCPublicTableView ()<UITableViewDelegate,UITableViewDataSource,PublicTableViewCellDelegate,playingViewControllerDelegate>
@property (nonatomic ,weak) HCPublicTableViewCell *isOpenCell;
@property (nonatomic ,assign) NSIndexPath *opendCellIndex;
@property (nonatomic ,assign) BOOL isOpen;

@property (nonatomic ,strong) NSMutableArray *songListArrayM;
@property (nonatomic ,strong) NSMutableArray *songIdsArrayM;
@end
@implementation HCPublicTableView
- (void)setSongList:(NSMutableArray *)list songIds:(NSMutableArray *)ids
{
    self.songListArrayM = list;
    self.songIdsArrayM = ids;
    [self reloadData];
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style]) {
        self.backgroundColor = [UIColor clearColor];
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor clearColor];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.contentInset = UIEdgeInsetsMake(0, 0, -45, 0);
        self.scrollIndicatorInsets = self.contentInset;
        self.bounces = YES;
    }
    return self;
}

#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    HCLog(@"%ld",self.songListArrayM.count);
    return self.songListArrayM.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HCPublicSongDetailModel *songDetail = self.songListArrayM[indexPath.row];
    HCPublicTableViewCell *cell = [HCPublicTableViewCell publicTableViewCellcellWithTableView:tableView];
    cell.backgroundColor = [UIColor clearColor];
    cell.bePic = songDetail.pic_small ? YES : NO;
    cell.menuButton.tag = indexPath.row;
    cell.detailModel = songDetail;
    cell.delegate = self;
    [self updateIndicatorViewOfCell:cell];
    [cell setUpCellMenu];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.isOpen = self.isOpenCell && self.isOpenCell.isOpenMenu && (self.opendCellIndex.row == indexPath.row);
    if (self.isOpen) {
        return 110;
    }
    else{
        return 55;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.row;
    HCPublicSongDetailModel *currentModel = self.songListArrayM[index];
    HCPlayingViewController *viewController = [HCPlayingViewController sharePlayingVC];
    if (viewController.currentMusic.songId != currentModel.song_id) { //切换了歌曲
        viewController.delegate = self;
        [viewController setSongIdArray:self.songIdsArrayM songListArray:self.songListArrayM currentIndex:index];
    } else { //重复点击歌曲
        if (self.cellClickShowPlayingInterfaceBlock) {
            self.cellClickShowPlayingInterfaceBlock();
        }
    }
    [self updateIndicatorViewWithIndexPath:indexPath];
}

#pragma mark - cellDelegate
- (void)clickButton:(UIButton *)button openMenuOfCell:(HCPublicTableViewCell *)cell
{
    NSIndexPath *openIndex = [NSIndexPath indexPathForRow:button.tag inSection:0];
    if (self.isOpen) {
        self.isOpenCell = nil;//close
        [self reloadRowsAtIndexPaths:@[self.opendCellIndex] withRowAnimation:UITableViewRowAnimationFade];//refresh cell
        self.opendCellIndex = nil;
    }
    else{
        self.isOpenCell = cell;
        self.opendCellIndex = openIndex;
        [self reloadRowsAtIndexPaths:@[self.opendCellIndex] withRowAnimation:UITableViewRowAnimationFade];
        [self scrollToRowAtIndexPath:self.opendCellIndex atScrollPosition:UITableViewScrollPositionNone animated:YES];
    }
}
- (void)clickCellMenuItemAtIndex:(NSInteger)index Cell:(HCPublicTableViewCell *)cell
{
    // 点击后自动关闭
    self.isOpenCell = nil;
    [self reloadRowsAtIndexPaths:@[self.opendCellIndex] withRowAnimation:UITableViewRowAnimationFade];
    self.opendCellIndex = nil;
    
    switch (index) {
        case FavoriteItem:
            HCLog(@"点击了收藏");
            [HCPromptTool promptModeText:@"已收藏" afterDelay:1];
            break;
        case AlbumItem:
            HCLog(@"点击了专辑");
            [HCPromptTool promptModeText:@"暂无专辑信息" afterDelay:1];
            break;
        case DownLoadItem:
            HCLog(@"点击了下载");
            [HCPromptTool promptModeText:@"暂时无法下载" afterDelay:1];
            break;
        case SingerOperation:
            HCLog(@"点击了歌手");
            [HCPromptTool promptModeText:@"暂无歌手信息" afterDelay:1];
            break;
        case DeleteItem:
            HCLog(@"点击了删除");
            [HCPromptTool promptModeText:@"无法删除网络资源" afterDelay:1];
            break;
    }
}
- (void)clickIndicatorView
{
    [[HCPlayingViewController sharePlayingVC] clickIndicator];
}

#pragma mark - update indicatorView state
- (void)updateIndicatorViewWithIndexPath:(NSIndexPath *)indexPath {
    for (HCPublicTableViewCell *cell in self.visibleCells) {
        cell.indicatorViewState = NAKPlaybackIndicatorViewStateStopped;
    }
    HCPublicTableViewCell *musicsCell = [self cellForRowAtIndexPath:indexPath];
    musicsCell.indicatorViewState = NAKPlaybackIndicatorViewStatePlaying;
}
- (void)updateIndicatorViewOfCell:(HCPublicTableViewCell *)cell {
    HCPublicSongDetailModel *detail = cell.detailModel;
    if (detail.song_id == [HCPlayingViewController  sharePlayingVC].currentMusic.songId) {
        cell.indicatorViewState = [HCMusicIndicator shareIndicator].state;
    } else {
        cell.indicatorViewState = NAKPlaybackIndicatorViewStateStopped;
    }
}
#pragma mark - playingViewControllerDelegate
- (void)updateIndicatorViewOfVisisbleCells {
    for (HCPublicTableViewCell *cell in self.visibleCells) {
        [self updateIndicatorViewOfCell:cell];
    }
}
@end
