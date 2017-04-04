//
//  HCLrcModel.h
//  LittleFrog
//
//  Created by huangcong on 16/4/24.
//  Copyright © 2016年 HuangCong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HCLrcModel : NSObject
@property (nonatomic, assign) NSTimeInterval time;
@property (nonatomic, copy) NSString *text;
- (instancetype)initWithLrcString:(NSString *)lrcString;
+ (instancetype)lrcModelWithLrcString:(NSString *)lrcString;
@end
