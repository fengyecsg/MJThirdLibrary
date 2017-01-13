//
//  Layout.m
//  MojiWeather
//
//  Created by LiuChao on 14-7-6.
//  Copyright (c) 2014年 Moji Fengyun Software & Technology Development co., Ltd. All rights reserved.
//

#import "Layout.h"

@interface Layout()

+(LogicalElement *)logicalElement;
+(ActualElement *)actualElement:(UIView *)content;
+(BOOL)is:(BaseElement *)element belongToAnchor:(BaseElement *)anchor;
@end

@implementation Layout

+(ActualElement *)actualElement: (UIView *)content{
    ActualElement *element = [[ActualElement alloc] init];
    element.content = content;
    return element;
}

+(LogicalElement *)logicalElement {
    LogicalElement *element = [[LogicalElement alloc] init];
    return element;
}

//智能判断所属关系
+(BOOL)is:(BaseElement *)element belongToAnchor:(BaseElement *)anchor {
    if (![anchor isKindOfClass:[ActualElement class]]) {
        //in general, don't set LogicalElement as anchor; VirtualElement just a rect in mind
        return NO;
    }
    UIView *anchorView = ((ActualElement *)anchor).content;
    if (anchorView.frame.origin.x == 0 && anchorView.frame.origin.y == 0) {
        //no need set belong
        return NO;
    }
    if ([element isKindOfClass:[ActualElement class]]) {
        ActualElement *e = (ActualElement *)element;
        return e.content.superview == anchorView;
    }
    if ([element isKindOfClass:[LogicalElement class]]) {
        LogicalElement *e = (LogicalElement *)element;
        UIView *v = [e searchViewInDepthFirst];
        return v && (v.superview == anchorView);
    }
    return NO;
}

+ (BaseElement *)e:(NSObject *)wrapObj {
    BaseElement *element;
    if ([wrapObj isKindOfClass:[BaseElement class]]) {
        element = (BaseElement *)wrapObj;
    }
    else if ([wrapObj isKindOfClass:[UIView class]]) {
        element = [Layout actualElement:(UIView *)wrapObj];
    }
    return element;
}

+ (BaseElement *)eSizeFitLabel:(UILabel *)label {
    BaseElement *e = [Layout e:label];
    [e addProperty:LayoutNoEdgeInset];
    return e;
}

+ (BaseElement *)eFixedLabel:(UILabel *)label {
    BaseElement *e = [Layout e:label];
    [e addProperty:LayoutNoEdgeInset | LayoutNoSizeToFit];
    return e;
}

+ (BaseElement *)linear:(NSArray *)elements align:(LinearAlignment)align gap:(CGFloat)gap {
    if (!elements || [elements count] == 0) {
        return nil;
    }
    LogicalElement *logicalElement = [Layout logicalElement];
    BaseElement *firstElement = [self e:[elements objectAtIndex:0]];
    VirtualElement *bElement = [[VirtualElement alloc] initWithFrame:CGRectZero];
    
    //    DLOG(@"%f  %f", firstElement.x, firstElement.y)
    
    [firstElement setAnchor:bElement inside:YES];
    firstElement.layout_gapToLeftInAnchor = firstElement.x;
    firstElement.layout_gapToTopInAnchor = firstElement.y;
    [firstElement layout];
    //    DLOG(@"%f  %f", firstElement.x, firstElement.y)
    [logicalElement addElement:firstElement];
    
    BaseElement *lastElement = firstElement;
    for (NSUInteger i = 1; i < [elements count]; i ++) {
        BaseElement *element = [self e:[elements objectAtIndex:i]];
        [element setAnchor:lastElement inside:NO];
        
        if (align == LinearAlignmentTop || align == LinearAlignmentBottom || align == LinearAlignmentVerticalCenter) {
            element.layout_isToRightOfAnchor = YES;
            if (align == LinearAlignmentTop) {
                element.layout_isAlignTopOfAnchor = YES;
            }
            else if (align == LinearAlignmentBottom) {
                element.layout_isAlignBottomOfAnchor = YES;
            }
            else {
                element.layout_isCenterVerticalOfAnchor = YES;
            }
            element.layout_gapToRightOfAnchor = gap;
        }
        else if (align == LinearAlignmentLeft || align == LinearAlignmentRight || align == LinearAlignmentHorizontalCenter) {
            element.layout_isBelowAnchor = YES;
            if (align == LinearAlignmentLeft) {
                element.layout_isAlignLeftOfAnchor = YES;
            }
            else if (align == LinearAlignmentRight) {
                element.layout_isAlignRightOfAnchor = YES;
            }
            else {
                element.layout_isCenterHorizontalOfAnchor = YES;
            }
            element.layout_gapToBottomOfAnchor = gap;
        }
        [element clearOrigin];
        [element layout];
        lastElement = element;
        [logicalElement addElement:element];
    }
    return logicalElement;
}

