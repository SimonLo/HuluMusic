//
//  HCSongListContentView.m
//  LittleFrog
//
//  Created by Simon Lo on 2017/4/4.
//  Copyright © 2017年 HuangCong. All rights reserved.
//

#import "HCSongListContentView.h"
#import "HCPublicSongDetailModel.h"
#import "HCPlaySongListCell.h"
#import "HCBlurViewTool.h"

@interface HCSongListContentView() <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,weak) UITableView *songListTableView;
@property (nonatomic ,weak) UIView *topBriefView;
@property (nonatomic ,weak) UIButton *bottomCloseBtn;
@property (nonatomic ,weak) UIView *bottomLineView;

@property (nonatomic ,weak) UILabel *playlistText;
@property (nonatomic ,weak) UILabel *listNum;
@property (nonatomic ,weak) UIView *topLineView;

@end

static NSString *const listCellid = @"listCellid";

@implementation HCSongListContentView

- (void)setSongListArray:(NSMutableArray *)songListArray {
    _songListArray = [songListArray mutableCopy];
    self.listNum.text = [NSString stringWithFormat:@"%zd首",songListArray.count];
    [self.songListTableView reloadData];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIImageView *bgImageView = [HCCreatTool imageViewWithView:self];
        bgImageView.image = self.backImage;
        bgImageView.frame = CGRectMake(0,0,HCScreenWidth,HCScreenHeight);
        [HCBlurViewTool blurView:bgImageView style:UIBarStyleDefault];
        [self insertSubview:bgImageView atIndex:0];
        
        self.topBriefView = [HCCreatTool viewWithView:self];

        self.playlistText = [HCCreatTool labelWithView:self.topBriefView];
        self.playlistText.text = @"播放列表";
        self.playlistText.textColor = HCTextColor;
        self.playlistText.font = [UIFont systemFontOfSize:14];
        self.listNum = [HCCreatTool labelWithView:self.topBriefView];
        self.listNum.textColor = [UIColor grayColor];
        self.listNum.font = HCSmallFont;
        self.topLineView = [HCCreatTool viewWithView:self];
        self.topLineView.backgroundColor = HCGrayColor;
        
        self.bottomCloseBtn = [HCCreatTool buttonWithView:self];
        NSDictionary *dictAttr = @{NSFontAttributeName:HCBigFont,
                                    NSForegroundColorAttributeName: HCTextColor
                                    };
        NSAttributedString *attrStr = [[NSAttributedString alloc]initWithString:@"关闭" attributes:dictAttr];
        [self.bottomCloseBtn setAttributedTitle:attrStr forState:UIControlStateNormal];
        [self.bottomCloseBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        self.bottomLineView = [HCCreatTool viewWithView:self];
        self.bottomLineView.backgroundColor = HCGrayColor;
        
        UITableView *songListTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        songListTableView.backgroundColor = [UIColor clearColor];
        songListTableView.delegate = self;
        songListTableView.dataSource = self;
        songListTableView.tableFooterView = [UIView new];
        [songListTableView registerClass:[HCPlaySongListCell class] forCellReuseIdentifier:listCellid];
        [self addSubview:songListTableView];
        self.songListTableView = songListTableView;
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.topBriefView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self);
        make.height.mas_equalTo(40);
    }];
    
    [self.playlistText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.topBriefView).offset(15);
        make.centerY.mas_equalTo(self.topBriefView);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_equalTo(14);
    }];
    
    [self.listNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.playlistText.mas_right).offset(5);
        make.centerY.mas_equalTo(self.topBriefView);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(11);
    }];
    
    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self.topBriefView.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.bottomCloseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self);
        make.height.mas_equalTo(50);
    }];
    
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(self.bottomCloseBtn);
        make.height.mas_equalTo(0.5);
    }];
    
    
    [self.songListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topBriefView.mas_bottom);
        make.left.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self.bottomCloseBtn.mas_top);
    }];
}

- (void)closeBtnClick{
    if (self.closeButtonClickBlock) {
        self.closeButtonClickBlock();
    }
}

//代理，数据源
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.songListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HCPlaySongListCell *cell = [tableView dequeueReusableCellWithIdentifier:listCellid];
    cell.didDeleteSongBlock = ^{
        HCPublicSongDetailModel *model = [self.songListArray objectAtIndex:indexPath.row];
        NSLog(@"%@",model.title);
        
        [self.songListArray removeObjectAtIndex:indexPath.row];
        self.listNum.text = [NSString stringWithFormat:@"%zd首",self.songListArray.count];
        [self.songListTableView reloadData];
        
        //告诉播放页面，里面删除掉了模型，外面要同步删除
        if (self.didDeleteSongModelBlock) {
            self.didDeleteSongModelBlock(indexPath.row);
        };
    };
    
    HCPublicSongDetailModel *model = self.songListArray[indexPath.row];
    BOOL isPlaying = self.playingIndex == indexPath.row ? YES : NO;
    [cell updateCellWithDetailModel:model isPlaying:isPlaying andTotalSongCount:self.songListArray.count];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.didSelectSongBlock) {
        self.didSelectSongBlock(indexPath.row);
    }
}






@end
