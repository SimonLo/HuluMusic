//
//  HCPublicCellIconModel.m
//  LittleFrog
//
//  Created by huangcong on 16/4/23.
//  Copyright © 2016年 HuangCong. All rights reserved.
//

#import "HCPublicCellIconModel.h"

@implementation HCPublicCellIconModel
+ (NSArray *)CellMenuItemArray
{
    NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CellMenuItem" ofType:@"plist"]];
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        [arrayM addObject:[HCPublicCellIconModel mj_objectWithKeyValues:dict]];
    }
    return arrayM;
}
@end
