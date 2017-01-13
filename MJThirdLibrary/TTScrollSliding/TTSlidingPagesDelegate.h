//
//  TTSlidingPagesDelegate.h
//  MojiWeather
//
//  Created by guobiao.you on 15/4/24.
//  Copyright (c) 2015年 Moji Fengyun Software & Technology Development co., Ltd. All rights reserved.
//

//Added By GuoBiaoYou 15.4.24
@protocol TTSlidingPagesDelegate <NSObject>

@optional
- (void)slidingPagesViewDidScroll:(UIScrollView *)scrollView;

- (void)slidingPagesViewDidEndScrollingAnimation:(UIScrollView *)scrollView;

@end
//end