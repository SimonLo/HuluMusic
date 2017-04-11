//
//  HCSqliteTool.m
//  HCSQLite
//
//  Created by 王顺子 on 16/11/23.
//  Copyright © 2016年 王顺子. All rights reserved.
//

#import "HCSqliteTool.h"
#import "sqlite3.h"

#define kCachePath NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject

@interface HCSqliteTool ()
{
    sqlite3 *openDB;
}
@property (nonatomic, copy) NSString *dbPath;

- (void)openDataBaseWithUserID: (NSString *)userID;
- (void)closeDataBase;

@end

@implementation HCSqliteTool

static HCSqliteTool *_shareInstance;
+ (instancetype)shareInstance {
    if (_shareInstance == nil) {
        _shareInstance = [[self alloc] init];
    }
    return _shareInstance;
}


- (void)openDataBaseWithUserID: (NSString *)userID {
    NSString *dbName = @"common.db";
    if (userID.length > 0) {
        dbName = [userID stringByAppendingString:@".db"];
    }

    NSString *dbFullPath = [kCachePath stringByAppendingPathComponent:dbName];

    if (sqlite3_open([dbFullPath UTF8String], &openDB) == SQLITE_OK) {
        NSLog(@"数据库打开成功");
    }else {
        NSLog(@"数据库打开失败");
    }

}
- (void)closeDataBase {
    sqlite3_close(openDB);
}


- (BOOL)dealSQL: (NSString *)sql withUserID: (NSString *)userID {

    [self openDataBaseWithUserID:userID];

    char *errorMsg = nil;
    if (sqlite3_exec(openDB, [sql UTF8String], nil, nil, &errorMsg) == SQLITE_OK) {
        [self closeDataBase];
        return YES;
    }

    [self closeDataBase];

    return NO;
}

- (NSMutableArray *)querySQL: (NSString *)sql withUserID: (NSString *)userID {

    [self openDataBaseWithUserID:userID];

    sqlite3_stmt *ppStmt;
    // 1. 预处理准备语句
    if (sqlite3_prepare_v2(openDB, sql.UTF8String, -1, &ppStmt, nil) != SQLITE_OK) {
        NSLog(@"预处理失败");
        return nil;
    }

    NSMutableArray *rowDicArray = [NSMutableArray array];
    // 2. 执行准备语句
    while (sqlite3_step(ppStmt) == SQLITE_ROW) {

        NSMutableDictionary *rowDic = [NSMutableDictionary dictionary];


        // 遍历这一行的每一列的信息
        // 计算列数
        int columnCount = sqlite3_column_count(ppStmt);
        for (int i = 0; i < columnCount; i ++) {
            // 获取列名称
            const char *columnNameC = sqlite3_column_name(ppStmt, i);
            NSString *columnName = [NSString stringWithUTF8String:columnNameC];

            // 获取列的值
            // 1. 获取每一列对应的类型
            int type = sqlite3_column_type(ppStmt, i);

            // 2. 根据不同的类型, 使用不同的函数获取不同的值
            id value = nil;
            switch (type) {
                case SQLITE_INTEGER:
                    value = @(sqlite3_column_int(ppStmt, i));
                    break;
                case SQLITE_FLOAT:
                    value = @(sqlite3_column_double(ppStmt, i));
                    break;
                case SQLITE_BLOB:
                    value = (__bridge id)(sqlite3_column_blob(ppStmt, i));
                    break;
                case SQLITE_NULL:
                    value = NULL;
                    break;
                case SQLITE_TEXT:
                {
                    const char *valueC = (const char *)sqlite3_column_text(ppStmt, i);
                    value = [NSString stringWithUTF8String:valueC];
                    break;
                }
                default:
                {
                    const char *valueC = (const char *)sqlite3_column_text(ppStmt, i);
                    value = [NSString stringWithUTF8String:valueC];
                    break;
                }
            }

            [rowDic setValue:value forKey:columnName];

        }

        [rowDicArray addObject:rowDic];

    }
    [self closeDataBase];
    
    return rowDicArray;


}

- (NSMutableArray <NSString *>*)getAllColumnNamesWithTableName: (NSString *)tableName userID: (NSString *)userID {
    [self openDataBaseWithUserID:userID];

    NSString *sql = [NSString stringWithFormat:@"select * from %@ limit 1", tableName];
    sqlite3_stmt *ppStmt;
    // 1. 预处理准备语句
    if (sqlite3_prepare_v2(openDB, sql.UTF8String, -1, &ppStmt, nil) != SQLITE_OK) {
        NSLog(@"预处理失败");
        return nil;
    }

    NSMutableArray *rowDicArray = [NSMutableArray array];
    // 2. 执行准备语句
    if(sqlite3_step(ppStmt) == SQLITE_ROW) {

        NSMutableArray *columnNames = [NSMutableArray array];


        // 遍历这一行的每一列的信息
        // 计算列数
        int columnCount = sqlite3_column_count(ppStmt);
        for (int i = 0; i < columnCount; i ++) {
            // 获取列名称
            const char *columnNameC = sqlite3_column_name(ppStmt, i);
            NSString *columnName = [NSString stringWithUTF8String:columnNameC];
            [columnNames addObject:columnName];
        }
        
    }
    [self closeDataBase];
    
    return rowDicArray;
    



}


@end