+ (BaseElement *)matrix:(NSArray *)elements rowGap:(CGFloat)rGap colGap:(CGFloat)cGap colNum:(NSUInteger)cNum {
    if (!elements || [elements count] == 0) {
        return nil;
    }
    VirtualElement *bElement = [[VirtualElement alloc] initWithFrame:CGRectZero];
    LogicalElement *logicalElement = [Layout logicalElement];
    
    BaseElement *firstElement = [self e:[elements objectAtIndex:0]];
    [firstElement setAnchor:bElement inside:YES];
    firstElement.layout_gapToLeftInAnchor = firstElement.x;
    firstElement.layout_gapToTopInAnchor = firstElement.y;
    [firstElement layout];
    [logicalElement addElement:firstElement];
    
    BaseElement *LineLatestElement = firstElement;
    BaseElement *LineFirstElement = firstElement;
    for (NSUInteger i = 1; i < [elements count]; i ++) {
        BaseElement *element = [self e:[elements objectAtIndex:i]];
        
        NSUInteger mod = i % cNum;
        if (mod == 0) {
            [element setAnchor:LineFirstElement inside:NO];
            element.layout_isBelowAnchor = YES;
            element.layout_isAlignLeftOfAnchor = YES;
            element.layout_gapToBottomOfAnchor = rGap;
            [element clearOrigin];
            [element layout];
            //
            LineFirstElement = element;
            LineLatestElement = element;
        }
        else {
            [element setAnchor:LineLatestElement inside:NO];
            element.layout_isToRightOfAnchor = YES;
            element.layout_isAlignTopOfAnchor = YES;
            element.layout_gapToRightOfAnchor = cGap;
            [element clearOrigin];
            [element layout];
            
            LineLatestElement = element;
        }
        
        [logicalElement addElement:element];
    }
    return logicalElement;
}

+ (void)e:(NSObject *)element inCenter:(NSObject *)anchor {
    BaseElement *beElement = [self e:element];
    BaseElement *beAnchor = [self e:anchor];
    beElement.isSubView = [Layout is:beElement belongToAnchor:beAnchor];
    [beElement setAnchor:beAnchor inside:YES];
    beElement.layout_isCenterInAnchor = YES;
    [beElement clearOrigin];
    [beElement layout];
}

+ (void)e:(NSObject *)element inTopCenter:(NSObject *)anchor gap:(CGFloat)gap {
    BaseElement *beElement = [self e:element];
    BaseElement *beAnchor = [self e:anchor];
    beElement.isSubView = [Layout is:beElement belongToAnchor:beAnchor];
    
    [beElement setAnchor:beAnchor inside:YES];
    beElement.layout_isCenterHorizontalInAnchor = YES;
    beElement.layout_isAlignTopInAnchor = YES;
    beElement.layout_marginTop = gap;
    [beElement clearOrigin];
    [beElement layout];
}

