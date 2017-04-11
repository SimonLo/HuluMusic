//
//  HCDownLoadBaseListController.h
//  LittleFrog
//
//  Created by Simon Lo on 2017/4/9.
//  Copyright © 2017年 HuangCong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BindBlockType)(id model, UITableViewCell *cell);
typedef UITableViewCell *(^GetCellBlockType)(NSIndexPath *indexPath);
typedef CGFloat(^GetCellHeightType)(NSIndexPath *indexPath);

@interface HCDownLoadBaseListController : UIViewController
@property (nonatomic,weak) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataLists;

// 子控制器需要重写这个方法即可
- (void)setUpWithDataList: (NSMutableArray *)dataLists getCell: (GetCellBlockType)getCellBlock getCellHeight: (GetCellHeightType)getCellHeightBlock andBind: (BindBlockType)bindBlock;

@end
