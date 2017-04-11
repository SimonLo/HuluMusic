//
//  XMGDownLoadListernDataTool.m
//  XMGDownLoadListern
//
//  Created by 王顺子 on 16/11/23.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "HCDownLoadListernDataTool.h"
#import "HCModelOperationTool.h"

@implementation HCDownLoadListernDataTool

+ (NSArray <HCMusicModel *>*)getDownLoadingMusicMs {

    return [HCModelOperationTool queryModels:[HCMusicModel class] whereColumnName:@"isDownLoaded" isValue:@(NO) withUserID:nil];

}

+ (NSArray <HCMusicModel *>*)getDownLoadedMusicMs {
    return [HCModelOperationTool queryModels:[HCMusicModel class] whereColumnName:@"isDownLoaded" isValue:@(YES) withUserID:nil];
}

@end
