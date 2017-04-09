//
//  HCPlayingViewController.m
//  LittleFrog
//
//  Created by huangcong on 16/4/24.
//  Copyright © 2016年 HuangCong. All rights reserved.
//

#import "HCPlayingViewController.h"
#import "HCMusicModel.h"
#import "HCLrcView.h"
#import "HCPlayMusicTool.h"
#import "HCLrcTool.h"
#import "HCMusicIndicator.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "HCPublicSongDetailModel.h"
#import <UShareUI/UShareUI.h>

#import "HCSongListContentView.h"

typedef NS_ENUM(NSInteger){
    CycleMode = 0,
    singleModel,
    RandomMode
}playMode;
@interface HCPlayingViewController()<UIScrollViewDelegate>
@property (nonatomic ,weak) UIImageView *backgroundImageView;
@property (nonatomic ,weak) UIImageView *musicImageView;
@property (nonatomic ,weak) UISlider *progressSlider;
@property (nonatomic ,strong) NSTimer *progressTimer;

@property (nonatomic ,weak) HCLrcView *lrcScrollView;

@property (nonatomic ,weak) UIView *buttonsView;
@property (nonatomic ,weak) UILabel *currentTimeLabel;
@property (nonatomic ,weak) UILabel *totalTimeLabel;

@property (nonatomic ,weak) UILabel *songNameLabel;
@property (nonatomic ,weak) UILabel *authorNameLabel;
@property (nonatomic ,weak) UIButton *likeButton;
@property (nonatomic ,weak) UIButton *previousButton;
@property (nonatomic ,weak) UIButton *nextButton;
@property (nonatomic ,weak) UIButton *playOrPauseButton;
@property (nonatomic ,weak) UIButton *backMenuButton;
@property (nonatomic ,weak) UIButton *shareButton;
@property (nonatomic ,weak) UIButton *playModeButton;
@property (nonatomic ,weak) UIButton *downloadButton;
@property (nonatomic ,weak) UIButton *moreChoiceButton;

//播放列表
@property (nonatomic ,weak) UIView *bgCoverView;
@property (nonatomic ,weak) HCSongListContentView *songListView;


@property (nonatomic ,strong) HCLrcView *lrcView;
@property (nonatomic, strong) CADisplayLink *lrcTimer;

@property (nonatomic ,strong) AVPlayerItem *playingItem;

@property (nonatomic ,strong) NSMutableArray *songIdArrayM;
@property (nonatomic ,strong) NSMutableArray *songListArrayM;
@property (nonatomic ,assign) NSInteger playingIndex;

@property (nonatomic ,assign) playMode playMode;
@end
@implementation HCPlayingViewController
static HCMusicIndicator *_indicator;
static void *PlayingModelKVOKey = &PlayingModelKVOKey;
static void *IndicatorStateKVOKey = &IndicatorStateKVOKey;
+ (instancetype)sharePlayingVC
{
    static HCPlayingViewController *_playingVC = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _playingVC = [[HCPlayingViewController alloc] init];
    });
    return _playingVC;
}
#pragma mark - getId

