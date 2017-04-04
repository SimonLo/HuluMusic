//
//  HCLrcTool.h
//  LittleFrog
//
//  Created by huangcong on 16/4/24.
//  Copyright © 2016年 HuangCong. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HCLrcView;
@interface HCLrcTool : NSObject
+ (void)lrcToolDownloadWithUrl:(NSString *)url setUpLrcView:(HCLrcView *)lrcView;
@end
