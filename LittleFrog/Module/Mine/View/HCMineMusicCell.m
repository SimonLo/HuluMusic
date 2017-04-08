//
//  HCMineMusicCell.m
//  LittleFrog
//
//  Created by Simon Lo on 2017/4/8.
//  Copyright © 2017年 HuangCong. All rights reserved.
//

#import "HCMineMusicCell.h"

@interface HCMineMusicCell()
@property (nonatomic,weak) UIImageView *iconView;
@property (nonatomic,weak) UILabel *titleLable;
@property (nonatomic,weak) UILabel *subTitle;
@property (nonatomic,weak) UIImageView *checkComplete;
@property (nonatomic,weak) UIView *bottomLine;

@end

@implementation HCMineMusicCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.iconView = [HCCreatTool imageViewWithView:self.contentView];
        self.iconView.image = [UIImage imageNamed:@"cm2_daily_banner3"]; //占位
        
        self.titleLable = [HCCreatTool labelWithView:self.contentView];
        self.titleLable.font = HCBigFont;
        self.titleLable.textColor = HCTextColor;
        
        self.checkComplete = [HCCreatTool imageViewWithView:self.contentView];
        self.checkComplete.image = [UIImage imageNamed:@"bt_collectiondetails_offline_complete"];
        
        self.subTitle = [HCCreatTool labelWithView:self.contentView];
        self.subTitle.font = HCMiddleFont;
        self.subTitle.textColor = HCNumColor;
        
        self.bottomLine = [HCCreatTool viewWithView:self.contentView];
        self.bottomLine.backgroundColor = HCGrayColor;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(AdaptedWidth(3));
        make.centerY.mas_equalTo(self.contentView);
        make.width.height.mas_equalTo(AdaptedHeight(50));
    }];
    
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(AdaptedHeight(10));
        make.left.mas_equalTo(self.iconView.mas_right).offset(AdaptedWidth(5));
        make.right.mas_equalTo(self.contentView).offset(-AdaptedWidth(10));
        make.height.mas_equalTo(AdaptedHeight(15));
    }];
    
    [self.checkComplete mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLable);
        make.bottom.mas_equalTo(self.contentView).offset(-AdaptedHeight(10));
        make.width.height.mas_equalTo(AdaptedHeight(14));
    }];
    
    
    [self.subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.checkComplete.mas_right).offset(2);
        make.bottom.mas_equalTo(self.checkComplete);
        make.width.mas_equalTo(AdaptedWidth(150));
        make.height.mas_equalTo(AdaptedHeight(13));
    }];
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLable);
        make.bottom.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)updateCellWithIcon:(NSString *)icon title:(NSString *)title totalCount:(NSString *)total downloadCount:(NSString *)download {
    self.titleLable.text = @"我喜欢的音乐";
    self.subTitle.text = @"43首,已下载36首";
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
