//
//  HCPlayerQueue.h
//  LittleFrog
//
//  Created by huangcong on 16/4/25.
//  Copyright © 2016年 HuangCong. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface HCPlayerQueue : AVQueuePlayer
+ (instancetype)sharePlayerQueue;
@end
