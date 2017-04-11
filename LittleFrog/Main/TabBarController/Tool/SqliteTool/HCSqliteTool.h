//
//  HCSqliteTool.h
//  HCSQLite
//
//  Created by 王顺子 on 16/11/23.
//  Copyright © 2016年 王顺子. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HCSqliteTool : NSObject

+ (instancetype)shareInstance;

- (BOOL)dealSQL: (NSString *)sql withUserID: (NSString *)userID;

- (NSMutableArray *)querySQL: (NSString *)sql withUserID: (NSString *)userID;

@end
