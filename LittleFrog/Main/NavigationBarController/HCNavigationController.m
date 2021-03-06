//
//  HCNavigationController.m
//  LittleFrog
//
//  Created by huangcong on 16/4/23.
//  Copyright © 2016年 HuangCong. All rights reserved.
//

#import "HCNavigationController.h"
#import "HCMusicIndicator.h"
#import "HCPlayingViewController.h"
@implementation HCNavigationController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setUpMusicIndicator];
}

- (void)setUpMusicIndicator
{
    HCMusicIndicator *indicator = [HCMusicIndicator shareIndicator];
    indicator.hidesWhenStopped = NO;
    indicator.tintColor = HCMainColor;
    if (indicator.state != NAKPlaybackIndicatorViewStatePlaying) {
        indicator.state = NAKPlaybackIndicatorViewStatePaused;
    } else {
        indicator.state = NAKPlaybackIndicatorViewStatePlaying;
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickMusicIndicator)];
    [indicator addGestureRecognizer:tap];
    
    self.navigationItem.rightBarButtonItem = nil;
    [self.navigationBar addSubview:indicator];
}

- (void)clickMusicIndicator
{
    HCPlayingViewController *view = [HCPlayingViewController sharePlayingVC];
    if (!view.currentMusic) {
        [HCPromptTool promptModeText:@"没有正在播放的歌曲" afterDelay:1.0];
        return;
    }
    [self presentViewController:view animated:YES completion:^{
        
    }];
}
- (NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated
{
    HCTintColor = HCRandomColor;
    self.navigationBar.tintColor = HCTintColor;
    [self.navigationBar setBackgroundImage:nil forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    self.tabBarController.tabBar.hidden = NO;
    return [super popToRootViewControllerAnimated:animated];
}
- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    HCTintColor = HCRandomColor;
    self.navigationBar.tintColor = HCTintColor;
    [self.navigationBar setBackgroundImage:nil forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    return [super popViewControllerAnimated:animated];
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    HCTintColor = HCRandomColor;
    viewController.navigationController.navigationBar.barTintColor = HCTintColor;
    if (self.viewControllers.count > 0) {
        
        viewController.tabBarController.tabBar.hidden = YES;
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}
@end
