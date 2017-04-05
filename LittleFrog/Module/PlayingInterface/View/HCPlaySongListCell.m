//
//  HCPlaySongListCell.m
//  LittleFrog
//
//  Created by Simon Lo on 2017/4/5.
//  Copyright © 2017年 HuangCong. All rights reserved.
//

#import "HCPlaySongListCell.h"

@interface HCPlaySongListCell()

@property (nonatomic,weak) UILabel *songLable;
@property (nonatomic,weak) UILabel *authorLable;
@property (nonatomic,weak) UIButton *deleteBtn;
@property (nonatomic,weak) UIImageView *deleteImage;

@end



@implementation HCPlaySongListCell

- (void)updateCellWithDetailModel:(HCPublicSongDetailModel *)model isPlaying:(BOOL)isPlaying andTotalSongCount:(NSInteger)count {
    self.songLable.text = model.title;
    self.authorLable.text = [NSString stringWithFormat:@" - %@",model.author];
    self.deleteBtn.hidden = count == 1;
    if (isPlaying) {
        self.songLable.textColor = HColor(245, 56, 90);
        self.authorLable.textColor = HColor(245, 56, 90);
    } else {
        self.songLable.textColor = HCTextColor;
        self.authorLable.textColor = [UIColor grayColor];
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.songLable = [HCCreatTool labelWithView:self.contentView];
        self.songLable.font = HCBigFont;
        self.songLable.textColor = HCTextColor;
        
        self.authorLable = [HCCreatTool labelWithView:self.contentView];
        self.authorLable.textAlignment = NSTextAlignmentLeft;
        self.authorLable.font = HCSmallFont;
        self.authorLable.textColor = HCTextColor;
        
        self.deleteBtn = [HCCreatTool buttonWithView:self.contentView image:[UIImage imageNamed:@""] state:UIControlStateNormal];
        [self.deleteBtn addTarget:self action:@selector(deleteSongClick) forControlEvents:UIControlEventTouchUpInside];
        self.deleteImage = [HCCreatTool imageViewWithView:self.deleteBtn];
        self.deleteImage.image = [UIImage imageNamed:@"bt_music_delete"];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.mas_equalTo(self.contentView);
        make.width.mas_equalTo(50);
    }];
    
    [self.deleteImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.deleteBtn);
        make.centerX.mas_equalTo(self.deleteBtn);
        make.width.height.mas_equalTo(30);
    }];
    
    [self.authorLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.deleteBtn.mas_left).offset(-10);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_equalTo(10);
    }];
    
    [self.songLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.authorLable.mas_left);
        make.height.mas_equalTo(15);
    }];
}

//删除歌曲
- (void)deleteSongClick {
    if (self.didDeleteSongBlock) {
        self.didDeleteSongBlock();
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