- (void)setSongIdArray:(NSMutableArray *)idArray songListArray:(NSMutableArray *)listArray currentIndex:(NSInteger)index {
    self.songIdArrayM = [idArray mutableCopy];
    self.songListArrayM = [listArray mutableCopy];
    self.playingIndex = index;
    [self loadSongDetail];
    [self setUpKVO];
    
    if (!self.view) {
        [self setUpView];
        [self setUpLrcView];
        [self setUpSlider];
        [self setUpLabelInButtonsView];
        [self setUpButtonInButtonsView];
        [self settingView];
        [self addProgressTimer];
        [self addLrcTimer];
    }
}
#pragma mark - viewLoadAndLayout
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpView];
    [self setUpLrcView];
    [self setUpSlider];
    [self setUpLabelInButtonsView];
    [self setUpButtonInButtonsView];
    [self settingView];
    [self addProgressTimer];
    [self addLrcTimer];
}
- (void)setUpView
{
    self.backgroundImageView = [HCCreatTool imageViewWithView:self.view];
    self.backgroundImageView.frame = self.view.frame;
    [HCBlurViewTool blurView:self.backgroundImageView style:UIBarStyleDefault];
    
    self.musicImageView = [HCCreatTool imageViewWithView:self.view];
    
    self.buttonsView = [HCCreatTool viewWithView:self.view];
}
- (void)setUpLrcView
{
    HCLrcView *scrollView = [[HCLrcView alloc] init];
    scrollView.bounces = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    scrollView.scrollEnabled = YES;
    [self.view addSubview:scrollView];
    self.lrcScrollView = scrollView;
    self.lrcScrollView.contentSize = CGSizeMake(HCScreenWidth * 2 , 0);
}
- (void)setUpSlider
{
    UISlider *slider = [[UISlider alloc] init];
    [slider setMinimumTrackTintColor:HCMainColor];
    [slider setMaximumTrackTintColor:HCTextColor];
    [slider setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateNormal];
    [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slider];
    self.progressSlider = slider;
}
- (void)setUpLabelInButtonsView
{
    self.currentTimeLabel = [HCCreatTool labelWithView:self.buttonsView size:CGSizeMake(40, 20)];
    self.currentTimeLabel.font = HCMiddleFont;
    
    self.totalTimeLabel = [HCCreatTool labelWithView:self.buttonsView size:CGSizeMake(40, 20)];
    self.totalTimeLabel.font = HCMiddleFont;
    
    self.songNameLabel =  [HCCreatTool labelWithView:self.buttonsView size:CGSizeMake(HCScreenWidth - HCHorizontalSpacing, 40)];
    self.songNameLabel.font = HCTitleFont;
    self.songNameLabel.textAlignment = NSTextAlignmentCenter;
    
    self.authorNameLabel = [HCCreatTool labelWithView:self.buttonsView size:CGSizeMake(HCScreenWidth - 2 * HCHorizontalSpacing, 20)];
    self.authorNameLabel.font = HCBigFont;
    self.authorNameLabel.textAlignment = NSTextAlignmentCenter;
}
- (void)setUpButtonInButtonsView
{
    self.likeButton = [HCCreatTool buttonWithView:self.buttonsView image:[UIImage imageNamed:@"icon_ios_heart"] state:UIControlStateNormal size:CGSizeMake(30, 30)];
    [self.likeButton addTarget:self action:@selector(clickLikeButton) forControlEvents:UIControlEventTouchUpInside];
    [self.likeButton setImage:[UIImage imageNamed:@"icon_ios_heart_filled"] forState:UIControlStateSelected];
    
    self.previousButton = [HCCreatTool buttonWithView:self.buttonsView image:[UIImage imageNamed:@"icon_ios_music_backward"] state:UIControlStateNormal size:CGSizeMake(35, 35)];
    [self.previousButton addTarget:self action:@selector(clickPreviousButton) forControlEvents:UIControlEventTouchUpInside];
    
    self.playOrPauseButton = [HCCreatTool buttonWithView:self.buttonsView image:[UIImage imageNamed:@"icon_ios_music_play"] state:UIControlStateNormal size:CGSizeMake(35, 35)];
    [self.playOrPauseButton setImage:[UIImage imageNamed:@"icon_ios_music_pause"] forState:UIControlStateSelected];
    [self.playOrPauseButton addTarget:self action:@selector(clickPlayOrPauseButton) forControlEvents:UIControlEventTouchUpInside];
    
    self.nextButton = [HCCreatTool buttonWithView:self.buttonsView image:[UIImage imageNamed:@"icon_ios_music_forward"] state:UIControlStateNormal size:CGSizeMake(35, 35)];
    [self.nextButton addTarget:self action:@selector(clickNextButton) forControlEvents:UIControlEventTouchUpInside];
    
    self.backMenuButton = [HCCreatTool buttonWithView:self.buttonsView image:[UIImage imageNamed:@"icon_ios_down"] state:UIControlStateNormal size:CGSizeMake(30, 30)];
    [self.backMenuButton addTarget:self action:@selector(clickBackMenuButton) forControlEvents:UIControlEventTouchUpInside];
    
    self.shareButton = [HCCreatTool buttonWithView:self.buttonsView image:[UIImage imageNamed:@"icon_ios_export"] state:UIControlStateNormal size:CGSizeMake(30, 30)];
    [self.shareButton addTarget:self action:@selector(clickShareButton) forControlEvents:UIControlEventTouchUpInside];
    
    self.playModeButton = [HCCreatTool buttonWithView:self.buttonsView image:[UIImage imageNamed:@"icon_ios_replay0"] state:UIControlStateNormal size:CGSizeMake(30, 30)];
    [self.playModeButton addTarget:self action:@selector(playModeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.playModeButton.tag = CycleMode;
    
    self.downloadButton = [HCCreatTool buttonWithView:self.buttonsView image:[UIImage imageNamed:@"cm2_lay_icn_dld"] state:UIControlStateNormal size:CGSizeMake(30, 30)];
    [self.downloadButton addTarget:self action:@selector(clickDownLoadButton) forControlEvents:UIControlEventTouchUpInside];
    
    self.moreChoiceButton = [HCCreatTool buttonWithView:self.buttonsView image:[UIImage imageNamed:@"icon_ios_more_filled"] state:UIControlStateNormal size:CGSizeMake(30, 30)];
    [self.moreChoiceButton addTarget:self action:@selector(clickMoreChoiceButton) forControlEvents:UIControlEventTouchUpInside];
}
- (void)viewDidLayoutSubviews
{
    [self layoutViews];
    [self layoutLabelAndButtons];
}
- (void)layoutViews
{
    [self.musicImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_top);
        make.width.equalTo(self.view.mas_width);
        make.height.equalTo(self.view.mas_width);
    }];
    
    [self.lrcScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_top);
        make.width.equalTo(self.view.mas_width);
        make.height.equalTo(self.view.mas_width);
        
    }];
    
    [self.progressSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(10);
        make.top.equalTo(self.musicImageView.mas_bottom);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.height.mas_equalTo(20);
    }];
    
    [self.buttonsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.progressSlider.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}
