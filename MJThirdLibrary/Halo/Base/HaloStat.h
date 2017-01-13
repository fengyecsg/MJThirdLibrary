//
//  HaloStat.h
//  MojiWeather
//
//  Created by peter on 14-10-8.
//  Copyright (c) 2014年 Moji Fengyun Software & Technology Development co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HaloStat : NSObject

//友盟统计
+ (void)event:(NSString *)tag;
+ (void)event:(NSString *)tag WithIntParam:(NSInteger)param;
+ (void)event:(NSString *)tag WithParam:(NSString *)param;

+ (void)beginLogPageView:(NSString *)pageName;
+ (void)endLogPageView:(NSString *)pageName;

@end
