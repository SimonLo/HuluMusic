//
//  HCRankSongViewController.m
//  LittleFrog
//
//  Created by huangcong on 16/4/27.
//  Copyright © 2016年 HuangCong. All rights reserved.
//

#import "HCRankSongViewController.h"
#import "HCRankListModel.h"
#import "HCPublicHeadView.h"
#import "HCPublicTableView.h"
#import "HCPublicSongDetailModel.h"
#import "HCPlayingViewController.h"

@interface HCRankSongViewController ()
@property (nonatomic ,weak) UIImageView *backGroundImageView;
@property (nonatomic ,strong) HCPublicTableView *publicTableView;
@property (nonatomic ,strong) NSMutableArray *rankArray;
@property (nonatomic ,strong) NSMutableArray *songIds;
@end
@implementation HCRankSongViewController
- (void)setRankType:(HCRankListModel *)rankType
{
    _rankType = rankType;
    [self loadRankDetail];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.rankArray = [NSMutableArray array];
    self.songIds = [NSMutableArray array];
    [self setUpTableView];
    [self setUpTableViewHeader];
}
- (void)setUpBackgroundView
{
    UIImageView *backGroundImageView = [[UIImageView alloc] init];
    backGroundImageView.frame = CGRectMake(0,-HCScreenHeight, 3 * HCScreenWidth, 3 * HCScreenHeight);
    [backGroundImageView sd_setImageWithURL:[NSURL URLWithString:self.rankType.pic_s444]];
    [HCBlurViewTool blurView:backGroundImageView style:UIBarStyleDefault];
    [self.view insertSubview:backGroundImageView atIndex:0];
}
- (void)setUpTableView
{
    HCPublicTableView *publicTable = [[HCPublicTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    __weak typeof(self) weakSelf = self;
    publicTable.cellClickShowPlayingInterfaceBlock = ^{
        [weakSelf.navigationController presentViewController:[HCPlayingViewController sharePlayingVC] animated:YES completion:nil];
    };
    self.publicTableView = publicTable;
    self.publicTableView.frame = self.view.frame;
    [self.view addSubview:self.publicTableView];
}
- (void)setUpTableViewHeader
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HCScreenWidth, HCScreenWidth * 0.6)];
    UIImageView *image = [[UIImageView alloc] initWithFrame:view.frame];
    [image sd_setImageWithURL:[NSURL URLWithString:self.rankType.pic_s444]];
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(2 * HCCommonSpacing, HCScreenWidth * 0.5, HCScreenWidth, 25)];
    name.textColor = [UIColor whiteColor];
    name.text = [NSString stringWithFormat:@"%@",self.rankType.name];
    [view addSubview:image];
    [view addSubview:name];
    self.publicTableView.tableHeaderView = view;
}
#pragma mark - loadData
- (void)loadRankDetail
{
    [HCNetWorkTool netWorkToolGetWithUrl:HCUrl parameters:HCParams(@"method":@"baidu.ting.billboard.billList",@"offset":@"0",@"size":@"100",@"type":self.rankType.type) response:^(id response) {
        NSInteger i = 0;
        for (NSDictionary *dict in response[@"song_list"]) {
            HCPublicSongDetailModel *songDetail = [HCPublicSongDetailModel mj_objectWithKeyValues:dict];
            songDetail.num = ++i;
            [self.rankArray addObject:songDetail];
            [self.songIds addObject:songDetail.song_id];
        }
        [self.publicTableView setSongList:self.rankArray songIds:self.songIds];
        [self setUpBackgroundView];
    } failure:^(id response) {
        
    }];
}
@end
