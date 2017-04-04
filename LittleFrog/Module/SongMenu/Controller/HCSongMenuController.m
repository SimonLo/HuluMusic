//
//  HCSongMenuController.m
//  LittleFrog
//
//  Created by huangcong on 16/4/23.
//  Copyright © 2016年 HuangCong. All rights reserved.
//

#import "HCSongMenuController.h"
#import "HCPublicCollectionCell.h"
#import "HCPublicMusictablesModel.h"
#import "HCSongListViewController.h"
@interface HCSongMenuController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic ,strong) NSMutableArray *songMenuArrayM;
@property (nonatomic ,strong) UICollectionView *songMenuCollectionView;
@property (nonatomic ,assign) NSInteger songMenuPage;
@end

@implementation HCSongMenuController
static NSString *reuseId = @"songMenu";
#pragma mark - setterArray
- (NSMutableArray *)songMenuArrayM
{
    if (!_songMenuArrayM) {
        _songMenuArrayM = [NSMutableArray array];
        self.songMenuPage = 1;
        [self loadSongMenuWithPage:self.songMenuPage array:self.songMenuArrayM reloadView:self.songMenuCollectionView isPullDownRefresh:YES];
    }
    return _songMenuArrayM;
}
#pragma mark - viewAppear - > viewLoad
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.songMenuCollectionView.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpSongMenuCollectionView];
    [self setupRefreshHeader];
    [self setUpRefreshFooter];
}
#pragma mark - setUpCollectionView
- (void)setUpSongMenuCollectionView
{
    CGRect frame = CGRectMake(10, 0, HCScreenWidth - 10, HCScreenHeight);
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.songMenuCollectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
    [self.songMenuCollectionView registerClass:[HCPublicCollectionCell class] forCellWithReuseIdentifier:reuseId];
    self.songMenuCollectionView.delegate = self;
    self.songMenuCollectionView.dataSource = self;
    self.songMenuCollectionView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    [self.view addSubview:self.songMenuCollectionView];
}

- (void)setupRefreshHeader {
    __weak __typeof(self) weakSelf = self;
    self.songMenuCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.songMenuPage = 1;
        [self loadSongMenuWithPage:self.songMenuPage array:weakSelf.songMenuArrayM reloadView:weakSelf.songMenuCollectionView isPullDownRefresh:YES];
    }];
    self.songMenuCollectionView.mj_header.automaticallyChangeAlpha = YES;
}

- (void)setUpRefreshFooter
{
    __weak __typeof(self) weakSelf = self;
    self.songMenuCollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.songMenuPage += 1;
        [self loadSongMenuWithPage:self.songMenuPage array:weakSelf.songMenuArrayM reloadView:weakSelf.songMenuCollectionView isPullDownRefresh:NO];
//        self.songMenuCollectionView.mj_footer.hidden = YES;
    }];
}

#pragma mark - collectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    self.songMenuCollectionView.mj_footer.hidden = self.songMenuArrayM.count == 0;
    return self.songMenuArrayM.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HCPublicMusictablesModel *musicTable = self.songMenuArrayM[indexPath.row];
    HCPublicCollectionCell *collectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseId forIndexPath:indexPath];
    [collectionCell setSongMenu:musicTable];
    return collectionCell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    HCPublicMusictablesModel *tables = self.songMenuArrayM[indexPath.row];
    HCLog(@"---%@",tables.listid);
    HCSongListViewController *listView = [[HCSongListViewController alloc] init];
    listView.listid = tables.listid;
    listView.pic = tables.pic_300;
    [self.navigationController pushViewController:listView animated:YES];
}
#pragma mark - layout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger width = (HCScreenWidth - 10) / 2;
    HCLog(@"%ld",(long)width);
    CGSize size = CGSizeMake(width, width + 40);
    return size;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
#pragma mark - loadData
- (void)loadSongMenuWithPage:(NSInteger)page array:(NSMutableArray *)array reloadView:(UICollectionView *)view
           isPullDownRefresh:(BOOL)isPullDownRefresh {
    __weak __typeof(self) weakSelf = self;
    [HCNetWorkTool netWorkToolGetWithUrl:HCUrl parameters:HCParams(@"method":@"baidu.ting.diy.gedan",@"page_no":[NSString stringWithFormat:@"%zd",page],@"page_size":@"30") response:^(id response)
     {
         if (isPullDownRefresh) {
             [array removeAllObjects];
         }
        for (NSDictionary *dict in response[@"content"]) {
            HCPublicMusictablesModel *tables = [HCPublicMusictablesModel mj_objectWithKeyValues:dict];
            [array addObject:tables];
        }
        [view reloadData];
        [weakSelf.songMenuCollectionView.mj_header endRefreshing];
        [weakSelf.songMenuCollectionView.mj_footer endRefreshing];
    } failure:^(id response) {
        [weakSelf.songMenuCollectionView.mj_header endRefreshing];
        [weakSelf.songMenuCollectionView.mj_footer endRefreshing];
    }];
}



@end
