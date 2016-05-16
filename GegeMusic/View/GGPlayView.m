//
//  GGPlayView.m
//  GegeMusic
//
//  Created by GQuEen on 16/5/15.
//  Copyright © 2016年 GegeChen. All rights reserved.
//

#import "GGPlayView.h"

@interface GGPlayView ()

@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) UIImageView *albumImageView;
@property (assign, nonatomic) CGRect imageViewOriginPostion;

@property (strong, nonatomic) UIImageView *backImageView;

@property (strong, nonatomic) UISlider *slider;

@end

@implementation GGPlayView

- (instancetype)initWithAlbumImageView:(UIImageView *)albumImageView
       withImageViewOriginPostion:(CGRect)imageViewOriginPostion
                       musicModel:(GGSongModel *)model
                    withAVPlayer:(AVPlayer *)player{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        
        self.albumImageView = albumImageView;
        self.imageViewOriginPostion = imageViewOriginPostion;
        self.model = model;
//        self.player = player;
        
        [self setupBackground];
        [self setupToolBar];
        [self setupBottomToolBar];
        [self setupPlayTool];
        [self setupSlider];
        [self setupMidView];
        
    }
    
    return self;
}
- (void)setupBackground {

    _backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _backImageView.contentMode = UIViewContentModeScaleAspectFill;
    __weak typeof(self) weakSelf = self;
    
    SDWebImageManager *manger = [[SDWebImageManager alloc]init];
    NSString *key = [manger cacheKeyForURL:[NSURL URLWithString:self.model.albumpic_small]];
    
    __block UIImage *image = [manger.imageCache imageFromMemoryCacheForKey:key];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage *blurImage = [image applyBlurWithRadius:0.6
                                                            tintColor:RGBColor(0, 0, 0, 0.6)
                                                saturationDeltaFactor:1.4
                                                            maskImage:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.backImageView.image = blurImage;
            [UIView animateWithDuration:0.1f animations:^{
                weakSelf.backImageView.alpha = 1.0f;
            }];
        });
    });
    [self addSubview:self.backImageView];
}

- (void)setupToolBar {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 20, ScreenWidth, 60)];
    
    UIButton *hiddenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    hiddenBtn.frame = CGRectMake(0, 0, 60, 60);
    moreBtn.frame = CGRectMake(ScreenWidth-60, 0, 60, 60);
    
    [hiddenBtn addTarget:self action:@selector(playViewHidden:) forControlEvents:UIControlEventTouchUpInside];
    
    [hiddenBtn setImage:[UIImage imageNamed:@"playlist_close.png"] forState:UIControlStateNormal];
    [moreBtn setImage:[UIImage imageNamed:@"more.png"] forState:UIControlStateNormal];
    
    hiddenBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    moreBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    
    
    UILabel *songName = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, ScreenWidth-120, 40)];
    UILabel *singerName = [[UILabel alloc]initWithFrame:CGRectMake(60, 40, ScreenWidth-120, 20)];
    songName.font = [UIFont systemFontOfSize:19];
    songName.textColor = [UIColor whiteColor];
    singerName.font = [UIFont systemFontOfSize:16];
    singerName.textColor = [UIColor whiteColor];
    songName.text = self.model.songname;
    singerName.text = [NSString stringWithFormat:@"— %@ —",self.model.singername];
    
    songName.textAlignment = NSTextAlignmentCenter;
    singerName.textAlignment = NSTextAlignmentCenter;
    [view addSubview:songName];
    [view addSubview:singerName];
    [view addSubview:hiddenBtn];
    [view addSubview:moreBtn];
    [self addSubview:view];

}

- (void)playViewHidden:(UIButton *)sender {
    [self removeFromSuperview];
}

- (void)setupBottomToolBar {
    const CGFloat kButtonWidth = ScreenWidth/5;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight-50, ScreenWidth, 50)];
    NSArray *pic = @[@"爱心.png",@"循环.png",@"下载.png",@"分享.png",@"列表1.png"];
    for (int i = 0; i < 5; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:pic[i]] forState:UIControlStateNormal];
        CGFloat margin = (kButtonWidth-30)/2;
        btn.imageEdgeInsets = UIEdgeInsetsMake(10, margin, 10, margin);
        btn.frame = CGRectMake(i*kButtonWidth, 0, kButtonWidth, 50);
        btn.tag = i;
        [view addSubview:btn];
    }
    
    [self addSubview:view];
}

