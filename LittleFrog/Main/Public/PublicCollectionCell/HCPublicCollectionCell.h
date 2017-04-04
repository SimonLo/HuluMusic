//
//  HCPublicCollectionCell.h
//  LittleFrog
//
//  Created by huangcong on 16/4/23.
//  Copyright © 2016年 HuangCong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HCPublicMusictablesModel;
@interface HCPublicCollectionCell : UICollectionViewCell
- (void)setSongMenu:(HCPublicMusictablesModel *)menu;
- (void)setNewSongAlbum:(HCPublicMusictablesModel *)newSong;
@end
