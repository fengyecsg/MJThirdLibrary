//
//  KDCycleBannerView.h
//  KDCycleBannerViewDemo
//
//  Created by Kingiol on 14-4-11.
//  Copyright (c) 2014年 Kingiol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMPageControl.h"


typedef NS_ENUM(NSUInteger, KDBannerIndicatorAligment) {
    KDBannerIndicatorAligmentCenter = 1,            //Default
    KDBannerIndicatorAligmentRight,
    KDBannerIndicatorAligmentLeft
};

typedef NS_ENUM(NSUInteger, KDBannerIndicatorVerticalAlignment) {
    KDBannerIndicatorVerticalAlignmentBottom = 1,   //Default
    KDBannerIndicatorVerticalAlignmentMiddle,
    KDBannerIndicatorVerticalAlignmentTop
};

@class KDCycleBannerView;

typedef void(^CompleteBlock)(void);

@protocol KDCycleBannerViewDataSource <NSObject>

@required
- (NSArray *)numberOfKDCycleBannerView:(KDCycleBannerView *)bannerView;
- (UIViewContentMode)contentModeForImageIndex:(NSUInteger)index;

@optional
- (UIImage *)placeHolderImageOfZeroBannerView;
- (UIImage *)placeHolderImageOfBannerView:(KDCycleBannerView *)bannerView atIndex:(NSUInteger)index;

@end

@protocol KDCycleBannerViewDelegate <NSObject>

@optional
- (void)cycleBannerView:(KDCycleBannerView *)bannerView didScrollToIndex:(NSUInteger)index;
- (void)cycleBannerView:(KDCycleBannerView *)bannerView didSelectedAtIndex:(NSUInteger)index;

@end

@interface KDCycleBannerView : UIView

// Delegate and Datasource
@property (weak, nonatomic) IBOutlet id<KDCycleBannerViewDataSource> datasource;
@property (weak, nonatomic) IBOutlet id<KDCycleBannerViewDelegate> delegate;

@property (assign, nonatomic, getter = isContinuous) BOOL continuous;   // if YES, then bannerview will show like a carousel, default is NO
@property (assign, nonatomic) NSUInteger autoPlayTimeInterval;  // if autoPlayTimeInterval more than 0, the bannerView will autoplay with autoPlayTimeInterval value space, default is 0

@property (strong, nonatomic, readonly) SMPageControl *bannerPageControl;
@property (assign, nonatomic) UIEdgeInsets indicatorInsets;
@property (assign, nonatomic) SMPageControlAlignment indicatorAligment; //Horizontal alignment of PageControl indicator, default is SMPageControlAlignmentCenter
@property (assign, nonatomic) SMPageControlVerticalAlignment indicatorVerticalAlignment; //Vertical alignment of PageControl indicator, SMPageControlVerticalAlignmentBottom
@property (nonatomic, strong) UIImage *pageIndicatorImage;
@property (nonatomic, strong) UIImage *currentPageIndicatorImage;

- (void)reloadDataWithCompleteBlock:(CompleteBlock)competeBlock;
- (void)setCurrentPage:(NSInteger)currentPage animated:(BOOL)animated;

@end
