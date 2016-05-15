//
//  GGSongModel.h
//  GegeMusic
//
//  Created by GQuEen on 16/5/14.
//  Copyright © 2016年 GegeChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGSongModel : NSObject

@property (copy, nonatomic) NSString *albumid;//专辑ID
@property (copy, nonatomic) NSString *albumpic_big;//专辑图片 大图
@property (copy, nonatomic) NSString *albumpic_small;//专辑图片 小图
@property (copy, nonatomic) NSString *downUrl;//下载MP3的URL
@property (copy, nonatomic) NSString *seconds;//音乐的时间
@property (copy, nonatomic) NSString *singerid;//歌手ID
@property (copy, nonatomic) NSString *singername;//歌手名字
@property (copy, nonatomic) NSString *songid;//歌曲ID
@property (copy, nonatomic) NSString *songname;//歌曲名字
@property (copy, nonatomic) NSString *url;//流媒体播放URL


- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
