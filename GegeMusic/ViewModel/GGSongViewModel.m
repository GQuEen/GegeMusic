//
//  GGSongViewModel.m
//  GegeMusic
//
//  Created by GQuEen on 16/5/14.
//  Copyright © 2016年 GegeChen. All rights reserved.
//

#import "GGSongViewModel.h"

#define MARGIN 10

@implementation GGSongViewModel

- (void)setModel:(GGSongModel *)model {
    _model = model;
    
    [self setupFrame];

}
- (void)setupFrame {
    _playColor = [UIColor clearColor];
    
    CGFloat albumpicX = MARGIN*2;
    CGFloat albumpicY = MARGIN;
    CGFloat albumpicWH = 45;
    _albumpic = (CGRect){{albumpicX,albumpicY},{albumpicWH,albumpicWH}};
    
    CGFloat songnameX = CGRectGetMaxX(_albumpic) + MARGIN;
    CGFloat songnameY = MARGIN + 5;
    CGFloat songnameW = ScreenWidth - songnameX - 20;
    CGSize songnameSize = [_model.songname sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    _songname = (CGRect){{songnameX,songnameY},{songnameW,songnameSize.height}};
    
    CGFloat singernameX = songnameX;
    CGSize singernameSize = [_model.singername sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    CGFloat singernameY = CGRectGetMaxY(_albumpic) - singernameSize.height - 5;
    _singername = (CGRect){{singernameX,singernameY},singernameSize};
    
    _cellHeight = CGRectGetMaxY(_albumpic) + MARGIN;
    
    CGFloat playX = 0;
    CGFloat playY = 5;
    CGFloat playW = 5;
    CGFloat playH = self.cellHeight - 10;
    _play = (CGRect){{playX,playY},{playW,playH}};
    
}

@end
