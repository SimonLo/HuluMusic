//
//  HCModelOperationTool.m
//  HCSQLite
//
//  Created by 王顺子 on 16/11/23.
//  Copyright © 2016年 王顺子. All rights reserved.
//

#import "HCModelOperationTool.h"
#import "HCSqliteTool.h"
#import <objc/message.h>

@implementation HCModelOperationTool


+ (NSDictionary *)changeToSqlTypeFromRuntimeTypeDic {

    return @{
             @"d": @"real",
             @"f": @"real",

             @"i": @"integer",
             @"q": @"integer",
             @"Q": @"integer",
             @"B": @"integer",

             @"NSData": @"blob",
             @"NSDictionary": @"blob",
             @"NSMutableDictionary": @"blob",
             @"NSArray": @"blob",
             @"NSMutableArray": @"blob",

             @"NSString": @"text"
             };

}

+ (BOOL)dropTableWithModelClass: (Class)modelClass withUserID: (NSString *)userID {
    // 1. 获取表名称
    NSString *tableName = NSStringFromClass(modelClass);
    NSString *sql = [NSString stringWithFormat:@"drop table if exists %@", tableName];
    BOOL result = [[HCSqliteTool shareInstance] dealSQL:sql withUserID:userID];
    return result;

}

+ (BOOL)createTableWithModelClass: (Class)modelClass withUserID: (NSString *)userID {


    // 0. 获取表名称
    NSString *tableName = NSStringFromClass(modelClass);
    // 1. 查看表是否存在
    NSString *existsSql = [NSString stringWithFormat:@"select * from sqlite_master where type = 'table' and name = '%@'", tableName];
    NSArray *array = [[HCSqliteTool shareInstance] querySQL:existsSql withUserID:userID];
    if (array.count > 0) {
        return YES;
    }
    // 1.1. 查看是否具备主键
    if (![modelClass instancesRespondToSelector:@selector(primaryKey)]) {
        NSLog(@"没有主键, 无法创建表格, 请实现 - (NSString *)primaryKey; 方法");
        return NO;
    }

    // 2. 表格的所有字段以及字段对应的类型
    // 2.1 获取所有的成员变量
    unsigned int columnCount;
    Ivar *varList = class_copyIvarList(modelClass, &columnCount);



    // 2.2 遍历所有成员变量, 获取成员变量的名称和类型
    NSMutableArray *sqlColumnTypes = [NSMutableArray array];
    for (int i = 0; i < columnCount; i++) {
        // 获取列名称
        NSString *columnName = [[NSString stringWithUTF8String:ivar_getName(varList[i])] substringFromIndex:1];

        // 获取列的类型
        NSString *type = [NSString stringWithUTF8String:ivar_getTypeEncoding(varList[i])];
        NSString *trimType = [type stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"@\""]];
        // 判断具体是什么类型 从而进行转化
        NSString *sqlType = [self changeToSqlTypeFromRuntimeTypeDic][trimType];
//        NSLog(@"%@---%@", columnName, sqlType);


        if ([modelClass instancesRespondToSelector:@selector(ignoreColumn)]) {
            if ([[[modelClass new] ignoreColumn] containsObject:columnName]) {
                continue;
            }
        }

        [sqlColumnTypes addObject:[NSString stringWithFormat:@"%@ %@", columnName, sqlType]];
    }

    // 获取主键
    NSString *sql;
    if ([modelClass instancesRespondToSelector:@selector(primaryKey)]) {
        NSString *primaryKey = [[modelClass new] primaryKey];
        sql = [NSString stringWithFormat:@"create table if not exists %@(%@, primary key(%@))", tableName, [sqlColumnTypes componentsJoinedByString:@","], primaryKey];
    }

    BOOL result = [[HCSqliteTool shareInstance] dealSQL:sql withUserID:userID];
    return result;

}

