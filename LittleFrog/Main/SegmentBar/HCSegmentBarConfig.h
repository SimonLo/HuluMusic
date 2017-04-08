//
//  HCSegmentBarConfig.h
//  XMGSegmentBar
//
//  Created by 小码哥 on 2016/11/26.
//  Copyright © 2016年 王顺子. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HCSegmentBarConfig : NSObject


+ (instancetype)defaultConfig;

/** 北京颜色 */
@property (nonatomic, strong) UIColor *segmentBarBackColor;


@property (nonatomic, strong) UIColor *itemNormalColor;
@property (nonatomic, strong) UIColor *itemSelectColor;
@property (nonatomic, strong) UIFont *itemFont;

@property (nonatomic, strong) UIColor *indicatorColor;

@property (nonatomic, assign) CGFloat indicatorHeight;
@property (nonatomic, assign) CGFloat indicatorExtraW;



@end