- (void)layoutLabelAndButtons
{
    [self.songNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.currentTimeLabel.mas_bottom).offset(HCCommonSpacing);
    }];
    
    [self.authorNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.songNameLabel.mas_bottom).offset(HCVerticalSpacing);
    }];

    [self.buttonsView distributeViewsHorizontallyWith:@[self.currentTimeLabel,self.totalTimeLabel] margin:HCCommonSpacing];
    [self.buttonsView distributeViewsVerticallyWith:@[self.currentTimeLabel,self.likeButton,self.shareButton] margin:HCCommonSpacing];
    [self.buttonsView distributeViewsHorizontallyWith:@[self.likeButton,self.previousButton,self.playOrPauseButton,self.nextButton,self.backMenuButton] margin:HCHorizontalSpacing];
    [self.buttonsView distributeViewsHorizontallyWith:@[self.shareButton,self.playModeButton,self.downloadButton,self.moreChoiceButton] margin:HCHorizontalSpacing];

}

#pragma mark - settingView
- (void)settingView
{
    [self.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:self.currentMusic.songPicRadio] placeholderImage:[UIImage imageNamed:@"lyric-sharing-background-7"]];
    [self.musicImageView sd_setImageWithURL:[NSURL URLWithString:self.currentMusic.songPicRadio] placeholderImage:[UIImage imageNamed:@"lyric-sharing-background-5"]];
    self.songNameLabel.text = self.currentMusic.songName;
    self.authorNameLabel.text = [NSString stringWithFormat:@"%@   %@",self.currentMusic.artistName,self.currentMusic.albumName];
    [HCLrcTool lrcToolDownloadWithUrl:self.currentMusic.lrcLink setUpLrcView:self.lrcScrollView];
    self.playOrPauseButton.selected = YES;
}
#pragma mark - KVO
- (void)setUpKVO
{
    [self addObserver:self forKeyPath:@"currentMusic" options:NSKeyValueObservingOptionNew context:PlayingModelKVOKey];
    [_indicator addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:IndicatorStateKVOKey];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (context == PlayingModelKVOKey) {
        HCLog(@"changeIs%@",[change objectForKey:@"new"]);
        HCMusicModel *new = [change objectForKey:@"new"];
        self.playingItem = [HCPlayMusicTool playMusicWithLink:new.showLink];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playItemAction:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playingItem];
    }
    else if(context == IndicatorStateKVOKey){
        HCLog(@"state");
        [self refreshIndicatorViewState];
    }
}
#pragma mark - musicEnd
- (void)playItemAction:(AVPlayerItem *)item
{
    [self clickNextButton];
}
#pragma mark - timer - lrc
- (void)addProgressTimer
{
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateProgressTimer) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.progressTimer forMode:NSRunLoopCommonModes];
}
- (void)removeProgressTimer
{
    [self.progressTimer invalidate];
    self.progressTimer = nil;
}
- (void)addLrcTimer
{
    self.lrcTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateLrcTimer)];
    [self.lrcTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}
