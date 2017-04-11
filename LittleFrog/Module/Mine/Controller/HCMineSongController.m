//
//  HCMineSongController.m
//  LittleFrog
//
//  Created by Simon Lo on 2017/4/8.
//  Copyright © 2017年 HuangCong. All rights reserved.
//

#import "HCMineSongController.h"
#import "HCDownLoadListernDataTool.h"
#import "HCSingleSongCellVM.h"
#import "HCSingleSongCell.h"
#import "HCMusicModel.h"

@implementation HCMineSongController

- (void)reloadCache {
    
    NSArray <HCMusicModel *>*downLoadingMs = [HCDownLoadListernDataTool getDownLoadingMusicMs];
    NSMutableArray <HCSingleSongCellVM *>*downLoadingVMs = [NSMutableArray arrayWithCapacity:downLoadingMs.count];
    for (HCMusicModel *downLoadingM in downLoadingMs) {
        HCSingleSongCellVM *vm = [HCSingleSongCellVM new];
        vm.mucicV = downLoadingM;
        [downLoadingVMs addObject:vm];
    }
    
    
    __weak typeof(self) weakSelf = self;
    [self setUpWithDataList:downLoadingVMs getCell:^UITableViewCell *(NSIndexPath *indexPath) {
        return [HCSingleSongCell cellWithTableView:weakSelf.tableView];
    } getCellHeight:^CGFloat(NSIndexPath *indexPath) {
        return 100;
    } andBind:^(id model, UITableViewCell *cell) {
        HCSingleSongCellVM *vm = (HCSingleSongCellVM *)model;
        HCSingleSongCell *singSongCell = (HCSingleSongCell *)cell;
        [vm bindWithCell:singSongCell];
        
    }];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadCache];
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
