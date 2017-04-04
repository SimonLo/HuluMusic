//
//  HCRankListModel.h
//  LittleFrog
//
//  Created by huangcong on 16/4/26.
//  Copyright © 2016年 HuangCong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HCRankListModel : NSObject
@property (nonatomic ,copy) NSString *name;
@property (nonatomic ,assign) NSString *type;
@property (nonatomic ,copy) NSString *comment;
@property (nonatomic ,copy) NSString *pic_s444;
@property (nonatomic ,copy) NSString *pic_s260;
@property (nonatomic ,strong) NSArray *content;
@end