- (void)updateLrcTimer
{
    self.lrcScrollView.currentTime = CMTimeGetSeconds(self.playingItem.currentTime);
}
- (void)removeLrcTimer
{
    [self.lrcTimer invalidate];
    self.lrcTimer = nil;
}
#pragma mark - slider
- (void)updateProgressTimer
{
    self.currentTimeLabel.text = [self setUpTimeStringWithTime:CMTimeGetSeconds(self.playingItem.currentTime)];
    self.totalTimeLabel.text = [self setUpTimeStringWithTime:CMTimeGetSeconds(self.playingItem.duration)];
    HCLog(@"%f",CMTimeGetSeconds(self.playingItem.duration));
    self.progressSlider.value = CMTimeGetSeconds(self.playingItem.currentTime);
    //防止过快的切换歌曲导致duration == nan而崩溃
    if (isnan(CMTimeGetSeconds(self.playingItem.duration))) {
//        self.progressSlider.maximumValue = CMTimeGetSeconds(self.playingItem.currentTime) + 1;
        self.progressSlider.maximumValue = 1;
    }
    else{
        self.progressSlider.maximumValue = CMTimeGetSeconds(self.playingItem.duration);
    }
}

- (void)sliderValueChanged:(UISlider *)slider
{
    if (!_playingItem) {
        return;
    }
    self.playOrPauseButton.selected = YES;
    self.currentTimeLabel.text = [self setUpTimeStringWithTime:slider.value];
    CMTime dragCMtime = CMTimeMake(slider.value, 1);
    [HCPlayMusicTool setUpCurrentPlayingTime:dragCMtime link:self.currentMusic.songLink];
}
//时间转字符串
- (NSString *)setUpTimeStringWithTime:(NSTimeInterval)time
{
    int minute = time / 60;
    int second = (int)time % 60;
    return [NSString stringWithFormat:@"%02d:%02d",minute,second];
}
#pragma mark - clickButtons
- (void)clickLikeButton
{
    HCLog(@"like");
    self.likeButton.selected = !self.likeButton.selected;
    [HCPromptTool promptModeText:(self.likeButton.selected ? @"已添加到喜欢" : @"取消喜欢") afterDelay:1];
}
- (void)clickPreviousButton
{
    HCLog(@"PreviousMusic");
    [self changeMusic:-1];
}

