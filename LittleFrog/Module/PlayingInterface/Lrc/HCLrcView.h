//
//  HCLrcView.h
//  LittleFrog
//
//  Created by huangcong on 16/4/24.
//  Copyright © 2016年 HuangCong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCLrcView : UIScrollView
@property (nonatomic ,assign) NSTimeInterval currentTime;
@property (nonatomic ,strong) NSArray *lrcArray;
@end
