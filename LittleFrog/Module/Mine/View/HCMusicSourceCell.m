//
//  HCMusicSourceCell.m
//  LittleFrog
//
//  Created by Simon Lo on 2017/4/8.
//  Copyright © 2017年 HuangCong. All rights reserved.
//

#import "HCMusicSourceCell.h"

@interface HCMusicSourceCell()

@property (nonatomic,weak) UIImageView *iconView;
@property (nonatomic,weak) UILabel *titleLable;
@property (nonatomic,weak) UILabel *countLable;
@property (nonatomic,weak) UIImageView *moreIndocator;
@property (nonatomic,weak) UIView *bottomLine;


@end

@implementation HCMusicSourceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.iconView = [HCCreatTool imageViewWithView:self.contentView];
        self.iconView.image = [UIImage imageNamed:@"songList_highLighted"];
        
        self.titleLable = [HCCreatTool labelWithView:self.contentView];
        self.titleLable.font = HCBigFont;
        self.titleLable.textColor = HCTextColor;
        
        self.countLable = [HCCreatTool labelWithView:self.contentView];
        self.countLable.font = HCMiddleFont;
        self.countLable.textColor = HCGrayColor;
        self.countLable.textAlignment = NSTextAlignmentRight;
        
        self.moreIndocator = [HCCreatTool imageViewWithView:self.contentView];
        self.moreIndocator.image = [UIImage imageNamed:@"more"];
        
        self.bottomLine = [HCCreatTool viewWithView:self.contentView];
        self.bottomLine.backgroundColor = HCGrayColor;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(15);
        make.centerY.mas_equalTo(self.contentView);
        make.width.height.mas_equalTo(30);
    }];
    
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconView.mas_right).offset(15);
        make.centerY.mas_equalTo(self.contentView);
        make.width.mas_equalTo(AdaptedWidth(100));
        make.height.mas_equalTo(AdaptedHeight(15));
    }];
    
    [self.moreIndocator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).offset(-AdaptedWidth(5));
        make.centerY.mas_equalTo(self.contentView);
        make.width.mas_equalTo(AdaptedWidth(9));
        make.height.mas_equalTo(AdaptedWidth(15));
    }];
    
    [self.countLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.moreIndocator.mas_left).offset(-AdaptedWidth(5));
        make.centerY.mas_equalTo(self.contentView);
        make.width.mas_equalTo(AdaptedWidth(50));
        make.height.mas_equalTo(AdaptedHeight(12));
    }];
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLable);
        make.bottom.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)updateCellWithSongCount:(NSString *)count NSIndexPath:(NSIndexPath *)indexPath {
    self.countLable.text = count;
    switch (indexPath.row) {
        case 0:
            self.titleLable.text = @"本地音乐";
            break;
        case 1:
            self.titleLable.text = @"最近播放";
            break;
        case 2:
            self.titleLable.text = @"我的收藏";
            self.bottomLine.hidden = YES;
            break;
            
        default:
            break;
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
