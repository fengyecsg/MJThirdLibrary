//
//  Layout.h
//  Created by LiuChao on 14-7-6.
//

#import <Foundation/Foundation.h>
#import "LayoutElement.h"

typedef NS_ENUM(NSInteger, LinearAlignment) {
    LinearAlignmentTop              = 0,
    LinearAlignmentBottom           = 1,
    LinearAlignmentVerticalCenter   = 2,
    LinearAlignmentLeft             = 3,
    LinearAlignmentRight            = 4,
    LinearAlignmentHorizontalCenter = 5,
};

@interface Layout : NSObject

//直线、矩阵:多个元素的外部关系
+ (BaseElement *)linear:(NSArray *)elements align:(LinearAlignment)align gap:(CGFloat)gap;
+ (BaseElement *)matrix:(NSArray *)elements rowGap:(CGFloat)rGap colGap:(CGFloat)cGap colNum:(NSUInteger)cNum;

//两元素的内部关系:上下左右中心、四角相对位置
+ (void)e:(NSObject *)element inCenter:(NSObject *)anchor;
+ (void)e:(NSObject *)element inTopCenter:(NSObject *)anchor gap:(CGFloat)gap;
+ (void)e:(NSObject *)element inLeftCenter:(NSObject *)anchor gap:(CGFloat)gap;
+ (void)e:(NSObject *)element inRightCenter:(NSObject *)anchor gap:(CGFloat)gap;
+ (void)e:(NSObject *)element inBottomCenter:(NSObject *)anchor gap:(CGFloat)gap;

+ (void)e:(NSObject *)element within:(NSObject *)anchor left:(CGFloat)leftGap top:(CGFloat)topGap;
+ (void)e:(NSObject *)element within:(NSObject *)anchor left:(CGFloat)leftGap bottom:(CGFloat)bottomGap;
+ (void)e:(NSObject *)element within:(NSObject *)anchor right:(CGFloat)rightGap top:(CGFloat)topGap;
+ (void)e:(NSObject *)element within:(NSObject *)anchor right:(CGFloat)rightGap bottom:(CGFloat)bottomGap;

//元素
+ (BaseElement *)e:(NSObject *)wrapObj;
+ (BaseElement *)eSizeFitLabel:(UILabel *)label;
+ (BaseElement *)eFixedLabel:(UILabel *)label;


@end
