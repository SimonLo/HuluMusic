//
//  HCSearchController.m
//  LittleFrog
//
//  Created by huangcong on 16/4/23.
//  Copyright © 2016年 HuangCong. All rights reserved.
//

#import "HCSearchController.h"
#import "JCTagListView.h"
#import "HCCellHeadView.h"
#import "HCSearchResultView.h"
#import "HCSearchReferalView.h"
@interface HCSearchController ()<UISearchBarDelegate,cellHeadViewDelegate>
@property (nonatomic ,strong) UISearchBar *search;
@property (nonatomic ,strong) NSMutableArray *hotSearchArray;
@property (nonatomic ,strong) NSArray *historyArray;
@end

@implementation HCSearchController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.hotSearchArray = [NSMutableArray array];
    self.historyArray = [NSArray array];
    [self readUserSearchDefaults];
    [self loadHotSearchData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpSearchBar];
    [self setupTableView];
}

- (void) setupTableView {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)setUpSearchBar
{
    self.search = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, HCScreenWidth - 100, 44)];
    self.search.searchBarStyle = UISearchBarStyleProminent;
    self.search.tintColor = HCMainColor;
    self.search.placeholder = @"请输入要查找的专辑／歌曲／歌手";
    self.search.delegate = self;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];//占位
    self.navigationItem.titleView = self.search;
}

#pragma mark - searchControllerDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    
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
    searchBar.text = nil;
    [searchBar setShowsCancelButton:NO animated:YES];
    return YES;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length) {
        [self pushToSearchRefferalViewWithText:searchText];
    }
}
#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HCCellHeadView *head = [HCCellHeadView headViewWithTableView:tableView];
    if (section == 0) {
        [head setHeadTitle:@"热门搜索" button:@""];
        return head;
    }
    else{
        HCCellHeadView *head = [HCCellHeadView headViewWithTableView:tableView];
        [head setHeadTitle:@"搜索记录" button:@"清空"];
        head.delegate = self;
        return head;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 1 : self.historyArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {//热门
        JCTagListView *cell = [[JCTagListView alloc] initWithFrame:CGRectMake(0, 0, HCScreenWidth, 150)];
        cell.tagCornerRadius = 5.0f;
        cell.canSelectTags = NO;
        [cell.tags addObjectsFromArray:self.hotSearchArray];
        [cell setCompletionBlockWithSelected:^(NSInteger index) {
            HCLog(@"%@",self.hotSearchArray[index]);//点击热门搜索
            [self pushTosearchResultViewWithText:self.hotSearchArray[index]];
        }];
        return cell;
    }
    else{//历史
        static NSString *ID = @"searchCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        cell.imageView.image = [UIImage imageNamed:@"cm2_list_icn_recent"];
        cell.textLabel.text = self.historyArray[indexPath.row];
        cell.textLabel.textColor = [UIColor grayColor];
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 156;
    }
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self pushTosearchResultViewWithText:self.historyArray[indexPath.row]];
}

//滚动时退出键盘
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.search.isFirstResponder) {
        [self.search resignFirstResponder];
    }
}


#pragma mark - cellHeadViewDelegate
- (void)clickCellHeadViewButton
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确认清除所有记录？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *delete = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self deleteSearchHistory];
        self.historyArray = nil;//当前的也清空
        [self.tableView reloadData];
    }];
    [alert addAction:cancel];
    [alert addAction:delete];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - searchHistory
- (void)readUserSearchDefaults
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSArray *array = [user arrayForKey:@"history"];
    self.historyArray = array;
    [self.tableView reloadData];
}
- (void)deleteSearchHistory
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user removeObjectForKey:@"history"];
    [user synchronize];
}

#pragma mark - loadHotSearchData
- (void)loadHotSearchData
{
    [HCNetWorkTool netWorkToolGetWithUrl:HCUrl parameters:HCParams(@"method":@"baidu.ting.search.hot",@"page_num":@"15") response:^(id response) {
        for (NSDictionary *dict in response[@"result"]) {
            [self.hotSearchArray addObject:dict[@"word"]];
        }
        HCLog(@"下载完成");
        [self.tableView reloadData];
    } failure:^(id response) {
    
    }];
}
#pragma mark - changViewController
- (void)pushToSearchRefferalViewWithText:(NSString *)text
{
    HCSearchReferalView *refferral = [[HCSearchReferalView alloc] init];
    [refferral setSearchText:text];
    [self.navigationController pushViewController:refferral animated:NO];
}
- (void)pushTosearchResultViewWithText:(NSString *)text
{
    HCSearchResultView *result = [[HCSearchResultView alloc] init];
    [result setSearchText:text];
    [self.navigationController pushViewController:result animated:NO];
}
@end