+ (BOOL)saveModel: (id)model  withUserID: (NSString *)userID {


    // 0. 验证表格是否存在
    if (![self createTableWithModelClass:[model class] withUserID:userID]) {
        return NO;
    }

    // 1. 获取表名称, 主键
    NSString *tableName = NSStringFromClass([model class]);
    NSString *primaryKey = [model primaryKey];


    // 1. 判断是否已经存在该记录, 如果是, 则更新, 如果不是, 则插入
    NSString *hasSql = [NSString stringWithFormat:@"select * from %@ where %@ = '%@'", tableName, primaryKey, [(NSObject *)model valueForKeyPath:primaryKey]];
    NSArray *result = [[HCSqliteTool shareInstance] querySQL:hasSql withUserID:userID];
    if (result.count > 0) {
        // 执行更新操作
        // "update tableName set columnName = 'value',columnName = 'value' where primarykey = 'primaryKeyValue'";
        NSArray *columnNames = [self getColumnNamesAndTypesWithModelClass:[model class]].allKeys;

        NSMutableArray *setValueArray = [NSMutableArray array];
        for (NSString *columnName in columnNames) {

            // 获取value
            id value = [(NSObject *)model valueForKeyPath:columnName];


            if ([value isKindOfClass:[NSDictionary class]] || [value isKindOfClass:[NSArray class]]) {
                NSData *data = [NSJSONSerialization dataWithJSONObject:value options:NSJSONWritingPrettyPrinted error:nil];
                value = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            }

            NSString *str = [NSString stringWithFormat:@"%@ = '%@'", columnName, value];
            [setValueArray addObject:str];

        }

        NSString *updateSql = [NSString stringWithFormat:@"update %@ set %@ where %@ = '%@'", tableName, [setValueArray componentsJoinedByString:@","], primaryKey, [(NSObject *)model valueForKeyPath:primaryKey]];
        return [[HCSqliteTool shareInstance] dealSQL:updateSql withUserID:userID];
        
    }else {
        // 执行插入操作
        // insert into tableName(columnName, columnName) values (value, value)
        NSArray *columnNames = [self getColumnNamesAndTypesWithModelClass:[model class]].allKeys;

        NSMutableArray *valueArray = [NSMutableArray array];
        for (NSString *columnName in columnNames) {

            id value = [(NSObject *)model valueForKeyPath:columnName];

            if ([value isKindOfClass:[NSDictionary class]] || [value isKindOfClass:[NSArray class]]) {
                NSData *data = [NSJSONSerialization dataWithJSONObject:value options:NSJSONWritingPrettyPrinted error:nil];
                value = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            }

            [valueArray addObject:[NSString stringWithFormat:@"'%@'", value]];
        }

        NSString *insertSql = [NSString stringWithFormat:@"insert into %@(%@) values (%@)", tableName, [columnNames componentsJoinedByString:@","], [valueArray componentsJoinedByString:@","]];
        return [[HCSqliteTool shareInstance] dealSQL:insertSql withUserID:userID];
    }



}


+ (BOOL)deleteModel: (id)model  withUserID: (NSString *)userID {



    NSString *primaryKey = [model primaryKey];
    NSString *primaryKeyValue = [(NSObject *)model valueForKey:primaryKey];

    return [self deleteModels:[model class] whereColumnName:primaryKey isValue:primaryKeyValue withUserID:userID];

}

