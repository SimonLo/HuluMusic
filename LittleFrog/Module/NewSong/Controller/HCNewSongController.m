//
//  HCNewSongController.m
//  LittleFrog
//
//  Created by huangcong on 16/4/23.
//  Copyright © 2016年 HuangCong. All rights reserved.
//

#import "HCNewSongController.h"
#import "HCPublicCollectionCell.h"
#import "HCPublicMusictablesModel.h"
#import "HCNewSongListViewController.h"

@interface HCNewSongController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic ,strong) NSMutableArray *SongAlbumArrayM;
@property (nonatomic ,strong) UICollectionView *songAlbumCollectionView;
@end
@implementation HCNewSongController
static NSString *reuseId = @"newSong";
- (NSMutableArray *)SongAlbumArrayM
{
    if (!_SongAlbumArrayM) {
        _SongAlbumArrayM = [NSMutableArray array];
        [self loadNewSongData];
    }
    return _SongAlbumArrayM;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.songAlbumCollectionView.backgroundColor = [UIColor whiteColor];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupSongAlbumCollectionView];
    [self setupRefreshHeader];
}

- (void)setupSongAlbumCollectionView {
    CGRect frame = CGRectMake(10, 0, HCScreenWidth - 10, HCScreenHeight);
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.songAlbumCollectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
    [self.songAlbumCollectionView registerClass:[HCPublicCollectionCell class] forCellWithReuseIdentifier:reuseId];
    self.songAlbumCollectionView.delegate = self;
    self.songAlbumCollectionView.dataSource = self;
    self.songAlbumCollectionView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    [self.view addSubview:self.songAlbumCollectionView];
}

- (void)setupRefreshHeader {
    self.songAlbumCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewSongData)];
    self.songAlbumCollectionView.mj_header.automaticallyChangeAlpha = YES;
}

#pragma mark - collectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.SongAlbumArrayM.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HCPublicMusictablesModel *musicTable = self.SongAlbumArrayM[indexPath.row];
    HCPublicCollectionCell *collectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseId forIndexPath:indexPath];
    [collectionCell setNewSongAlbum:musicTable];
    return collectionCell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    HCPublicMusictablesModel *tables = self.SongAlbumArrayM[indexPath.row];
    HCLog(@"---%@",tables.album_id);
    HCNewSongListViewController *listView = [[HCNewSongListViewController alloc] init];
    listView.album_id = tables.album_id;
    listView.pic = tables.pic_big;
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

#pragma mark - load data
- (void)loadNewSongData
{
    [HCNetWorkTool netWorkToolGetWithUrl:HCUrl parameters:HCParams(@"method":@"baidu.ting.plaza.getRecommendAlbum",@"offset":@0,@"limit":@100,@"type":@2) response:^(id response) {
        [self.SongAlbumArrayM removeAllObjects];
        for (NSDictionary *dict in response[@"plaze_album_list"][@"RM"][@"album_list"][@"list"]) {
            HCPublicMusictablesModel *table = [HCPublicMusictablesModel mj_objectWithKeyValues:dict];
            [self.SongAlbumArrayM addObject:table];
        }
        [self.songAlbumCollectionView reloadData];
        [self.songAlbumCollectionView.mj_header endRefreshing];
    } failure:^(id response) {
        [self.songAlbumCollectionView.mj_header endRefreshing];
    }];
}
@end
