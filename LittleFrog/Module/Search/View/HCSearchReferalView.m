//
//  HCSearchReferalView.m
//  LittleFrog
//
//  Created by huangcong on 16/4/28.
//  Copyright © 2016年 HuangCong. All rights reserved.
//

#import "HCSearchReferalView.h"
#import "HCSearchInfoModel.h"
#import "HCSearchListModel.h"
#import "HCCellHeadView.h"
#import "HCSearchResultView.h"
#import "HCSearchController.h"
@interface HCSearchReferalView ()<UISearchBarDelegate>
@property (nonatomic ,strong) UISearchBar *search;
@property (nonatomic ,strong) NSMutableArray *song;
@property (nonatomic ,strong) NSMutableArray *album;
@property (nonatomic ,strong) NSMutableArray *artist;
@property (nonatomic ,copy) NSString *text;
@end
@implementation HCSearchReferalView
- (void)setSearchText:(NSString *)text
{
    self.text = text;
    self.song = [NSMutableArray array];
    self.album = [NSMutableArray array];
    self.artist = [NSMutableArray array];
    [self loadSearchDataWithText:text];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.search.text = self.text;
    [self.search becomeFirstResponder];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpSearchBar];
    self.tableView.tableFooterView = [UIView new];
}

- (void)setUpSearchBar
{
    self.search = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, HCScreenWidth - 100, 44)];
    self.search.searchBarStyle = UISearchBarStyleProminent;
    self.search.tintColor = HCTintColor;
    self.search.delegate = self;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.titleView = self.search;
    [self.navigationItem setHidesBackButton:YES];
}
#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.song.count > 5 ? 5 : self.song.count;
    }else if(section == 1){
        return self.album.count > 5 ? 5 : self.album.count;
    }else{
        return self.artist.count > 5 ? 5 : self.artist.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"referralCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    cell.textLabel.font = HCBigFont;
    cell.detailTextLabel.font = HCMiddleFont;
    if (self.song.count && indexPath.section == 0) {
        HCSearchListModel *songList = self.song[indexPath.row];
        cell.textLabel.text = songList.songname;
        cell.detailTextLabel.text = songList.artistname;
      }
    else if (self.album.count && indexPath.section == 1){
        HCSearchListModel *album = self.album[indexPath.row];
        cell.textLabel.text = album.albumname;
        cell.detailTextLabel.text = album.artistname;
        }
    else if(self.artist.count && indexPath.section == 2){
        HCSearchListModel *artist = self.artist[indexPath.row];
        cell.textLabel.text = artist.artistname;
        }
        return cell;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HCCellHeadView *head = [HCCellHeadView headViewWithTableView:self.tableView];
    if (section == 0) {
        [head setHeadTitle:@"歌曲" button:@""];
    }
    else if(section == 1){
        [head setHeadTitle:@"专辑" button:@""];
    }
    else{
        [head setHeadTitle:@"歌手" button:@""];
    }
    return head;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return self.song.count ? 30 : 0;
    }
    else if(section == 1){
        return self.album.count ? 30 : 0;
    }
    else{
        return self.artist.count ? 30 : 0;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *text = [NSString string];
    if (indexPath.section == 0) {
        HCSearchListModel *song = self.song[indexPath.row];
        text = song.songname;
    }
    else if (indexPath.section == 1){
        HCSearchListModel *album = self.album[indexPath.row];
        text = album.albumname;
    }
    else{
        HCSearchListModel *artist = self.artist[indexPath.row];
        text = artist.artistname;
    }
    HCLog(@"%@",text);
    [self pushTosearchResultViewWithText:text];
}

//滚动时退出键盘
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.search.isFirstResponder) {
        [self.search resignFirstResponder];
    }
}

#pragma mark - searchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [self.search setShowsCancelButton:YES animated:NO];
    for(UIView *view in  [[[searchBar subviews] objectAtIndex:0] subviews]) {
        if([view isKindOfClass:[NSClassFromString(@"UINavigationButton") class]]) {
            UIButton * cancel =(UIButton *)view;
            [cancel setTitle:@"取消" forState:UIControlStateNormal];
            cancel.titleLabel.font = [UIFont systemFontOfSize:14];
        }
    }
    return YES;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.navigationController popToRootViewControllerAnimated:NO];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self loadSearchDataWithText:searchText];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self addSearchText:searchBar.text];
    [self pushTosearchResultViewWithText:searchBar.text];
}

#pragma mark - 缓存纪录
- (void)addSearchText:(NSString *)text
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSArray *array = [user arrayForKey:@"history"];
    if (!array.count) {//创建一个
        array = [NSArray array];
    }
    NSMutableArray *arrayM = [array mutableCopy];
    __block NSUInteger index = 15;
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *str = obj;
        if ([str isEqualToString:text]) {
            index = idx;
        }
    }];
    if (index != 15) {
        [arrayM removeObjectAtIndex:index];
    }
    [arrayM insertObject:text atIndex:0];
    if (arrayM.count > 15) {//最大缓存15个
        [arrayM removeLastObject];
    }
    [user setObject:arrayM forKey:@"history"];
    [user synchronize];
}

#pragma mark - loadSearchData
- (void)loadSearchDataWithText:(NSString *)text
{
    //将搜索字符转化
//    NSCharacterSet *set = [NSCharacterSet URLFragmentAllowedCharacterSet];
//    NSString *key = [text stringByAddingPercentEncodingWithAllowedCharacters:set];
    
    [HCNetWorkTool netWorkToolGetWithUrl:HCUrl parameters:HCParams(@"method":@"baidu.ting.search.catalogSug",@"query":text) response:^(id response) {
        HCSearchInfoModel *info = [HCSearchInfoModel mj_objectWithKeyValues:response];
        self.song = [info.song mutableCopy];
        self.album = [info.album mutableCopy];
        self.artist = [info.artist mutableCopy];
        [self.tableView reloadData];
    } failure:^(id response) {
        
    }];
}
#pragma mark - changeViewController
- (void)pushTosearchResultViewWithText:(NSString *)text
{
    HCSearchResultView *result = [[HCSearchResultView alloc] init];
    [result setSearchText:text];
    [self.navigationController pushViewController:result animated:NO];
}
@end
