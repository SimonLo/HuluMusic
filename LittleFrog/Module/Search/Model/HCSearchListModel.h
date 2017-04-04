//
//  HCSearchListModel.h
//  LittleFrog
//
//  Created by huangcong on 16/4/28.
//  Copyright © 2016年 HuangCong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HCSearchListModel : NSObject
@property (nonatomic ,copy) NSString *songname;
@property (nonatomic ,copy) NSString *artistname;
@property (nonatomic ,copy) NSString *albumname;

@property (nonatomic ,copy) NSString *song_id;
@property (nonatomic ,copy) NSString *title;
@property (nonatomic ,copy) NSString *author;
@property (nonatomic ,copy) NSString *album_title;
@property (nonatomic ,copy) NSString *pic_small;
@property (nonatomic ,copy) NSString *avatar_middle;
@property (nonatomic ,copy) NSString *artist_id;

@property (nonatomic ,copy) NSString *album_num;
@property (nonatomic ,copy) NSString *song_num;
@property (nonatomic ,copy) NSString *ting_uid;
@property (nonatomic ,copy) NSString *album_id;
@end
