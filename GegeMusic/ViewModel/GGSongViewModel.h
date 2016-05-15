//
//  GGSongViewModel.h
//  GegeMusic
//
//  Created by GQuEen on 16/5/14.
//  Copyright © 2016年 GegeChen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGSongModel.h"

@interface GGSongViewModel : NSObject

@property (strong, nonatomic) GGSongModel *model;

@property (assign, nonatomic) CGRect play;
@property (strong, nonatomic) UIColor *playColor;
@property (nonatomic, assign) CGRect albumpic;
@property (nonatomic, assign) CGRect songname;
@property (nonatomic, assign) CGRect singername;

@property (nonatomic, assign) CGFloat cellHeight;
@end
