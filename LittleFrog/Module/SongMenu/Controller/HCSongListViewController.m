//
//  HCSongListViewController.m
//  LittleFrog
//
//  Created by huangcong on 16/4/24.
//  Copyright © 2016年 HuangCong. All rights reserved.
//

#import "HCSongListViewController.h"
#import "HCPublicTableView.h"
#import "HCPublicHeadView.h"
#import "HCPublicSonglistModel.h"
#import "HCPublicSongDetailModel.h"
#import "HCPlayingViewController.h"

@interface HCSongListViewController()
@property (nonatomic ,strong) HCPublicTableView *tableView;
@property (nonatomic ,strong) HCPublicHeadView *headView;

@property (nonatomic ,strong) NSMutableArray *songListArrayM;
@property (nonatomic ,strong) NSMutableArray *songIdsArrayM;

@end
@implementation HCSongListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpTableView];
    self.songListArrayM = [NSMutableArray array];
    self.songIdsArrayM = [NSMutableArray array];
    [self loadSongList];
}
- (void)setUpBackGroundView
{
    UIImageView *backGroundImageView = [[UIImageView alloc] init];
    backGroundImageView.frame = CGRectMake(0,-HCScreenHeight, 3 * HCScreenWidth, 3 * HCScreenHeight);
    [backGroundImageView sd_setImageWithURL:[NSURL URLWithString:self.pic]];
    [HCBlurViewTool blurView:backGroundImageView style:UIBarStyleDefault];
    [self.view insertSubview:backGroundImageView atIndex:0];
}
- (void)setUpTableView
{
    self.headView = [[HCPublicHeadView alloc] initWithFullHead:arc4random() % 2];
    self.headView.frame = CGRectMake(0, 0, HCScreenWidth, HCScreenWidth * 0.5 + 60);
     HCPublicTableView *publicTable = [[HCPublicTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    __weak typeof(self) weakSelf = self;
    publicTable.cellClickShowPlayingInterfaceBlock = ^{
        [weakSelf.navigationController presentViewController:[HCPlayingViewController sharePlayingVC] animated:YES completion:nil];
    };
    self.tableView = publicTable;
    self.tableView.tableHeaderView = self.headView;
    [self.view addSubview:self.tableView];
}

#pragma mark - loadData
- (void)loadSongList
{
    [HCNetWorkTool netWorkToolGetWithUrl:HCUrl parameters:HCParams(@"method":@"baidu.ting.diy.gedanInfo",@"listid":self.listid) response:^(id response) {
        HCPublicSonglistModel *songList = [HCPublicSonglistModel mj_objectWithKeyValues:response];
        NSInteger i = 0;
        for (NSDictionary *dict in songList.content) {
            HCPublicSongDetailModel *songDetail = [HCPublicSongDetailModel mj_objectWithKeyValues:dict];
            songDetail.num = ++i;
            [self.songListArrayM addObject:songDetail];
            [self.songIdsArrayM addObject:songDetail.song_id];
        }
        [self.headView setMenuList:songList];
        [self.tableView setSongList:self.songListArrayM songIds:self.songIdsArrayM];
        [self setUpBackGroundView];
    } failure:^(id response) {
        
    }];
}
@end
