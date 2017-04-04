//
//  HCPublicSongDetailModel.h
//  LittleFrog
//
//  Created by huangcong on 16/4/23.
//  Copyright © 2016年 HuangCong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HCPublicSongDetailModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *song_id;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *album_title;
@property (nonatomic, copy) NSString *pic_small;
@property (nonatomic, copy) NSString *share;
@property (nonatomic, assign) NSInteger num;
@end
