//
//  UIView+distribute.h
//  beginnerPlayer
//
//  Created by huangcong on 16/4/19.
//  Copyright © 2016年 huangcong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (distribute)
- (void)distributeViewsHorizontallyWith:(NSArray *)views margin:(CGFloat)margin;
- (void)distributeViewsVerticallyWith:(NSArray *)views margin:(CGFloat)margin;
- (void)distributeViewsHorizontallyWith:(NSArray *)views;
- (void)distributeViewsVerticallyWith:(NSArray *)views;
@end
