//
//  HCMineViewController.m
//  LittleFrog
//
//  Created by Simon Lo on 2017/4/8.
//  Copyright © 2017年 HuangCong. All rights reserved.
//

#import "HCMineViewController.h"
#import "HCMusicSourceCell.h"
#import "HCMineMusicCell.h"
#import "HCLocalMusicController.h"

@interface HCMineViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,weak) UIImageView *arrowView;
@property (nonatomic,assign) BOOL foldSectionFlag;

@end

static NSString *const musicSourceId = @"musicSourceId";
static NSString *const mineMusicId   = @"mineMusicId";

@implementation HCMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupTableView];
}

- (void)setupTableView{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[HCMusicSourceCell class] forCellReuseIdentifier:musicSourceId];
    [tableView registerClass:[HCMineMusicCell class] forCellReuseIdentifier:mineMusicId];
    
    [self.view addSubview:tableView];
    _tableView = tableView;
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self.view);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }
    
    if (_foldSectionFlag) {
        return 0;
    } else {
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        HCMusicSourceCell *cell = [tableView dequeueReusableCellWithIdentifier:musicSourceId];
        [cell updateCellWithSongCount:@"100" NSIndexPath:indexPath];
        return cell;
    } else {
        HCMineMusicCell *cell = [tableView dequeueReusableCellWithIdentifier:mineMusicId];
        [cell updateCellWithIcon:nil title:nil totalCount:nil downloadCount:nil];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return AdaptedHeight(55);
    }
    return AdaptedHeight(58);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        
        UIView *headerView = [[UIView alloc] init];
        headerView.backgroundColor = HCLightGrayColor;
        headerView.frame = CGRectMake(0, 0, HCScreenWidth, AdaptedHeight(30));
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerViewTapped)];
        tapGesture.numberOfTouchesRequired = 1;
        tapGesture.numberOfTapsRequired = 1;
        [headerView addGestureRecognizer:tapGesture];
        
        UIImageView *arrowView = [[UIImageView alloc] init];
        
        NSString *name = self.foldSectionFlag ? @"icon_arrow" : @"bt_localmusic_arrow_normal";
        arrowView.image = [UIImage imageNamed:name];
        arrowView.frame = CGRectMake(AdaptedWidth(10), 0, AdaptedWidth(12), AdaptedHeight(7));
        arrowView.centerY = headerView.centerY;
        [headerView addSubview:arrowView];
        _arrowView = arrowView;
        
        UILabel *songLable = [[UILabel alloc] init];
        songLable.frame = CGRectMake(AdaptedWidth(30), 0, AdaptedWidth(100), AdaptedHeight(12));
        songLable.centerY = headerView.centerY;
        songLable.font = HCSmallFont;
        songLable.textColor = HCNumColor;
        songLable.text = @"我创建的歌单(3)";
        
        [headerView addSubview:songLable];
        
        return headerView;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self tableView:tableView didDeselectRowAtIndexPath:indexPath];
    if (indexPath.row == 0) {
        HCLocalMusicController *localMusic = [[HCLocalMusicController alloc] init];
        [self.navigationController pushViewController:localMusic animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return AdaptedHeight(30);
    }
    return 0.01;
}

- (void)headerViewTapped {
    _foldSectionFlag = !_foldSectionFlag;
//    NSIndexSet *set = [NSIndexSet indexSetWithIndex:1];
//    [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
