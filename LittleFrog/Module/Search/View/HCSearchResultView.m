//
//  HCSearchResultView.m
//  LittleFrog
//
//  Created by huangcong on 16/4/28.
//  Copyright © 2016年 HuangCong. All rights reserved.
//

#import "HCSearchResultView.h"
#import "HCSearchInfoModel.h"
#import "HCSearchListModel.h"
#import "HCSearchController.h"
#import "HCSearchReferalView.h"
#import "HCPublicSongDetailModel.h"
#import "HCPublicTableView.h"
#import "HCPlayingViewController.h"

@interface HCSearchResultView ()<UISearchBarDelegate>

@property (nonatomic ,strong) UISearchBar *search;

@property (nonatomic ,copy) NSString *text;
@property (nonatomic ,strong) NSMutableArray *songListArray;
//album artist 只有列表，具体数据待添加
//@property (nonatomic ,strong) NSMutableArray *albumListArray;
//@property (nonatomic ,strong) NSMutableArray *artistListArray;
@property (nonatomic ,strong) NSMutableArray *songIdsArray;

@property (nonatomic ,strong) HCPublicTableView *tableView;

@end
@implementation HCSearchResultView
- (void)setSearchText:(NSString *)text
{
    self.text = text;
//    self.artistListArray = [NSMutableArray array];
//    self.albumListArray = [NSMutableArray array];
    self.songListArray = [NSMutableArray array];
    self.songIdsArray = [NSMutableArray array];
    [self loadSearchResultData:text];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.search.placeholder = self.text;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpSearchBar];
    
    HCPublicTableView *publicTable = [[HCPublicTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    __weak typeof(self) weakSelf = self;
    publicTable.cellClickShowPlayingInterfaceBlock = ^{
        [weakSelf.navigationController presentViewController:[HCPlayingViewController sharePlayingVC] animated:YES completion:nil];
    };
    self.tableView = publicTable;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
}
- (void)setUpSearchBar
{
    self.search = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, HCScreenWidth - 100, 44)];
    self.search.searchBarStyle = UISearchBarStyleProminent;
    self.search.tintColor = HCTintColor;
    self.search.delegate = self;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];//占位
    self.navigationItem.titleView = self.search;
}
- (void)viewDidLayoutSubviews
{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.view);
    }];
}
#pragma mark - searchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [self.search setShowsCancelButton:YES animated:YES];
    for(UIView *view in  [[[searchBar subviews] objectAtIndex:0] subviews]) {
        if([view isKindOfClass:[NSClassFromString(@"UINavigationButton") class]]) {
            UIButton * cancel =(UIButton *)view;
            [cancel setTitle:@"取消" forState:UIControlStateNormal];
            cancel.titleLabel.font = [UIFont systemFontOfSize:14];
        }
    }
    return YES;
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    [self.search resignFirstResponder];
    [self.search setShowsCancelButton:NO animated:YES];
    return YES;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.navigationController popToRootViewControllerAnimated:NO];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self pushToSearchRefferalViewWithText:searchText];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self loadSearchResultData:searchBar.text];
}
#pragma mark - loadSearchResult
- (void)loadSearchResultData:(NSString *)text
{
    [HCNetWorkTool netWorkToolGetWithUrl:HCUrl parameters:HCParams(@"method":@"baidu.ting.search.merge",@"page_size":@"99",@"page_no":@"-1",@"type":@"-1",@"query":text) response:^(id response) {
        HCSearchInfoModel *info = [HCSearchInfoModel mj_objectWithKeyValues:response[@"result"]];
//        HCSearchInfoModel *artist = [HCSearchInfoModel mj_objectWithKeyValues:info.artist_info];
//        self.artistListArray = [artist.artist_list mutableCopy];
//        HCSearchInfoModel *album = [HCSearchInfoModel mj_objectWithKeyValues:info.album_info];
//        self.albumListArray = [album.album_list mutableCopy];
        HCSearchInfoModel *song = [HCSearchInfoModel mj_objectWithKeyValues:info.song_info];
        NSInteger i = 0;
        for (NSDictionary *dict in song.song_list) {
            HCPublicSongDetailModel *detail = [HCPublicSongDetailModel mj_objectWithKeyValues:dict];
            detail.num = ++i;
            [self.songListArray addObject:detail];
            [self.songIdsArray addObject:detail.song_id];
        }
        [self.tableView setSongList:self.songListArray songIds:self.songIdsArray];
    }failure:^(id response) {
        
    }];
}
#pragma mark - changeViewController
- (void)pushToSearchRefferalViewWithText:(NSString *)text
{
    HCSearchReferalView *referralView = [[HCSearchReferalView alloc] init];
    [referralView setSearchText:text];
    [self.navigationController pushViewController:referralView animated:NO];
}
@end
