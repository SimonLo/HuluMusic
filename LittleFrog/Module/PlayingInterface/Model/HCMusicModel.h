//
//  HCMusicModel.h
//  LittleFrog
//
//  Created by huangcong on 16/4/24.
//  Copyright © 2016年 HuangCong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HCMusicModel : NSObject
@property (nonatomic ,copy) NSString *songName;
@property (nonatomic ,copy) NSString *artistName;
@property (nonatomic ,copy) NSString *albumName;
@property (nonatomic ,copy) NSString *songPicSmall;
@property (nonatomic ,copy) NSString *songPicBig;
@property (nonatomic ,copy) NSString *songPicRadio;
@property (nonatomic ,copy) NSString *songLink;
@property (nonatomic ,copy) NSString *lrcLink;
//更高品质
@property (nonatomic ,copy) NSString *showLink;
@property (nonatomic ,copy) NSString *songId;
@end
