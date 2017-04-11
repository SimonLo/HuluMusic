//
//  HCPublicHeadView.m
//  LittleFrog
//
//  Created by huangcong on 16/4/27.
//  Copyright © 2016年 HuangCong. All rights reserved.
//

#import "HCPublicHeadView.h"
#import "HCPublicSonglistModel.h"

@interface HCPublicHeadView ()
@property (nonatomic ,weak) UIImageView *picView;
@property (nonatomic ,weak) UILabel *titleLabel;
@property (nonatomic ,weak) UILabel *tagLabel;
@property (nonatomic ,weak) UILabel *publisLable;

@property (nonatomic ,weak) UIButton *collectButton;
@property (nonatomic ,weak) UIButton *shareButton;
@property (nonatomic ,weak) UIButton *likeButton;
@property (nonatomic ,weak) UIButton *MenuButton;

@property (nonatomic ,weak) UILabel *descLabel;
@property (nonatomic ,weak) UIView *descBgView;

@property (nonatomic ,assign) BOOL isFullImage;
@end
@implementation HCPublicHeadView
- (void)setMenuList:(HCPublicSonglistModel *)listModel
{
    if (self.isFullImage) {
    } else {
        [self.picView sd_setImageWithURL:[NSURL URLWithString:listModel.pic_500]];
    }
    self.titleLabel.text = listModel.title;
    self.tagLabel.text = listModel.tag;
    self.publisLable.text = [NSString stringWithFormat:@"%@个听众  %@个粉丝",listModel.listenum,listModel.collectnum];
    self.descLabel.text = listModel.desc;
}
- (void)setNewAlbum:(HCPublicSonglistModel *)albumModel
{
    if (self.isFullImage) {
    } else {
        [self.picView sd_setImageWithURL:[NSURL URLWithString:albumModel.pic_radio]];
    }
    self.titleLabel.text = albumModel.title;
    self.tagLabel.text = albumModel.author;
    self.publisLable.text = [NSString stringWithFormat:@"%@发行",albumModel.publishtime];
    self.descLabel.text = albumModel.info;
}
#pragma mark - setUp
- (instancetype)initWithFullHead:(BOOL)full
{
    if (self = [super init]) {
        self.isFullImage = full;
        [self setUpHeadView];
        [self setUpButtons];
        [self setUpDescLabel];
        self.tintColor = HCTintColor;
    }
    return self;
}

