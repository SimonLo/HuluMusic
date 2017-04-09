//
//  HCLocalMusicController.m
//  LittleFrog
//
//  Created by Simon Lo on 2017/4/8.
//  Copyright © 2017年 HuangCong. All rights reserved.
//

#import "HCLocalMusicController.h"
#import "HCMineSongController.h"
#import "HCMineAuthorController.h"
#import "HCMineAlbumController.h"
#import "HCSementBarVC.h"

@interface HCLocalMusicController ()

@property (nonatomic, weak) HCSementBarVC *segmentBarVC;

@end

@implementation HCLocalMusicController

- (HCSementBarVC *)segmentBarVC {
    if (!_segmentBarVC) {
        HCSementBarVC *segmentBarVC = [[HCSementBarVC alloc] init];
        [self addChildViewController:segmentBarVC];
        _segmentBarVC = segmentBarVC;
    }
    return _segmentBarVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.segmentBarVC.segmentBar.frame = CGRectMake(0, HCNavigationHeight, HCScreenWidth, AdaptedHeight(50));
    [self.view addSubview:self.segmentBarVC.segmentBar];
    
    self.segmentBarVC.view.frame = CGRectMake(0, HCNavigationHeight + AdaptedHeight(50), HCScreenWidth, HCScreenHeight - HCNavigationHeight - AdaptedHeight(50));
    [self.view addSubview:self.segmentBarVC.view];
    
    UIView *separateLine = [[UIView alloc] initWithFrame:CGRectMake(0, HCNavigationHeight + AdaptedHeight(50), HCScreenWidth, 0.5)];
    separateLine.backgroundColor = [UIColor grayColor];
    [self.view addSubview:separateLine];
    
    
    
    
    HCMineSongController *vc1 = [[HCMineSongController alloc] init];
    HCMineAuthorController *vc2 = [[HCMineAuthorController alloc] init];
    HCMineAlbumController *vc3 = [[HCMineAlbumController alloc] init];
    
    [self.segmentBarVC setUpWithItems:@[@"歌曲",@"歌手",@"专辑"] childVCs:@[vc1,vc2,vc3]];
    [self.segmentBarVC.segmentBar updateWithConfig:^(HCSegmentBarConfig *config) {
        config.segmentBarBackColor = [UIColor whiteColor];
    }];
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
