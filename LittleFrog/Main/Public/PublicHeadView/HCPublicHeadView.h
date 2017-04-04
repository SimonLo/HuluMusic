//
//  HCPublicHeadView.h
//  LittleFrog
//
//  Created by SimonLo on 16/4/27.
//  Copyright © 2016年 SimonLo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HCPublicSonglistModel;
@interface HCPublicHeadView : UIView
- (void)setMenuList:(HCPublicSonglistModel *)listModel;
- (void)setNewAlbum:(HCPublicSonglistModel *)albumModel;
- (instancetype)initWithFullHead:(BOOL)full;
@end