- (void)setUpHeadView
{
    self.picView        = [HCCreatTool imageViewWithView:self];
    
    self.titleLabel     = [HCCreatTool labelWithView:self];
    self.titleLabel.font = HCBigFont;
    self.titleLabel.numberOfLines = 0;
    
    self.tagLabel       = [HCCreatTool labelWithView:self];
 
    self.tagLabel.font = HCMiddleFont;
    
    self.publisLable  = [HCCreatTool labelWithView:self];

    self.publisLable.font = HCMiddleFont;
}
- (void)setUpButtons
{
    self.collectButton  = [HCCreatTool buttonWithView:self image:[[UIImage imageNamed:@"icon_ios_add"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] state:UIControlStateNormal];
    [self.collectButton addTarget:self action:@selector(clickCollectButton) forControlEvents:UIControlEventTouchUpInside];
    
    self.shareButton    = [HCCreatTool buttonWithView:self image:[[UIImage imageNamed:@"icon_ios_export"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] state:UIControlStateNormal];
    [self.shareButton addTarget:self action:@selector(clickShareButton) forControlEvents:UIControlEventTouchUpInside];
    
    self.likeButton     = [HCCreatTool buttonWithView:self image:[[UIImage imageNamed:@"icon_ios_heart"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] state:UIControlStateNormal];
    [self.likeButton setImage:[[UIImage imageNamed:@"icon_ios_heart_filled"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateSelected];
    [self.likeButton addTarget:self action:@selector(clickLikeButton) forControlEvents:UIControlEventTouchUpInside];
    
    self.MenuButton = [HCCreatTool buttonWithView:self image:[[UIImage imageNamed:@"icon_ios_list"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] state:UIControlStateNormal] ;
    [self.MenuButton addTarget:self action:@selector(clickMenuButton) forControlEvents:UIControlEventTouchUpInside];
}
- (void)setUpDescLabel
{
    self.descBgView = [HCCreatTool viewWithView:self];
    if (self.isFullImage == YES) {
        self.descBgView.backgroundColor = [UIColor whiteColor];
    } else {
        self.descBgView.backgroundColor = [UIColor clearColor];
    }
    
    self.descLabel      = [HCCreatTool labelWithView:self];
    self.descLabel.font = HCMiddleFont;
    self.descLabel.numberOfLines = 0;
}
#pragma mark - layout
- (void)layoutSubviews
{
    [self layoutDescLabel];
    [self layoutButtons];
    self.isFullImage ? [self layoutBigImageAndLabel] : [self layoutSmallImageAndLabel];
}
- (void)layoutBigImageAndLabel
{
    self.publisLable.textColor = [UIColor whiteColor];
    self.tagLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textColor = [UIColor whiteColor];
    [self.picView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(HCScreenWidth, HCScreenWidth));
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.mas_top).offset(-0.5 * HCScreenWidth);
    }];
    [self.publisLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(HCHorizontalSpacing);
        make.bottom.equalTo(self.picView.mas_bottom).offset(-1 * HCCommonSpacing);
        make.height.mas_equalTo(20);
    }];
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.publisLable);
        make.bottom.equalTo(self.publisLable.mas_top).offset(-0.5 * HCVerticalSpacing);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.tagLabel.mas_top).offset(-0.5 * HCVerticalSpacing);
        make.left.equalTo(self.mas_left).offset(HCHorizontalSpacing);
        make.right.equalTo(self.mas_right).offset(-HCHorizontalSpacing);
        make.height.mas_equalTo(20);
    }];

}
- (void)layoutSmallImageAndLabel
{
    [self.picView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(HCHorizontalSpacing);
        make.left.equalTo(self.mas_left).offset(HCHorizontalSpacing);
        make.bottom.equalTo(self.descLabel.mas_top).offset(-1 * HCHorizontalSpacing);
        make.width.equalTo(self.picView.mas_height);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.picView.mas_top);
        make.left.equalTo(self.picView.mas_right).offset(HCHorizontalSpacing);
        make.right.equalTo(self.mas_right).offset(-HCHorizontalSpacing);
        make.height.mas_equalTo(40);
    }];
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(HCVerticalSpacing);
        make.left.and.right.equalTo(self.titleLabel);
    }];
    [self.publisLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tagLabel.mas_bottom).offset(HCVerticalSpacing);
        make.left.and.right.equalTo(self.tagLabel);
    }];

}
- (void)layoutButtons
{
    [self.MenuButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.right.equalTo(self.mas_right).offset(-1 * HCHorizontalSpacing);
        make.bottom.equalTo(self.descLabel.mas_top).offset(-1 * HCHorizontalSpacing);
    }];
    
    [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.right.equalTo(self.MenuButton.mas_left).offset(-1 * HCHorizontalSpacing);
        make.bottom.equalTo(self.MenuButton.mas_bottom);
    }];
    
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.right.equalTo(self.likeButton.mas_left).offset(-1 * HCHorizontalSpacing);
        make.bottom.equalTo(self.MenuButton.mas_bottom);
    }];
    
    [self.collectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.right.equalTo(self.shareButton.mas_left).offset(-1 * HCHorizontalSpacing);
        make.bottom.equalTo(self.MenuButton.mas_bottom);
    }];

}
- (void)layoutDescLabel
{
    [self.descBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.bottom.equalTo(self.mas_bottom);
        make.right.equalTo(self.mas_right);
        make.height.mas_offset(65);
    }];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(HCHorizontalSpacing);
        make.bottom.equalTo(self.mas_bottom);
        make.right.equalTo(self.mas_right).offset(-1 * HCHorizontalSpacing);
        make.height.mas_offset(60);
    }];

}
#pragma mark - clickButtons

- (void)clickCollectButton
{
    HCLog(@"clickCollectButton");
    [HCPromptTool promptModeText:@"歌单已添加到播放列表" afterDelay:1.0];
}

- (void)clickShareButton
{
    HCLog(@"clickShareButton");
    [HCPromptTool promptModeText:@"分享功能待完善中" afterDelay:1.0];
}

- (void)clickLikeButton
{
    HCLog(@"clickLikeButton");
    [HCPromptTool promptModeText:@"歌单已收藏" afterDelay:1.0];
}
- (void)clickMenuButton
{
    HCLog(@"clickMenuButton");
    [HCPromptTool promptModeText:@"抱歉，暂无详细信息" afterDelay:1.0];
}
@end
