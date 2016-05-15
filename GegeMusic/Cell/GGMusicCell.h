//
//  GGMusicCell.h
//  GegeMusic
//
//  Created by GQuEen on 16/5/15.
//  Copyright © 2016年 GegeChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGSongModel.h"
#import "GGSongViewModel.h"

@interface GGMusicCell : UITableViewCell

@property (strong, nonatomic) GGSongModel *model;
@property (strong, nonatomic) GGSongViewModel *viewModel;

@property (strong, nonatomic) UIView *play;
@property (strong, nonatomic) UIImageView *albumImageView;
@property (strong, nonatomic) UILabel *songNameLabel;
@property (strong, nonatomic) UILabel *singerNameLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