+ (void)e:(NSObject *)element inLeftCenter:(NSObject *)anchor gap:(CGFloat)gap {
    BaseElement *beElement = [self e:element];
    BaseElement *beAnchor = [self e:anchor];
    beElement.isSubView = [Layout is:beElement belongToAnchor:beAnchor];
    
    [beElement setAnchor:beAnchor inside:YES];
    beElement.layout_isCenterVerticalInAnchor = YES;
    beElement.layout_isAlignLeftInAnchor = YES;
    beElement.layout_marginLeft = gap;
    [beElement clearOrigin];
    [beElement layout];
}

+ (void)e:(NSObject *)element inRightCenter:(NSObject *)anchor gap:(CGFloat)gap {
    BaseElement *beElement = [self e:element];
    BaseElement *beAnchor = [self e:anchor];
    beElement.isSubView = [Layout is:beElement belongToAnchor:beAnchor];
    
    [beElement setAnchor:beAnchor inside:YES];
    beElement.layout_isCenterVerticalInAnchor = YES;
    beElement.layout_isAlignRightInAnchor = YES;
    beElement.layout_marginRight = gap;
    [beElement clearOrigin];
    [beElement layout];
}

+ (void)e:(NSObject *)element inBottomCenter:(NSObject *)anchor gap:(CGFloat)gap {
    BaseElement *beElement = [self e:element];
    BaseElement *beAnchor = [self e:anchor];
    beElement.isSubView = [Layout is:beElement belongToAnchor:beAnchor];
    
    [beElement setAnchor:beAnchor inside:YES];
    beElement.layout_isCenterHorizontalInAnchor = YES;
    beElement.layout_isAlignBottomInAnchor = YES;
    beElement.layout_marginBottom = gap;
    [beElement clearOrigin];
    [beElement layout];
}

+ (void)e:(NSObject *)element within:(NSObject *)anchor left:(CGFloat)leftGap top:(CGFloat)topGap {
    BaseElement *bElement = [self e:element];
    BaseElement *bAnchor = [self e:anchor];
    bElement.isSubView = [Layout is:bElement belongToAnchor:bAnchor];
    
    [bElement setAnchor:bAnchor inside:YES];
    bElement.layout_gapToOriginInAnchor = CGPointMake(leftGap, topGap);
    [bElement clearOrigin];
    [bElement layout];
}

+ (void)e:(NSObject *)element within:(NSObject *)anchor left:(CGFloat)leftGap bottom:(CGFloat)bottomGap {
    BaseElement *bElement = [self e:element];
    BaseElement *bAnchor = [self e:anchor];
    bElement.isSubView = [Layout is:bElement belongToAnchor:bAnchor];
    [bElement setAnchor:bAnchor inside:YES];
    
    bElement.layout_gapToBottomInAnchor = bottomGap;
    bElement.layout_gapToLeftInAnchor = leftGap;
    [bElement clearOrigin];
    [bElement layout];
}

+ (void)e:(NSObject *)element within:(NSObject *)anchor right:(CGFloat)rightGap top:(CGFloat)topGap {
    BaseElement *bElement = [self e:element];
    BaseElement *bAnchor = [self e:anchor];
    bElement.isSubView = [Layout is:bElement belongToAnchor:bAnchor];
    [bElement setAnchor:bAnchor inside:YES];
    
    bElement.layout_gapToTopInAnchor = topGap;
    bElement.layout_gapToRightInAnchor = rightGap;
    [bElement clearOrigin];
    [bElement layout];
}

+ (void)e:(NSObject *)element within:(NSObject *)anchor right:(CGFloat)rightGap bottom:(CGFloat)bottomGap {
    BaseElement *bElement = [self e:element];
    BaseElement *bAnchor = [self e:anchor];
    bElement.isSubView = [Layout is:bElement belongToAnchor:bAnchor];
    [bElement setAnchor:bAnchor inside:YES];
    
    bElement.layout_gapToBottomInAnchor = bottomGap;
    bElement.layout_gapToRightInAnchor = rightGap;
    [bElement clearOrigin];
    [bElement layout];
}


@end
