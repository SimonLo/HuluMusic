//
//  HCSearchInfoModel.h
//  LittleFrog
//
//  Created by huangcong on 16/4/28.
//  Copyright © 2016年 HuangCong. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface HCSearchInfoModel : NSObject
@property (nonatomic ,strong) NSArray *song;
@property (nonatomic ,strong) NSArray *album;
@property (nonatomic ,strong) NSArray *artist;

@property (nonatomic ,copy) NSString *total;
@property (nonatomic ,strong) NSArray *song_list;
@property (nonatomic ,strong) NSArray *album_list;
@property (nonatomic ,strong) NSArray *artist_list;
@property (nonatomic ,strong) HCSearchInfoModel *song_info;
@property (nonatomic ,strong) HCSearchInfoModel *artist_info;
@property (nonatomic ,strong) HCSearchInfoModel *album_info;
@end
