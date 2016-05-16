//
//  GGPlayToolView.m
//  GegeMusic
//
//  Created by GQuEen on 16/5/15.
//  Copyright © 2016年 GegeChen. All rights reserved.
//

#import "GGPlayToolView.h"
#import "GGPlayView.h"

#define MARGIN 10
#define NSIntegerMax    LONG_MAX

@interface GGPlayToolView ()

@property (strong, nonatomic) GGPlayView *playView;
@property (strong, nonatomic) UIImageView *albumImageView;
@property (strong, nonatomic) UILabel *songNameLabel;
@property (strong, nonatomic) UILabel *singerNameLabel;

@property (strong, nonatomic) UIButton *playBtn;
@property (strong, nonatomic) UIButton *songListBtn;

@property (strong, nonatomic) AVPlayer *player;

@end

@implementation GGPlayToolView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        self.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1];
        
    }
    return self;
}

- (void)setupUI {
    UIView *topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
    topLine.backgroundColor = [UIColor colorWithRed:178/255.0 green:178/255.0 blue:178/255.0 alpha:1];
    
    _albumImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 45, 45)];
    _albumImageView.image = [UIImage imageNamed:@"唱片.png"];
    _albumImageView.layer.cornerRadius = 45/2;
    _albumImageView.contentMode = UIViewContentModeScaleToFill;
    _albumImageView.userInteractionEnabled = NO;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAlbumImageView:)];
    [_albumImageView addGestureRecognizer:tap];
    
    _songNameLabel = [[UILabel alloc]init];
    CGFloat songnameX = CGRectGetMaxX(_albumImageView.frame) + MARGIN;
    CGFloat songnameY = MARGIN + 5;
    CGFloat songnameW = ScreenWidth - songnameX - 110;
    CGSize songnameSize = [@"歌名" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    _songNameLabel.frame = (CGRect){{songnameX,songnameY},{songnameW,songnameSize.height}};
    _songNameLabel.text = @"歌名";
    _songNameLabel.font = [UIFont systemFontOfSize:16];
    _songNameLabel.textColor = [UIColor colorWithRed:54/255.0 green:54/255.0 blue:54/255.0 alpha:1];
    
    _singerNameLabel = [[UILabel alloc]init];
    CGFloat singernameX = songnameX;
    CGSize singernameSize = [@"歌手名" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    CGFloat singernameY = CGRectGetMaxY(_albumImageView.frame) - singernameSize.height - 5;
    CGFloat singernameW = ScreenWidth - songnameX - 110;
    _singerNameLabel.frame = (CGRect){{singernameX,singernameY},{singernameW,singernameSize.height}};
    _singerNameLabel.text = @"歌手名";
    _singerNameLabel.font = [UIFont systemFontOfSize:14];
    _singerNameLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    
    _songListBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _songListBtn.frame = CGRectMake(ScreenWidth-15-64/2, 0, 64/2, 35);
    _songListBtn.center = CGPointMake(CGRectGetMidX(_songListBtn.frame), self.frame.size.height/2);
    [_songListBtn setBackgroundImage:[UIImage imageNamed:@"播放列表.png"] forState:UIControlStateNormal];
    
    _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _playBtn.frame = CGRectMake(ScreenWidth-100, 15, 35, 35);
    [_playBtn addTarget:self action:@selector(clickStarOrPause:) forControlEvents:UIControlEventTouchUpInside];
    [_playBtn setImage:[UIImage imageNamed:@"播放.png"] forState:UIControlStateNormal];
    [_playBtn setImage:[UIImage imageNamed:@"暂停.png"] forState:UIControlStateSelected];
    
    [self addSubview:topLine];
    [self addSubview:self.albumImageView];
    [self addSubview:self.songNameLabel];
    [self addSubview:self.singerNameLabel];
    [self addSubview:self.playBtn];
    [self addSubview:self.songListBtn];
    
}

- (void)setModel:(GGSongModel *)model {
    _model = model;
    _albumImageView.userInteractionEnabled = YES;
    [_albumImageView sd_setImageWithURL:[NSURL URLWithString:self.model.albumpic_small]];
    _songNameLabel.text = self.model.songname;
    _singerNameLabel.text = self.model.singername;
    _playBtn.selected = YES;
    
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0];
    rotationAnimation.duration = 35;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = NSIntegerMax;
    
    [_albumImageView.layer addAnimation:rotationAnimation forKey:nil];
    
    AVPlayerItem *playerItem = [[AVPlayerItem alloc]initWithURL:[NSURL URLWithString:model.url]];
    _player = [[AVPlayer alloc]initWithPlayerItem:playerItem];
    NSLog(@"%@",model.url);
    [_player play];
}

- (void)clickStarOrPause:(UIButton *)sender {
    
    if (sender.selected) {
        [_player pause];
        [_albumImageView.layer pauseAnimate];
        sender.selected = !sender.selected;
    }else {
        [_player play];
        [_albumImageView.layer resumeAnimate];
        sender.selected = !sender.selected;
    }
}

- (void)tapAlbumImageView:(UITapGestureRecognizer *)gesture {
    NSLog(@"点击");
    _playView = [[GGPlayView alloc]initWithAlbumImageView:self.albumImageView withImageViewOriginPostion:self.albumImageView.frame musicModel:self.model withAVPlayer:self.player];
    [_playView show];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