- (void)setupPlayTool {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight-50-85, ScreenWidth, 85)];
    UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *nextSongBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *lastSongBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [playBtn setImage:[UIImage imageNamed:@"播放大.png"] forState:UIControlStateNormal];
    [nextSongBtn setImage:[UIImage imageNamed:@"下一曲.png"] forState:UIControlStateNormal];
    [lastSongBtn setImage:[UIImage imageNamed:@"上一曲.png"] forState:UIControlStateNormal];
    
    playBtn.frame = CGRectMake(0, 0, 65, 65);
    nextSongBtn.frame = CGRectMake(0, 0, 50, 50);
    lastSongBtn.frame = CGRectMake(0, 0, 50, 50);
    
    const CGFloat marigin = (ScreenWidth-65-100)/6;
    
    playBtn.center = CGPointMake(ScreenWidth/2, view.frame.size.height/2);
    nextSongBtn.center = CGPointMake(CGRectGetMaxX(playBtn.frame)+marigin+20, view.frame.size.height/2);
    lastSongBtn.center = CGPointMake(playBtn.frame.origin.x - marigin-20, view.frame.size.height/2);
    [view addSubview:playBtn];
    [view addSubview:nextSongBtn];
    [view addSubview:lastSongBtn];
    [self addSubview:view];
}

- (void)setupSlider {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight-155, ScreenWidth, 20)];
    UILabel *currentTime = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
    UILabel *totalTime = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-50, 0, 50, 20)];
    
    currentTime.text = @"00:00";
    totalTime.text = @"03:00";
    
    currentTime.font = [UIFont systemFontOfSize:14];
    totalTime.font = [UIFont systemFontOfSize:14];
    
    currentTime.textAlignment = NSTextAlignmentCenter;
    totalTime.textAlignment = NSTextAlignmentCenter;
    
    currentTime.textColor = [UIColor colorWithRed:177/255.0 green:177/255.0 blue:177/255.0 alpha:1];
    totalTime.textColor = [UIColor colorWithRed:177/255.0 green:177/255.0 blue:177/255.0 alpha:1];
    
    
    _slider = [[UISlider alloc]initWithFrame:CGRectMake(50, 0, ScreenWidth-100, 20)];
    [self.slider setThumbImage:[UIImage imageNamed:@"圆圈 (1).png"] forState:UIControlStateNormal];
    [self.slider setMinimumTrackTintColor:[UIColor colorWithRed:38/255.0 green:188/255.0 blue:213/255.0 alpha:1.0]];
    [self addSubview:view];
    [view addSubview:currentTime];
    [view addSubview:totalTime];
    [view addSubview:self.slider];
}

- (void)setupMidView {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 80, ScreenWidth, ScreenHeight-230)];
    
    const CGFloat kImageViewW = ScreenWidth/4*3;
    
    UIView *backImageView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kImageViewW, kImageViewW)];
    backImageView.layer.cornerRadius = kImageViewW/2;
    backImageView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    backImageView.center = CGPointMake(view.frame.size.width/2, view.frame.size.height/2);
    
    UIImageView *album = [[UIImageView alloc]init];
    album.layer.cornerRadius = (kImageViewW-15)/2;
    album.layer.masksToBounds = YES;
    album.frame = CGRectMake(0, 0, kImageViewW-15, kImageViewW-15);
    album.center = CGPointMake(view.frame.size.width/2, view.frame.size.height/2);
    
    SDWebImageManager *manger = [[SDWebImageManager alloc]init];
    NSString *key = [manger cacheKeyForURL:[NSURL URLWithString:self.model.albumpic_small]];
    
    UIImage *image = [manger.imageCache imageFromMemoryCacheForKey:key];
    
    [album sd_setImageWithURL:[NSURL URLWithString:self.model.albumpic_big] placeholderImage:image];
    
    CABasicAnimation* rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotation.toValue = [NSNumber numberWithFloat: M_PI * 2.0];
    rotation.duration = 35;
    rotation.cumulative = YES;
    rotation.repeatCount = NSIntegerMax;
    
    [album.layer addAnimation:rotation forKey:nil];
    
    [self addSubview:view];
    [view addSubview:backImageView];
    [view addSubview:album];
}

- (void)show {
//    __weak typeof(self) weakSelf = self;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
//    [UIView animateWithDuration:0.3 animations:^{
//        
//    } completion:^(BOOL finished) {
//        
//    }];
}

- (void)hidden {
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
