//
//  GGPlayView.h
//  GegeMusic
//
//  Created by GQuEen on 16/5/15.
//  Copyright © 2016年 GegeChen. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "GGSongModel.h"


@interface GGPlayView : UIView

@property (strong, nonatomic) GGSongModel *model;

- (instancetype)initWithAlbumImageView:(UIImageView *)albumImageView
       withImageViewOriginPostion:(CGRect)imageViewOriginPostion
                            musicModel:(GGSongModel *)model
                          withAVPlayer:(AVPlayer *)player;

- (void)show;
- (void)hidden;

@end