+ (BOOL)deleteModels: (Class)modelClass whereColumnName: (NSString *)column isValue: (id)value  withUserID: (NSString *)userID {
    // 验证是否有主键
    if ([[modelClass new] primaryKey].length == 0) {
        return NO;
    }
    NSString *tableName = NSStringFromClass(modelClass);
    NSString *deleteSql = [NSString stringWithFormat:@"delete from %@ where %@ = '%@'", tableName, column, value];
    return [[HCSqliteTool shareInstance] dealSQL:deleteSql withUserID:userID];


}
+ (BOOL)deleteModels: (Class)modelClass withCondition: (NSString *)whereSQL withUserID: (NSString *)userID{
    // 验证是否有主键
    if ([[modelClass new] primaryKey].length == 0) {
        return NO;
    }
    NSString *tableName = NSStringFromClass(modelClass);

     NSString *deleteSql = [NSString stringWithFormat:@"delete from %@", tableName];
    if (whereSQL.length != 0) {
       deleteSql = [deleteSql stringByAppendingString:[NSString stringWithFormat:@" where %@",  whereSQL]];
    }

    return [[HCSqliteTool shareInstance] dealSQL:deleteSql withUserID:userID];

}

+ (NSArray *)queryModels: (Class)modelClass whereColumnName: (NSString *)column isValue: (id)value  withUserID: (NSString *)userID {

    return [self queryModels:modelClass withCondition:[NSString stringWithFormat:@"%@ = '%@'", column, value] withUserID:userID];

}


+ (NSArray *)queryModels:(Class)modelClass withCondition: (NSString *)condition withUserID: (NSString *)userID {

    // 验证是否有主键
    if ([[modelClass new] primaryKey].length == 0) {
        return nil;
    }
    NSString *tableName = NSStringFromClass(modelClass);

    NSString *querySql = [NSString stringWithFormat:@"select * from %@", tableName];
    if (condition.length != 0) {
        querySql = [querySql stringByAppendingString:[NSString stringWithFormat:@" where %@",  condition]];
    }

    NSArray *rowDicArray = [[HCSqliteTool shareInstance] querySQL:querySql withUserID:userID];



    NSDictionary *dic = [self getColumnNamesAndTypesWithModelClass:modelClass];
    NSMutableArray *models = [NSMutableArray array];
    for (NSDictionary *rowDic in rowDicArray) {
        NSObject *model = [[modelClass alloc] init];
        [models addObject:model];
        [dic enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL * _Nonnull stop) {

            id value = rowDic[key];
            if ([obj isEqualToString:@"NSArray"] || [obj isEqualToString:@"NSMutableArray"] || [obj isEqualToString:@"NSDictionary"] || [obj isEqualToString:@"NSMutableDictionary"]) {

                NSData *data = [(NSString *)rowDic[key] dataUsingEncoding:NSUTF8StringEncoding];
                value = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                if ([obj isEqualToString:@"NSMutableArray"] || [obj isEqualToString:@"NSMutableDictionary"]) {
                    value = [value mutableCopy];
                }
            }
            if (value != nil) {
                [model setValue:value forKeyPath:key];
            }


        }];

    }

    return models;

}


+ (NSArray *)queryModelsWithSql:(NSString *)sql withUserID:(NSString *)userID {

    return [[HCSqliteTool shareInstance] querySQL:sql withUserID:userID];

}


#pragma mark - 私有

+ (NSDictionary <NSString *, NSString *>*)getColumnNamesAndTypesWithModelClass: (Class)modelClass {

    unsigned int columnCount;
    Ivar *varList = class_copyIvarList(modelClass, &columnCount);



    // 2.2 遍历所有成员变量, 获取成员变量的名称和类型
    NSMutableDictionary *sqlColumnNameTypeDic = [NSMutableDictionary dictionary];
    for (int i = 0; i < columnCount; i++) {
        // 获取列名称
        NSString *columnName = [[NSString stringWithUTF8String:ivar_getName(varList[i])] substringFromIndex:1];

        if ([modelClass instancesRespondToSelector:@selector(ignoreColumn)]) {
            if ([[[modelClass new] ignoreColumn] containsObject:columnName]) {
                continue;
            }
        }

        NSString *type = [NSString stringWithUTF8String:ivar_getTypeEncoding(varList[i])];
        NSString *trimType = [type stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"@\""]];


        [sqlColumnNameTypeDic setObject:trimType forKey:columnName];

    }
    return sqlColumnNameTypeDic;
}


@end
