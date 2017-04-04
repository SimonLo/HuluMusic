//
//  HCPublicSonglistModel.h
//  LittleFrog
//
//  Created by huangcong on 16/4/23.
//  Copyright © 2016年 HuangCong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCPublicSonglistModel : NSObject
@property (nonatomic, copy) NSString *pic_500;
@property (nonatomic, copy) NSString *listenum;
@property (nonatomic, copy) NSString *collectnum;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *tag;
@property (nonatomic, strong) NSArray *content;

@property (nonatomic ,copy) NSString *pic_radio;
@property (nonatomic ,copy) NSString *publishtime;
@property (nonatomic ,copy) NSString *info;
@property (nonatomic ,copy) NSString *author;
@end
