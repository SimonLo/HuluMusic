//
//  HCNewSongListViewController.m
//  LittleFrog
//
//  Created by huangcong on 16/4/27.
//  Copyright © 2016年 HuangCong. All rights reserved.
//

#import "HCNewSongListViewController.h"
#import "HCPublicTableView.h"
#import "HCPublicHeadView.h"
#import "HCPublicSonglistModel.h"
#import "HCPublicSongDetailModel.h"
#import "HCPlayingViewController.h"

@interface HCNewSongListViewController() {
    BOOL headerFullStyle;
}
@property (nonatomic ,strong) HCPublicTableView *tableView;
@property (nonatomic ,strong) HCPublicHeadView *headView;
@property (nonatomic ,strong) UIImageView *topImageView;

@property (nonatomic ,strong) NSMutableArray *songListArrayM;
@property (nonatomic ,strong) NSMutableArray *songIdsArrayM;

@end
@implementation HCNewSongListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    headerFullStyle = arc4random() % 2 == 1 ? YES : NO;
    if (headerFullStyle) {
        [self setupTopImageView];
    }
    [self setUpTableView];
    self.songListArrayM = [NSMutableArray array];
    self.songIdsArrayM = [NSMutableArray array];
    [self loadSongList];
}
- (void)setUpBackGroundView
{
    UIImageView *backGroundImageView = [[UIImageView alloc] init];
    backGroundImageView.frame = CGRectMake(0,0, HCScreenWidth * 2, 3 * HCScreenHeight);
    [backGroundImageView sd_setImageWithURL:[NSURL URLWithString:self.pic]];
    [HCBlurViewTool blurView:backGroundImageView style:UIBarStyleDefault];
    [self.view insertSubview:backGroundImageView atIndex:0];
}

- (void)setupTopImageView {
    self.topImageView = [HCCreatTool imageViewWithView:self.view];
    self.topImageView.frame = CGRectMake(0, HCNavigationHeight, HCScreenWidth, HCScreenHeight * 0.6);
    [self.view addSubview:self.topImageView];
}

- (void)setUpTableView
{
    self.headView = [[HCPublicHeadView alloc] initWithFullHead:headerFullStyle];
    self.headView.frame = CGRectMake(0, 0, HCScreenWidth, HCScreenWidth * 0.6 + 60);
    
    HCPublicTableView *publicTable = [[HCPublicTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    publicTable.cellTransparency = !headerFullStyle;
    __weak typeof(self) weakSelf = self;
    publicTable.cellClickShowPlayingInterfaceBlock = ^{
        [weakSelf.navigationController presentViewController:[HCPlayingViewController sharePlayingVC] animated:YES completion:nil];
    };
    publicTable.tableViewDidScrollBlock = ^(CGFloat offsetY){
        if (offsetY > -HCNavigationHeight) {
            self.topImageView.y = -offsetY;
        } else {
            if (offsetY < -220) {
                self.topImageView.y = -(offsetY + 220 - HCNavigationHeight);
            } else {
                self.topImageView.y = HCNavigationHeight;
            }
        }
    };
    self.tableView = publicTable;
    self.tableView.tableHeaderView = self.headView;
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HCScreenWidth, HCScreenHeight * 0.5)];
    tableFooterView.backgroundColor = [UIColor whiteColor];
    if (headerFullStyle) {
        self.tableView.contentInset = UIEdgeInsetsMake(HCNavigationHeight, 0, -HCScreenHeight * 0.5, 0);
        self.tableView.tableFooterView = tableFooterView;
    } else {
        self.tableView.contentInset = UIEdgeInsetsZero;
        self.tableView.tableFooterView = [UIView new];
    }
    [self.view addSubview:self.tableView];
}

#pragma mark - loadListData
- (void)loadSongList
{
   [HCNetWorkTool netWorkToolGetWithUrl:HCUrl parameters:HCParams(@"method":@"baidu.ting.album.getAlbumInfo",@"album_id":self.album_id) response:^(id response) {
       HCPublicSonglistModel *songList = [HCPublicSonglistModel mj_objectWithKeyValues:response[@"albumInfo"]];
       [self.topImageView sd_setImageWithURL:[NSURL URLWithString:songList.pic_radio]]; //歌手图片
       [self.headView setNewAlbum:songList];
       NSInteger i = 0;
       for (NSDictionary *dict in response[@"songlist"]) {
           HCPublicSongDetailModel *songDetail = [HCPublicSongDetailModel mj_objectWithKeyValues:dict];
           songDetail.num = ++i;
           [self.songListArrayM addObject:songDetail];
           [self.songIdsArrayM addObject:songDetail.song_id];
       }
       [self.tableView setSongList:self.songListArrayM songIds:self.songIdsArrayM];
       //加毛玻璃背景
       if (!headerFullStyle) {
           [self setUpBackGroundView];
       }
   } failure:^(id response) {
       
   }];
}
@end