- (void)clickIndicator
{
    [self clickPlayOrPauseButton];
}
- (void)clickPlayOrPauseButton
{
    HCLog(@"PlayorPause");
    if (self.playOrPauseButton.selected) {
        [HCPlayMusicTool pauseMusicWithLink:self.currentMusic.songLink];
    }
    else{
        [HCPlayMusicTool playMusicWithLink:self.currentMusic.songLink];
    }
    self.playOrPauseButton.selected = !self.playOrPauseButton.selected;
    [self refreshIndicatorViewState];
}
- (void)clickNextButton
{
    HCLog(@"NextMusic");
    [self changeMusic:1];
}
- (void)clickBackMenuButton
{
    HCLog(@"BackMenu");
    [self dismissViewControllerAnimated:YES completion:^{
        [self refreshIndicatorViewState];
    }];
}
- (void)clickShareButton
{
    HCLog(@"share");
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        [self shareMusicToPlatformType:platformType withMusic:(HCMusicModel *)self.currentMusic];
        
    }];
}
- (void)playModeButtonClick:(UIButton *)sender {
    self.playModeButton.tag += 1;
    int mode = self.playModeButton.tag % 3;
    NSString *imgName = [NSString stringWithFormat:@"icon_ios_replay%zd",mode];
    [self.playModeButton setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    switch (mode) {
        case CycleMode:
        {
            [HCPromptTool promptModeText:@"顺序播放" afterDelay:1.0];
            self.playMode = CycleMode;
        }
            break;
        case singleModel:
        {
            [HCPromptTool promptModeText:@"单曲循环" afterDelay:1.0];
            self.playMode = singleModel;
        }
            
            break;
        case RandomMode:
        {
            [HCPromptTool promptModeText:@"随机播放" afterDelay:1.0];
            self.playMode = RandomMode;
        }
            
            break;
            
        default:
            break;
    }
}
- (void)clickDownLoadButton
{
    HCLog(@"下载");
    [HCPromptTool promptModeText:@"功能正在完善" afterDelay:1.0];
}

- (void)clickMoreChoiceButton
{
    HCLog(@"MoreChoice");
    [self showSongListContentView];
}

- (void)showSongListContentView {
    self.bgCoverView = [HCCreatTool viewWithView:self.view];
    self.bgCoverView.backgroundColor = [UIColor blackColor];
    self.bgCoverView.alpha = 0;
    self.bgCoverView.frame = self.view.bounds;
    [self.bgCoverView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgViewClicked)]];
    HCSongListContentView *songListView = [[HCSongListContentView alloc] initWithFrame:CGRectMake(0, HCScreenHeight, HCScreenWidth, HCScreenHeight * 0.6)];
    kWeakself;
    songListView.didDeleteSongModelBlock = ^(NSInteger index) {
        //进行模型删除
        HCPublicSongDetailModel *willDeleteModel = [weakSelf.songListArrayM objectAtIndex:index];
        NSLog(@"%@",willDeleteModel.title);
        [weakSelf.songListArrayM removeObjectAtIndex:index];
        [weakSelf.songIdArrayM removeObjectAtIndex:index];
        
        //如果当前播放的歌曲模型被删除，则播放下一首
        if (willDeleteModel.song_id == weakSelf.currentMusic.songId) {
            [weakSelf changeMusic:0];
            weakSelf.songListView.playingIndex = weakSelf.playingIndex;
        } else if (index < weakSelf.playingIndex){
            weakSelf.playingIndex -= 1;
            weakSelf.songListView.playingIndex = weakSelf.playingIndex;
        }
        
    };
    songListView.songListArray = self.songListArrayM;
    songListView.playingIndex = self.playingIndex;
    songListView.backImage = self.musicImageView.image;
    songListView.closeButtonClickBlock = ^{
        [self bgViewClicked];
    };
    
    songListView.didSelectSongBlock = ^(NSInteger index) {
        [self bgViewClicked];
        [self changeToDestinateMusic:index];
    };

    [self.view addSubview:songListView];
    self.songListView = songListView;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.songListView.frame = CGRectMake(0, HCScreenHeight - HCScreenHeight * 0.6, HCScreenWidth, HCScreenHeight * 0.6);
        self.bgCoverView.alpha = 0.3;
    }];
}

//背景view点击
- (void)bgViewClicked {
    [UIView animateWithDuration:0.25 animations:^{
        self.songListView.y = HCScreenHeight;
        self.bgCoverView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.bgCoverView removeFromSuperview];
        [self.songListView removeFromSuperview];
    }];
}

- (void)changeMusic:(NSInteger)variable
{
    [HCPlayMusicTool stopMusicWithLink:self.currentMusic.songLink];
    switch (self.playMode) {
        case CycleMode:
            [self cicyleMusic:variable];
            break;
        case RandomMode:
            [self randomMusic];
            break;
        case singleModel:
            break;
    }
    
    [self resetTimerAndLoadMusic];
}

- (void)changeToDestinateMusic:(NSInteger)index{
    self.playingIndex = index;
    [self resetTimerAndLoadMusic];
}

- (void)resetTimerAndLoadMusic {
    [self removeProgressTimer];
    [self removeLrcTimer];
    [self loadSongDetail];
    [self addProgressTimer];
    [self addLrcTimer];
}

- (void)cicyleMusic:(NSInteger)variable
{   //下一首
    if (variable == 1) {
        if (self.playingIndex == self.songIdArrayM.count - 1) {
            self.playingIndex = 0;
        } else {
            self.playingIndex = variable + self.playingIndex;
        }
    //上一首
    } else if(variable == -1) {
        if (self.playingIndex == 0) {
            self.playingIndex = self.songIdArrayM.count - 1;
        } else {
            self.playingIndex = variable + self.playingIndex;
        }
    } else if(variable == 0) {
        
    }
}
- (void)randomMusic
{
    self.playingIndex = arc4random() % self.songIdArrayM.count;
}
#pragma mark - delegate:refreshCellIndicator
- (void)refreshIndicatorViewState
{
    if ([self.delegate respondsToSelector:@selector(updateIndicatorViewOfVisisbleCells)]) {
        [self.delegate updateIndicatorViewOfVisisbleCells];
        }
}
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //修改透明度
    CGFloat  scale = scrollView.contentOffset.x / scrollView.frame.size.width;
    self.musicImageView.alpha = 1.0- scale;
}
#pragma mark - loadSongDetail
- (void)loadSongDetail
{
    [HCNetWorkTool netWorkToolGetWithUrl:HCMusic parameters:@{@"songIds":self.songIdArrayM[self.playingIndex]} response:^(id response) {
        NSMutableArray *arrayM = response[@"data"][@"songList"];
        HCLog(@"success");
        self.currentMusic = [HCMusicModel mj_objectWithKeyValues:arrayM.firstObject];
        [self settingView];
    } failure:^(id response) {
        
    }];
}

