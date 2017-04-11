//
//  GVUserDefaults+HCProperties.m
//  LittleFrog
//
//  Created by Simon Lo on 2017/4/11.
//  Copyright © 2017年 HuangCong. All rights reserved.
//

#import "GVUserDefaults+HCProperties.h"

@implementation GVUserDefaults (HCProperties)
@dynamic firstTimeInPage;

- (NSDictionary *)setupDefaults {
    return @{
             @"firstTimeInPage": @YES
             };
}

@end
