//
//  HCTabbarController.m
//  LittleFrog
//
//  Created by huangcong on 16/4/23.
//  Copyright © 2016年 HuangCong. All rights reserved.
//

#import "HCTabbarController.h"
#import "HCSongMenuController.h"
#import "HCNewSongController.h"
#import "HCSearchController.h"
#import "HCRankListController.h"
#import "HCNavigationController.h"
@implementation HCTabbarController
- (void)viewDidLoad
{
    [super viewDidLoad];
    HCSongMenuController *songMenu = [[HCSongMenuController alloc] init];
    [self addChildViewController:songMenu WithTitle:@"歌单" image:@"songList_normal" selectedImage:@"songList_highLighted"];
    HCNewSongController *newSong = [[HCNewSongController alloc] init];
    [self addChildViewController:newSong WithTitle:@"新曲" image:@"songNewList_normal" selectedImage:@"songNewList_highLighted"];
    HCSearchController *search = [[HCSearchController alloc] init];
    [self addChildViewController:search WithTitle:@"搜索" image:@"songSearch_normal" selectedImage:@"songSearch_highLighted"];
    HCRankListController *rankList = [[HCRankListController alloc] init];
    [self addChildViewController:rankList WithTitle:@"排行" image:@"songRank_normal" selectedImage:@"songRank_highLighted"];

}

- (void)addChildViewController:(UIViewController *)childVc WithTitle:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    //添加导航控制器
    HCNavigationController *navigation = [[HCNavigationController alloc] initWithRootViewController:childVc];
    childVc.title = title;
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    //将图片原始的样子显示出来，不自动渲染为其它颜色
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    NSMutableDictionary *text = [NSMutableDictionary dictionary];
    //设置文字颜色
    text[NSForegroundColorAttributeName] = HColor(123, 123, 123);
    NSMutableDictionary *selectText = [NSMutableDictionary dictionary];
    selectText[NSForegroundColorAttributeName] = HCMainColor;
    [childVc.tabBarItem setTitleTextAttributes:text forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:selectText forState:UIControlStateSelected];
    [self addChildViewController:navigation];
}

@end
