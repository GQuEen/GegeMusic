//
//  GGSongModel.m
//  GegeMusic
//
//  Created by GQuEen on 16/5/14.
//  Copyright © 2016年 GegeChen. All rights reserved.
//

#import "GGSongModel.h"

@implementation GGSongModel

- (instancetype)initWithDictionary:(NSDictionary *)dic {
    if (self = [super init]) {
        
        self.albumid = dic[@"albumid"] ?: @"";
        self.albumpic_big = dic[@"albumpic_big"] ?: @"";
        self.albumpic_small = dic[@"albumpic_small"] ?: @"";
        self.downUrl = dic[@"downUrl"] ?: @"";
        self.seconds = dic[@"seconds"] ?: @"";
        self.singerid = dic[@"singerid"] ?: @"";
        self.singername = dic[@"singername"] ?: @"";
        self.songid = dic[@"songid"] ?: @"";
        self.songname = dic[@"songname"] ?: @"";
        self.url = dic[@"url"] ?: @"";
    }
    return self;
}


- (NSString *)description {
    NSString *result = @"";
    result = [result stringByAppendingFormat:@"albumid : %@\n",self.albumid];
    result = [result stringByAppendingFormat:@"albumpic_big : %@\n",self.albumpic_big];
    result = [result stringByAppendingFormat:@"albumpic_small : %@\n",self.albumpic_small];
    result = [result stringByAppendingFormat:@"downUrl : %@\n",self.downUrl];
    result = [result stringByAppendingFormat:@"seconds : %@\n",self.seconds];
    result = [result stringByAppendingFormat:@"singerid : %@\n",self.singerid];
    result = [result stringByAppendingFormat:@"singername : %@\n",self.singername];
    result = [result stringByAppendingFormat:@"songid : %@\n",self.songid];
    result = [result stringByAppendingFormat:@"songname : %@\n",self.songname];
    result = [result stringByAppendingFormat:@"url : %@\n",self.url];
    return result;
}

@end
