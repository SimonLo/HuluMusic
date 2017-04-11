//
//  HCModelOperationTool.h
//  HCSQLite
//
//  Created by 王顺子 on 16/11/23.
//  Copyright © 2016年 王顺子. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HCModelOperationToolDelegate <NSObject>

@optional
- (NSArray *)ignoreColumn;

@required
- (NSString *)primaryKey;

@end

@interface HCModelOperationTool : NSObject

+ (BOOL)createTableWithModelClass: (Class)modelClass withUserID: (NSString *)userID;
+ (BOOL)dropTableWithModelClass: (Class)modelClass withUserID: (NSString *)userID;
/**
 根据模型对应的类, 创建表格, 然后插入数据, 如果发现该条数据的主键已经存在, 则执行更新操作

 @param model 模型

 @return 是否保存/更新成功
 */
+ (BOOL)saveModel: (id)model  withUserID: (NSString *)userID;


/**
 根据主键, 删除这个模型

 @param model 模型

 @return 是否操作成功
 */
+ (BOOL)deleteModel: (id)model  withUserID: (NSString *)userID;
+ (BOOL)deleteModels: (Class)modelClass whereColumnName: (NSString *)column isValue: (id)value  withUserID: (NSString *)userID;
+ (BOOL)deleteModels: (Class)modelClass withCondition: (NSString *)whereSQL withUserID: (NSString *)userID;


/**
 查询

 */
+ (NSArray *)queryModels: (Class)modelClass whereColumnName: (NSString *)column isValue: (id)value  withUserID: (NSString *)userID;
+ (NSArray *)queryModels:(Class)modelClass withCondition: (NSString *)condition withUserID: (NSString *)userID;

+ (NSArray *)queryModelsWithSql:(NSString *)sql withUserID:(NSString *)userID;

@end
