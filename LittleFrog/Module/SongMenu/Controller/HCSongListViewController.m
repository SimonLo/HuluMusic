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

@interface HCSongListViewController() {
    BOOL headerFullStyle;
}
@property (nonatomic ,strong) HCPublicTableView *tableView;
@property (nonatomic ,strong) HCPublicHeadView *headView;
@property (nonatomic ,strong) UIImageView *topImageView;

@property (nonatomic ,strong) NSMutableArray *songListArrayM;
@property (nonatomic ,strong) NSMutableArray *songIdsArrayM;

@end
@implementation HCSongListViewController

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
    self.topImageView.frame = CGRectMake(0, HCNavigationHeight, HCScreenWidth, HCScreenHeight * 0.5);
    [self.view addSubview:self.topImageView];
}

- (void)setUpTableView
{
    self.headView = [[HCPublicHeadView alloc] initWithFullHead:headerFullStyle];
    self.headView.frame = CGRectMake(0, 0, HCScreenWidth, HCScreenWidth * 0.5 + 60);
    
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
            if (offsetY < -210) {
                self.topImageView.y = -(offsetY + 210 - HCNavigationHeight);
            } else {
                self.topImageView.y = HCNavigationHeight;
            }
        }
    };
    self.tableView = publicTable;
    self.tableView.tableHeaderView = self.headView;
    if (headerFullStyle) {
        self.tableView.contentInset = UIEdgeInsetsMake(HCNavigationHeight, 0, 0, 0);
    } else {
        self.tableView.contentInset = UIEdgeInsetsZero;
    }
    [self.view addSubview:self.tableView];
}

#pragma mark - loadData
- (void)loadSongList
{
    [HCNetWorkTool netWorkToolGetWithUrl:HCUrl parameters:HCParams(@"method":@"baidu.ting.diy.gedanInfo",@"listid":self.listid) response:^(id response) {
        HCPublicSonglistModel *songList = [HCPublicSonglistModel mj_objectWithKeyValues:response];
        [self.topImageView sd_setImageWithURL:[NSURL URLWithString:songList.pic_500]]; //歌手图片
        NSInteger i = 0;
        for (NSDictionary *dict in songList.content) {
            HCPublicSongDetailModel *songDetail = [HCPublicSongDetailModel mj_objectWithKeyValues:dict];
            songDetail.num = ++i;
            [self.songListArrayM addObject:songDetail];
            [self.songIdsArrayM addObject:songDetail.song_id];
        }
        [self.headView setMenuList:songList];
        [self.tableView setSongList:self.songListArrayM songIds:self.songIdsArrayM];
        if (!headerFullStyle) {
            [self setUpBackGroundView];
        }
    } failure:^(id response) {
        
    }];
}
@end
