//
//  HCRankListCell.m
//  LittleFrog
//
//  Created by huangcong on 16/4/26.
//  Copyright © 2016年 HuangCong. All rights reserved.
//

#import "HCRankListCell.h"
#import "HCRankSongModel.h"
@interface HCRankListCell ()
@property (nonatomic ,weak) UIImageView *cellImageView;
@end
@implementation HCRankListCell
- (void)setRankListImage:(NSString *)rankListImage
{
    _rankListImage = rankListImage;
    [self.cellImageView sd_setImageWithURL:[NSURL URLWithString:_rankListImage]];
}

- (instancetype)initWithArray:(NSArray *)array
{
    if (self = [super init]) {
        NSInteger imageHeight = HCScreenWidth / 3;
        CGFloat labelHeight = (imageHeight - 3 * HCVerticalSpacing) / 4;
        CGFloat labelWidth = HCScreenWidth - imageHeight - 3 * HCVerticalSpacing;
        self.cellImageView = [HCCreatTool imageViewWithView:self.contentView];
        self.cellImageView.frame = CGRectMake(HCVerticalSpacing * 2, HCVerticalSpacing * 2, imageHeight, imageHeight);
        NSInteger i = 0;
        for (NSDictionary *dict in array) {
            HCRankSongModel *song = [HCRankSongModel mj_objectWithKeyValues:dict];
            UILabel *label = [HCCreatTool labelWithView:self.contentView];
            label.frame = CGRectMake(imageHeight + 3 * HCVerticalSpacing, HCVerticalSpacing * 2 + (HCVerticalSpacing + labelHeight) * i, labelWidth, labelHeight);
            label.text = [NSString stringWithFormat:@"%ld. %@ - %@",(long)i + 1,song.title,song.author];
            label.textColor = HCTextColor;
            label.font = HCBigFont;
            i++;
        }
    }
    return self;
}

+ (instancetype)rankCellWithTableView:(UITableView *)tableView songInfoArray:(NSArray *)info
{
    static NSString *ID = @"rankCell";
    HCRankListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[HCRankListCell alloc] initWithArray:info];
    }
    return cell;
}
@end
