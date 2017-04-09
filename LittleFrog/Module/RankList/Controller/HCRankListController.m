//
//  HCRankListController.m
//  LittleFrog
//
//  Created by huangcong on 16/4/23.
//  Copyright © 2016年 HuangCong. All rights reserved.
//

#import "HCRankListController.h"
#import "HCRankListCell.h"
#import "HCRankListModel.h"
#import "HCRankSongViewController.h"
@interface HCRankListController ()
@property (nonatomic ,strong) NSMutableArray *rankListArray;
@end
@implementation HCRankListController
- (NSMutableArray *)rankListArray
{
    if (!_rankListArray) {
        _rankListArray = [NSMutableArray array];
        [self loadRankData];
    }
    return _rankListArray;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"排行榜";
    [self setupRefreshHeader];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
- (void)setupRefreshHeader {
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadRankData)];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
}

#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.rankListArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HCRankListModel *list = self.rankListArray[indexPath.row];
    HCRankListCell *cell = [HCRankListCell rankCellWithTableView:tableView songInfoArray:list.content];
    cell.rankListImage = list.pic_s260;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger height = HCScreenWidth / 3;
    return height + 2 * HCVerticalSpacing;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HCRankListModel *list = self.rankListArray[indexPath.row];
    HCRankSongViewController *vc = [[HCRankSongViewController alloc] init];
    vc.rankType = list;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - loadData
- (void)loadRankData
{
    [HCNetWorkTool netWorkToolGetWithUrl:HCUrl parameters:HCParams(@"method":@"baidu.ting.billboard.billCategory",@"kflag":@"1") response:^(id response) {
        [self.rankListArray removeAllObjects];
        for (NSDictionary *dict in response[@"content"]) {
            HCRankListModel *rankList = [HCRankListModel mj_objectWithKeyValues:dict];
            [self.rankListArray addObject:rankList];
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    }failure:^(id response) {
        [self.tableView.mj_header endRefreshing];
    }];
}
@end
