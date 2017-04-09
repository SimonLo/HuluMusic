//
//  HCMineSongController.m
//  LittleFrog
//
//  Created by Simon Lo on 2017/4/8.
//  Copyright © 2017年 HuangCong. All rights reserved.
//

#import "HCMineSongController.h"
#import "HCSingleSongCell.h"

@interface HCMineSongController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,weak) UITableView *tableView;

@end


static NSString *const singleSongID = @"singleSongID";
@implementation HCMineSongController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupTableView];
    
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[HCSingleSongCell class] forCellReuseIdentifier:singleSongID];
    [self.view addSubview:tableView];
    _tableView = tableView;
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self.view);
    }];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HCSingleSongCell *cell = [tableView dequeueReusableCellWithIdentifier:singleSongID];
    cell.textLabel.text = [NSString stringWithFormat:@"%zd",indexPath.row];
    return cell;
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
