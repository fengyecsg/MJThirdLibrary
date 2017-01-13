
//  LayoutElement.h
//  ArrangeUnitTest
//  Created by LiuChao on 2013.12
//  Copyright (c) 2013 LiuChao All rights reserved.

#import <Foundation/Foundation.h>

//static const int PROP_LABEL_SIZETOFIT = 0x1;
//static const int PROP_LABEL_EDGEINSET = 0x2;
//static const int PROP_LABEL_AUTOSIZE = 0x1 | 0x2;

typedef NS_OPTIONS(NSUInteger, LayoutOptions) {
    LayoutNoSizeToFit = 1 << 0,
    LayoutNoEdgeInset = 1 << 1,
};



typedef enum{
    //out
    ElementAlignTop,
    ElementAlignBottom,
    ElementAlignLeft,
    ElementAlignRight,
    ElementAlignVerticalCenter,
    ElementAlignHorizontalCenter,
    
    //in
    ElementAlignTopCenter,
    ElementAlignBottomCenter,
    ElementAlignLeftCenter,
    ElementAlignRightCenter,
    ElementAlignCenter,    
}ElementAlign;

/*-------------------------------------基本元素-------------------------------------*/
@interface BaseElement : NSObject{
    //    CGRect _frame;
    //    CGPoint _origin;
    CGFloat _x;
    CGFloat _y;
    CGFloat _width;
    CGFloat _height;
}

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

/**
 assign positive value:在逻辑上增加一个透明的边缘
 assign negative value:在逻辑上减去一个边缘，margin参与布局
 */
@property (nonatomic, assign) CGFloat layout_marginLeft;
@property (nonatomic, assign) CGFloat layout_marginRight;
@property (nonatomic, assign) CGFloat layout_marginTop;
@property (nonatomic, assign) CGFloat layout_marginBottom;

/**
 左等距居中，离top、left、bottom的距离相等
 右等距居中，离top、right、bottom的距离相等
 顶等距居中，离top、left、right的距离相等
 底等距居中，离right、left、bottom的距离相等
 */
@property (nonatomic, assign) Boolean layout_isLeftEquidistantInAnchor;
@property (nonatomic, assign) Boolean layout_isRightEquidistantInAnchor;
@property (nonatomic, assign) Boolean layout_isTopEquidistantInAnchor;
@property (nonatomic, assign) Boolean layout_isBottomEquidistantInAnchor;

/**
 垂直 居中
 水平 居中
 居中
 */
@property (nonatomic, assign) Boolean layout_isCenterHorizontalInAnchor;
@property (nonatomic, assign) Boolean layout_isCenterVerticalInAnchor;
@property (nonatomic, assign) Boolean layout_isCenterInAnchor;

/**
 离 左/右/上/下 边缘的间距
 */
@property (nonatomic, assign) CGPoint layout_gapToOriginInAnchor;
@property (nonatomic, assign) CGFloat layout_gapToLeftInAnchor;
@property (nonatomic, assign) CGFloat layout_gapToRightInAnchor;
@property (nonatomic, assign) CGFloat layout_gapToTopInAnchor;
@property (nonatomic, assign) CGFloat layout_gapToBottomInAnchor;

/**
 填充 内部/顶部/底部/左部/右部
 */
@property (nonatomic, assign) Boolean layout_isFullOfAnchor;
@property (nonatomic, assign) Boolean layout_isFullOfAnchorTop;
@property (nonatomic, assign) Boolean layout_isFullOfAnchorBottom;
@property (nonatomic, assign) Boolean layout_isFullOfAnchorLeft;
@property (nonatomic, assign) Boolean layout_isFullOfAnchorRight;

/**
 内部对齐 Top/Bottom/Left/Right
 */
@property (nonatomic, assign) Boolean layout_isAlignTopInAnchor;
@property (nonatomic, assign) Boolean layout_isAlignBottomInAnchor;
@property (nonatomic, assign) Boolean layout_isAlignLeftInAnchor;
@property (nonatomic, assign) Boolean layout_isAlignRightInAnchor;

/**
 外部 左/右/上/下
 */
@property (nonatomic, assign) Boolean layout_isToLeftOfAnchor;
@property (nonatomic, assign) Boolean layout_isToRightOfAnchor;
@property (nonatomic, assign) Boolean layout_isAboveAnchor;
@property (nonatomic, assign) Boolean layout_isBelowAnchor;

/**
 外部 左/右/上/下 对齐
 */
@property (nonatomic, assign) Boolean layout_isAlignTopOfAnchor;
@property (nonatomic, assign) Boolean layout_isAlignBottomOfAnchor;
@property (nonatomic, assign) Boolean layout_isAlignLeftOfAnchor;
@property (nonatomic, assign) Boolean layout_isAlignRightOfAnchor;

@property (nonatomic, assign) Boolean layout_isCenterHorizontalOfAnchor;
@property (nonatomic, assign) Boolean layout_isCenterVerticalOfAnchor;
/**
 外部 离锚元素 右/左/顶/底 的间距
 */
@property (nonatomic, assign) CGFloat layout_gapToRightOfAnchor;
@property (nonatomic, assign) CGFloat layout_gapToLeftOfAnchor;
@property (nonatomic, assign) CGFloat layout_gapToTopOfAnchor;
@property (nonatomic, assign) CGFloat layout_gapToBottomOfAnchor;

@property (nonatomic, assign) BOOL isSubView;

@property (nonatomic, assign) NSUInteger properties;
- (BOOL)supportProperty:(NSInteger)p;
- (void)addProperty:(NSInteger)p;
- (void)clearOrigin;

/**
 作用：进行布局
 */
-(void)layout;
/**
 设置锚元素
 */
- (void)setAnchor:(BaseElement *)anchor inside:(BOOL)inside;
@end


/*-------------------------------------逻辑元素-------------------------------------*/
@interface LogicalElement : BaseElement

/**
 作用：添加逻辑元素的子元素
 */
-(void)addElement: (BaseElement *)element;
-(UIView *)searchViewInDepthFirst;

@end

/*-------------------------------------虚构元素-------------------------------------*/
@interface VirtualElement : BaseElement

-(id)initWithFrame:(CGRect)rect;

@end

/*-------------------------------------实体元素-------------------------------------*/
@interface ActualElement : BaseElement

//元素内容, 实际控件UIView
@property (nonatomic, strong) UIView *content;

- (void)setContent:(UIView *)content;

@end
