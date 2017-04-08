//
//  HCTableTool.h
//  sqlite的基本封装
//
//  Created by SimonLo on 16/12/5.
//  Copyright © 2016年 SimonLo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HCTableTool : NSObject

/** 判断表格是否存在 */
+ (BOOL)isTableExists: (NSString *)tableName uid: (NSString *)uid;

/** 获取表格里面所有的字段 */
+ (NSArray *)getTableAllColumnNames: (NSString *)tableName uid: (NSString *)uid;

@end
