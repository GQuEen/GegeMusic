//
//  GGMusicCell.m
//  GegeMusic
//
//  Created by GQuEen on 16/5/15.
//  Copyright © 2016年 GegeChen. All rights reserved.
//

#import "GGMusicCell.h"

@interface GGMusicCell ()

@property (strong, nonatomic)UIView *separator;

@end

@implementation GGMusicCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUI];
    }
    return self;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identify = @"MusicListCell";
    GGMusicCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[GGMusicCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    return cell;
}

- (void)setUI {
    
    _play = [[UIView alloc] init];
//    _play.backgroundColor = [UIColor clearColor];
    
    _albumImageView = [[UIImageView alloc]init];
    _albumImageView.layer.cornerRadius = 45/2;
    _albumImageView.layer.masksToBounds = YES;
    _albumImageView.layer.borderWidth = 0.5;
    _albumImageView.layer.borderColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:0.5].CGColor;
    
    _songNameLabel = [[UILabel alloc]init];
    _songNameLabel.font = [UIFont systemFontOfSize:16];
    _songNameLabel.textColor = [UIColor colorWithRed:54/255.0 green:54/255.0 blue:54/255.0 alpha:1];
    _songNameLabel.numberOfLines = 0;
    
    _singerNameLabel = [[UILabel alloc]init];
    _singerNameLabel.font = [UIFont systemFontOfSize:14];
    _singerNameLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    
    _separator = [[UIView alloc]init];
    _separator.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    
    [self.contentView addSubview:self.play];
    [self.contentView addSubview:self.albumImageView];
    [self.contentView addSubview:self.songNameLabel];
    [self.contentView addSubview:self.singerNameLabel];
    [self.contentView addSubview:self.separator];
}

- (void)setViewModel:(GGSongViewModel *)viewModel {
    _viewModel = viewModel;
    _model = viewModel.model;
    
    [self setData];
    [self setFrame];
}

- (void)setData {
    [_albumImageView sd_setImageWithURL:[NSURL URLWithString:self.model.albumpic_small] placeholderImage:nil];
    _songNameLabel.text = self.model.songname;
    _singerNameLabel.text = self.model.singername;

}
- (void)setFrame {
    _play.backgroundColor = self.viewModel.playColor;
    _play.frame = self.viewModel.play;
    _albumImageView.frame = self.viewModel.albumpic;
    _songNameLabel.frame = self.viewModel.songname;
    _singerNameLabel.frame = self.viewModel.singername;
    _separator.frame = CGRectMake(0, self.viewModel.cellHeight - 0.5, ScreenWidth, 0.5);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