#pragma mark - 设置锁屏信息／后台
- (void)setUpLockInfo
{
    //1.获取当前播放中心
    MPNowPlayingInfoCenter  *center = [MPNowPlayingInfoCenter defaultCenter];
    
    NSMutableDictionary *infos = [NSMutableDictionary dictionary];
    
    infos[MPMediaItemPropertyTitle] = self.currentMusic.songName;
    infos[MPMediaItemPropertyArtist] = self.currentMusic.artistName;
    
    infos[MPMediaItemPropertyArtwork] =  [[MPMediaItemArtwork alloc]initWithImage:[UIImage imageNamed: self.currentMusic.songPicBig]];
    
    infos[MPMediaItemPropertyPlaybackDuration] = @(CMTimeGetSeconds(self.playingItem.duration));
    infos[MPNowPlayingInfoPropertyElapsedPlaybackTime] = @(CMTimeGetSeconds(self.playingItem.duration));
    [center  setNowPlayingInfo:infos];
    
    //设置远程操控
    [[UIApplication sharedApplication]beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    
}

//成为第一响应者
- (BOOL)canBecomeFirstResponder
{
    return YES;
    
}
- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlPlay:
            [self clickPlayOrPauseButton];
            break;
        case UIEventSubtypeRemoteControlPause:
            [self clickPlayOrPauseButton];
            break;
        case UIEventSubtypeRemoteControlStop:
            [HCPlayMusicTool stopMusicWithLink:self.currentMusic.songLink];
            break;
        case UIEventSubtypeRemoteControlNextTrack:
            [self clickNextButton];
            break;
            break;
        case UIEventSubtypeRemoteControlPreviousTrack:
            [self clickPreviousButton];
            break;
        default:
            break;
    }
}

//音乐分享
- (void)shareMusicToPlatformType:(UMSocialPlatformType)platformType withMusic:(HCMusicModel *)musicModel
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建音乐内容对象
//    NSString* thumbURL =  musicModel.songPicRadio; //缩略图
    UIImage *image = self.musicImageView.image;
    UMShareMusicObject *shareObject = [UMShareMusicObject shareObjectWithTitle:musicModel.albumName descr:musicModel.artistName thumImage:image];
    //设置音乐网页播放地址
    shareObject.musicUrl = [NSString stringWithFormat:@"http://music.baidu.com/song/%@",musicModel.songId];
    shareObject.musicDataUrl = musicModel.songLink;
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
        [self alertWithError:error];
    }];
}

//图片拉大
-(UIImage *)imageScale:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if(CGSizeEqualToSize(imageSize, size) == NO){
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if(widthFactor > heightFactor){
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
            
        }else if(widthFactor < heightFactor){
            
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
        
        HCLog(@"scale image fail");
    }  
    UIGraphicsEndImageContext();  
    return newImage;  
}


- (void)alertWithError:(NSError *)error
{
    NSString *result = nil;
    if (!error) {
        result = [NSString stringWithFormat:@"Share succeed"];
    }
    else{
        NSMutableString *str = [NSMutableString string];
        if (error.userInfo) {
            for (NSString *key in error.userInfo) {
                [str appendFormat:@"%@ = %@\n", key, error.userInfo[key]];
            }
        }
        if (error) {
            result = [NSString stringWithFormat:@"Share fail with error code: %d\n%@",(int)error.code, str];
        }
        else{
            result = [NSString stringWithFormat:@"Share fail"];
        }
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"share"
                                                    message:result
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"sure", @"确定")
                                          otherButtonTitles:nil];
    [alert show];
}
     
     
     
     
     









@end
