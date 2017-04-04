//
//  HCPlayMusicTool.h
//  LittleFrog
//
//  Created by huangcong on 16/4/25.
//  Copyright © 2016年 HuangCong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@class HCPlayerQueue;
@interface HCPlayMusicTool : NSObject

+ (AVPlayerItem *)playMusicWithLink:(NSString *)link;

+ (void)pauseMusicWithLink:(NSString *)link;

+ (void)stopMusicWithLink:(NSString *)link;

+ (void)setUpCurrentPlayingTime:(CMTime)time link:(NSString *)link;
@end
