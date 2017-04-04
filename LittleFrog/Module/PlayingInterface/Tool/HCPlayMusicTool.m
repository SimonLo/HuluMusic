//
//  HCPlayMusicTool.m
//  LittleFrog
//
//  Created by huangcong on 16/4/25.
//  Copyright © 2016年 HuangCong. All rights reserved.
//

#import "HCPlayMusicTool.h"
#import <NAKPlaybackIndicatorView.h>
#import <AVFoundation/AVFoundation.h>
#import "HCMusicIndicator.h"

#import "HCPlayerQueue.h"
@interface HCPlayMusicTool()
@end
@implementation HCPlayMusicTool
static HCMusicIndicator *_indicator;
static NSMutableDictionary *_playingMusic;
+ (void)initialize
{
    _playingMusic = [NSMutableDictionary dictionary];
    _indicator = [HCMusicIndicator shareIndicator];
}
+ (void)setUpCurrentPlayingTime:(CMTime)time link:(NSString *)link
{
    AVPlayerItem *playItem = _playingMusic[link];
    HCPlayerQueue *queue = [HCPlayerQueue sharePlayerQueue];
    [playItem seekToTime:time completionHandler:^(BOOL finished) {
        [_playingMusic setObject:playItem forKey:link];
        [queue play];
        _indicator.state = NAKPlaybackIndicatorViewStatePlaying;
    }];
}
+ (AVPlayerItem *)playMusicWithLink:(NSString *)link
{
    HCPlayerQueue *queue = [HCPlayerQueue sharePlayerQueue];
    AVPlayerItem *playItem = _playingMusic[link];
    if (!playItem) {
        playItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:link]];
        [_playingMusic setObject:playItem forKey:link];
        [queue replaceCurrentItemWithPlayerItem:playItem];
    }
    [queue play];
    _indicator.state = NAKPlaybackIndicatorViewStatePlaying;
    return playItem;
}

+ (void)pauseMusicWithLink:(NSString *)link
{
    AVPlayerItem *playItem = _playingMusic[link];
    if (playItem) {
        HCPlayerQueue *queue = [HCPlayerQueue sharePlayerQueue];
        [queue pause];
        _indicator.state = NAKPlaybackIndicatorViewStatePaused;
    }
}

+ (void)stopMusicWithLink:(NSString *)link
{
    AVPlayerItem *playItem = _playingMusic[link];
    if (playItem) {
        HCPlayerQueue *queue = [HCPlayerQueue sharePlayerQueue];
        [_playingMusic removeAllObjects];
        [queue removeItem:playItem];
    }
}
@end
