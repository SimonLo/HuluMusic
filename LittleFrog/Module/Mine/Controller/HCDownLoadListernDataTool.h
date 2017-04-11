//
//  XMGDownLoadListernDataTool.h
//  XMGDownLoadListern
//
//  Created by 王顺子 on 16/11/23.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HCMusicModel.h"



@interface HCDownLoadListernDataTool : NSObject

+ (NSArray <HCMusicModel *>*)getDownLoadingMusicMs;

+ (NSArray <HCMusicModel *>*)getDownLoadedMusicMs;

@end
