//
//  HCPublicCollectionCell.m
//  LittleFrog
//
//  Created by huangcong on 16/4/23.
//  Copyright © 2016年 HuangCong. All rights reserved.
//

#import "HCPublicCollectionCell.h"
#import "HCPublicMusictablesModel.h"
@interface HCPublicCollectionCell()
@property (nonatomic ,weak) UIImageView *picView;
@property (nonatomic ,weak) UILabel *titleLabel;
@property (nonatomic ,weak) UILabel *listenumLabel;
@end

@implementation HCPublicCollectionCell
- (void)setSongMenu:(HCPublicMusictablesModel *)menu
{
    [self.picView sd_setImageWithURL:[NSURL URLWithString:menu.pic_300]];
    self.titleLabel.text = menu.title;
    self.listenumLabel.text = [NSString stringWithFormat:@"😊%@",menu.listenum];
}
- (void)setNewSongAlbum:(HCPublicMusictablesModel *)newSong
{
    [self.picView sd_setImageWithURL:[NSURL URLWithString:newSong.pic_big]];
    self.titleLabel.text = [NSString stringWithFormat:@"%@  %@",newSong.author,newSong.title];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.picView = [HCCreatTool imageViewWithView:self.contentView];
        
        self.titleLabel = [HCCreatTool labelWithView:self.contentView];
        self.titleLabel.font = HCBigFont;
        self.titleLabel.textColor = HCTextColor;
        self.titleLabel.numberOfLines = 0;
        
        self.listenumLabel = [HCCreatTool labelWithView:self.contentView];
        self.listenumLabel.font = HCBigFont;
        self.listenumLabel.textColor = [UIColor whiteColor];
    }
    return self;
}

- (void)layoutSubviews
{
    [self.picView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right).offset(-10);
        make.height.equalTo(self.mas_width);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.picView.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.mas_equalTo(40);
    }];
    
    [self.listenumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(10);
        make.left.equalTo(self.mas_left).offset(10);
        make.right.equalTo(self.mas_right);
        make.height.mas_equalTo(15);
    }];
}
@end
