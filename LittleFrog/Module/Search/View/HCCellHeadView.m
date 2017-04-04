//
//  HCCellHeadView.m
//  LittleFrog
//
//  Created by huangcong on 16/4/28.
//  Copyright © 2016年 HuangCong. All rights reserved.
//

#import "HCCellHeadView.h"

@interface HCCellHeadView ()
@property (nonatomic ,weak) UIButton *clickButton;
@property (nonatomic ,weak) UILabel *titleLabel;
@property (nonatomic ,weak) UIView *lineView;
@property (nonatomic ,assign) BOOL isButton;

@end
@implementation HCCellHeadView
- (void)setHeadTitle:(NSString *)title button:(NSString *)button
{
    self.titleLabel.text = title;
    if (button.length) {
        [self.clickButton setTitle:button forState:UIControlStateNormal];
    }
    else{
        self.clickButton.hidden = YES;
    }
}
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.lineView = [HCCreatTool viewWithView:self];
        self.lineView.backgroundColor = HCTintColor;
        self.lineView.frame = CGRectMake(HCCommonSpacing, 3, 2, 20);
        
        self.titleLabel = [HCCreatTool labelWithView:self];
        self.titleLabel.frame = CGRectMake(HCHorizontalSpacing, 3, HCScreenWidth - 100, 20);
        self.titleLabel.font = HCBigFont;
        self.titleLabel.textColor = HCTintColor;
        
        self.clickButton = [HCCreatTool buttonWithView:self];
        self.clickButton.frame = CGRectMake(HCScreenWidth - 74, 5, 54, 20);
        self.clickButton.titleLabel.font = HCBigFont;
        self.clickButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        self.clickButton.layer.borderWidth = 0.5;
        self.clickButton.layer.cornerRadius = 5.0;
        [self.clickButton setTitleColor:HCMainColor forState:UIControlStateNormal];
        [self.clickButton addTarget:self action:@selector(clickHeaderButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
+ (instancetype)headViewWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"head";
    HCCellHeadView *head = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (!head) {
        head = [[HCCellHeadView alloc] initWithReuseIdentifier:ID];
    }
    return head;
}
- (void)clickHeaderButton
{
    HCLog(@"点击更多");
    if ([self.delegate respondsToSelector:@selector(clickCellHeadViewButton)]) {
        [self.delegate clickCellHeadViewButton];
    }
}
@end
