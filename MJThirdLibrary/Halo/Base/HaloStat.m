//
//  HaloStat.m
//  MojiWeather
//
//  Created by peter on 14-10-8.
//  Copyright (c) 2014年 Moji Fengyun Software & Technology Development co., Ltd. All rights reserved.
//

#import "HaloStat.h"
#import "UMMobClick/MobClick.h"

@implementation HaloStat

+ (void)beginLogPageView:(NSString *)pageName{
    [MobClick beginLogPageView:[NSString stringWithFormat:@"5_%@",pageName]];
}

+ (void)endLogPageView:(NSString *)pageName{
    [MobClick endLogPageView:[NSString stringWithFormat:@"5_%@",pageName]];
}

+ (void) event:(NSString *) tag{
    [self event:tag WithParam:nil];
}

+ (void) event:(NSString *) tag WithIntParam:(NSInteger)param{
    [MJStatistic recordEvent:tag tag:[NSString stringWithFormat:@"%ld", (long)param]];
}

+ (void) event:(NSString *) tag WithParam:(NSString *) param{
    if ([tag hasPrefix:@"5_"]){
        tag = [tag substringFromIndex:2];
    }
    if (param)
        [MobClick event:[NSString stringWithFormat:@"5_%@",tag] label:param];
    else
        [MobClick event:[NSString stringWithFormat:@"5_%@",tag]];
}

@end
