
//  LayoutElement.m

#import "LayoutElement.h"
#import <QuartzCore/QuartzCore.h>

/*-------------------------------------基本元素-------------------------------------*/
@interface BaseElement()

//锚元素
@property (nonatomic, strong) BaseElement *anchor;
//是否在锚元素内部
@property (nonatomic, assign) Boolean isInside;

/*
 作用：重置边缘
 */
-(void)clearMargin;
/*
 作用：初始化属性
 */
-(void)initProperty;

-(void)initFrame;

//是否产生边缘修正，默认修正
@property (nonatomic, assign) BOOL isGenLeftEdgeInset;
@property (nonatomic, assign) BOOL isGenRightEdgeInset;
@property (nonatomic, assign) BOOL isGenTopEdgeInset;
@property (nonatomic, assign) BOOL isGenBottomEdgeInset;
//根据元素内容产生的边缘修正值，为正值，例:edgeInsetLeft＝5,元素会向左产生5个point的位移
@property (nonatomic, assign) CGFloat edgeInsetLeft;
@property (nonatomic, assign) CGFloat edgeInsetRight;
@property (nonatomic, assign) CGFloat edgeInsetTop;
@property (nonatomic, assign) CGFloat edgeInsetBottom;
@property (nonatomic, assign) Boolean hasInitFrame;

@end

@implementation BaseElement

-(id)init{
    if (self = [super init]) {
        //初始化属性
        [self initProperty];
        self.isSubView = NO;
        
    }
    return self;
}

-(void)dealloc{
    
}

-(void)setLayout_gapToOriginInAnchor:(CGPoint)layout_gapToOriginInAnchor {
    self.layout_gapToLeftInAnchor = layout_gapToOriginInAnchor.x;
    self.layout_gapToTopInAnchor = layout_gapToOriginInAnchor.y;
}

- (void)setAnchor:(BaseElement *)anchor inside:(BOOL)inside {
    self.anchor = anchor;
    self.isInside = inside;
}

- (void)setGenEdgeInset:(BOOL)genEdgeInset {
    self.isGenTopEdgeInset = genEdgeInset;
    self.isGenBottomEdgeInset = genEdgeInset;
    self.isGenLeftEdgeInset = genEdgeInset;
    self.isGenRightEdgeInset = genEdgeInset;
}

-(void)initProperty{
    self.anchor = nil;
    self.isInside = false;
    
    self.layout_isLeftEquidistantInAnchor = false;
    self.layout_isRightEquidistantInAnchor = false;
    self.layout_isTopEquidistantInAnchor = false;
    self.layout_isBottomEquidistantInAnchor = false;
    
    self.layout_isCenterHorizontalInAnchor = false;
    self.layout_gapToLeftInAnchor = -1;
    self.layout_gapToRightInAnchor = -1;
    
    self.layout_isCenterVerticalInAnchor = false;
    self.layout_gapToTopInAnchor = -1;
    self.layout_gapToBottomInAnchor = -1;
    
    self.layout_isToLeftOfAnchor = false;
    self.layout_isToRightOfAnchor = false;
    self.layout_isAboveAnchor = false;
    self.layout_isBelowAnchor = false;
    
    self.layout_gapToRightOfAnchor = 0;
    self.layout_gapToLeftOfAnchor = 0;
    self.layout_gapToTopOfAnchor = 0;
    self.layout_gapToBottomOfAnchor = 0;
    
    [self clearMargin];
}

//- (CGFloat)layout_gapToRightInAnchor {
//    if (_layout_gapToRightInAnchor == -1) {
//        return 0;
//    }
//    return _layout_gapToRightInAnchor;
//}

//- (CGFloat)layout_gapToLeftInAnchor {
//    if (_layout_gapToLeftInAnchor == -1) {
//        return 0;
//    }
//    return _layout_gapToLeftInAnchor;
//}

//- (CGFloat)layout_gapToTopInAnchor {
//    if (_layout_gapToTopInAnchor == -1) {
//        return 0;
//    }
//    return _layout_gapToTopInAnchor;
//}

//- (CGFloat)layout_gapToBottomInAnchor {
//    if (_layout_gapToBottomInAnchor == -1) {
//        return 0;
//    }
//    return _layout_gapToBottomInAnchor;
//}

-(void)clearMargin{
    self.layout_marginLeft = 0;
    self.layout_marginRight = 0;
    self.layout_marginTop = 0;
    self.layout_marginBottom = 0;
}

- (CGFloat)width {
    //abstract
    return 0;
}

- (CGFloat)height {
    //abstract
    return 0;
}

- (void)setX:(CGFloat)x {
    //abstract
}
- (void)setY:(CGFloat)y {
    //abstract
}

-(void)initFrame{
    //abstract method
}

- (BOOL)supportProperty:(NSInteger)p {
	return (self.properties & p)> 0;
}

- (void)addProperty:(NSInteger)p {
    self.properties = self.properties | p;
}

- (void)clearOrigin {
    //abstract
}

-(void)layout{
    if (nil == self.anchor) {
        return;
    }
    [self initFrame];
    //    NSLog(@"layout beforeLayOut anchor.Frame: %f %f %f %f self.Frame: %f %f %f %f", self.anchor.x, self.anchor.y, self.anchor.width, self.anchor.height, self.x, self.y, self.width, self.height);
    //inner
    if (self.isInside) {
        CGFloat anchorX = self.anchor.x;
        CGFloat anchorY = self.anchor.y;
        if (self.isSubView) {
            anchorX = 0.0f;
            anchorY = 0.0f;
        }
        
        if (self.layout_isLeftEquidistantInAnchor) {
            CGFloat distance = (self.anchor.height - self.height) / 2;
            self.x = anchorX + distance;
            self.y = anchorY + distance;
        }
        else if (self.layout_isRightEquidistantInAnchor){
            CGFloat distance = (self.anchor.height - self.height) / 2;
            CGFloat xRPos = self.anchor.width - distance - self.width;
            self.x = anchorX + xRPos;
            self.y = anchorY + distance;
        }
        else if (self.layout_isTopEquidistantInAnchor){
            CGFloat distance = (self.anchor.width - self.width) / 2;
            self.x = anchorX + distance;
            self.y = anchorY + distance;
        }
        else if (self.layout_isBottomEquidistantInAnchor){
            CGFloat distance = (self.anchor.width - self.width) / 2;
            CGFloat yRPos = self.anchor.height - distance - self.height;
            self.x = anchorX + distance;
            self.y = anchorY + yRPos;
        }
        else if (self.layout_isCenterHorizontalInAnchor){
            CGFloat distance = (self.anchor.width - self.width) / 2;
            CGFloat yRPos = 0;
            if (self.layout_gapToTopInAnchor != -1) {
                yRPos = self.layout_gapToTopInAnchor;
            }
            else if (self.layout_gapToBottomInAnchor != -1) {
                yRPos = self.anchor.height - self.height - self.layout_gapToBottomInAnchor;
            }
            else if (self.layout_isAlignBottomInAnchor) {
                yRPos = self.anchor.height - self.height;
            }
            else if (self.layout_isAlignTopInAnchor) {
                yRPos = self.layout_marginTop;
            }
            
            self.x = anchorX + distance;
            self.y = anchorY + yRPos;
        }
        else if (self.layout_isCenterVerticalInAnchor){
            CGFloat distance = (self.anchor.height - self.height) / 2;;
            self.y = anchorY + distance;
            
            CGFloat xRPos = 0;
            if (self.layout_gapToLeftInAnchor != -1) {
                xRPos = self.layout_gapToLeftInAnchor;
            }
            else if (self.layout_gapToRightInAnchor != -1) {
                xRPos = self.anchor.width - self.width - self.layout_gapToRightInAnchor;
            }
            else if (self.layout_isAlignLeftInAnchor) {
                xRPos = self.layout_gapToLeftInAnchor;
            }
            else if (self.layout_isAlignRightInAnchor) {
                xRPos = self.anchor.width - self.width;
            }
            self.x = anchorX + xRPos;
            
        }
        else if (self.layout_isFullOfAnchor) {
            //not implementation yet
        }
        else if (self.layout_isFullOfAnchorTop) {
            //not implementation yet
        }
        else if (self.layout_isFullOfAnchorBottom) {
            //not implementation yet
        }
        else if (self.layout_isFullOfAnchorLeft) {
            //not implementation yet
        }
        else if (self.layout_isFullOfAnchorRight) {
            //not implementation yet
        }
        else if (self.layout_isAlignRightInAnchor) {
            //not implementation yet
            self.x = anchorX + self.anchor.width - self.width;
            self.y = anchorY + self.layout_gapToTopInAnchor; //self.anchor.height / 2;
        }
        else if (self.layout_isCenterInAnchor) {
            CGFloat xDistance = (self.anchor.width - self.width) / 2;
            self.x = anchorX + xDistance;
            CGFloat yDistance = (self.anchor.height - self.height) / 2;;
            self.y = anchorY + yDistance;
        }
        //指定距离
        else {
            if (self.layout_gapToRightInAnchor != -1) {
                self.x = anchorX + self.anchor.width - self.width - self.layout_gapToRightInAnchor;
            }
            else {
                self.x = anchorX + self.layout_gapToLeftInAnchor;
            }
            
            if (self.layout_gapToBottomInAnchor != -1) {
                self.y = anchorY + self.anchor.height - self.height - self.layout_gapToBottomInAnchor;
            }
            else {
                self.y = anchorY + self.layout_gapToTopInAnchor;
            }
        }
    }
    //outer
    else{
        if (self.layout_isToLeftOfAnchor) {
            if (self.layout_isAlignTopOfAnchor) {
                self.x = self.anchor.x - self.layout_gapToLeftOfAnchor - self.width;
                self.y = self.anchor.y;
            }
            else if (self.layout_isAlignBottomOfAnchor) {
                CGFloat yRPos = self.anchor.height - self.height;
                self.x = self.anchor.x - self.layout_gapToLeftOfAnchor - self.width;
                self.y = self.anchor.y + yRPos;
            }
            else if (self.layout_isCenterVerticalOfAnchor) {
                CGFloat yRPos = (self.anchor.height - self.height) / 2;
                self.x = self.anchor.x - self.layout_gapToLeftOfAnchor - self.width;
                self.y = self.anchor.y + yRPos;
            }
        }
        else if (self.layout_isToRightOfAnchor) {
            if (self.layout_isAlignTopOfAnchor) {
                self.x = self.anchor.x + self.anchor.width + self.layout_gapToRightOfAnchor;
                self.y = self.anchor.y + self.layout_marginTop;
            }
            else if (self.layout_isAlignBottomOfAnchor) {
                CGFloat yRPos = self.anchor.height - self.height - self.layout_marginBottom;
                self.x = self.anchor.x + self.anchor.width + self.layout_gapToRightOfAnchor;
                self.y = self.anchor.y + yRPos;
            }
            else if (self.layout_isCenterVerticalOfAnchor) {
                CGFloat yRPos = (self.anchor.height - self.height) / 2;
                self.x = self.anchor.x + self.anchor.width + self.layout_gapToRightOfAnchor;
                self.y = self.anchor.y + yRPos;
            }
        }
        else if (self.layout_isAboveAnchor) {
            if (self.layout_isAlignLeftOfAnchor) {
                self.x = self.anchor.x;
                self.y = self.anchor.y - self.layout_gapToTopOfAnchor - self.height;
            }
            else if (self.layout_isAlignRightOfAnchor) {
                CGFloat xRPos = self.anchor.width - self.width;
                self.x = self.anchor.x + xRPos;
                self.y = self.anchor.y - self.layout_gapToTopOfAnchor - self.height;
            }
            else if (self.layout_isCenterHorizontalOfAnchor) {
                CGFloat xRPos = (self.anchor.width - self.width) / 2;
                self.x = self.anchor.x + xRPos;
                self.y = self.anchor.y - self.layout_gapToTopOfAnchor - self.height;
            }
        }
        else if (self.layout_isBelowAnchor) {
            if (self.layout_isAlignLeftOfAnchor) {
                self.x = self.anchor.x;
                self.y = self.anchor.y + self.anchor.height + self.layout_gapToBottomOfAnchor;
            }
            else if (self.layout_isAlignRightOfAnchor) {
                CGFloat xRPos = self.anchor.width - self.width;
                self.x = self.anchor.x + xRPos;
                self.y = self.anchor.y + self.anchor.height + self.layout_gapToBottomOfAnchor;
            }
            else if (self.layout_isCenterHorizontalOfAnchor) {
                CGFloat xRPos = (self.anchor.width - self.width) / 2;
                self.x = self.anchor.x + xRPos;
                self.y = self.anchor.y + self.anchor.height + self.layout_gapToBottomOfAnchor;
            }
        }
    }
    //    NSLog(@"layout beforeLayOut anchor.Frame: %f %f %f %f self.Frame: %f %f %f %f", self.anchor.x, self.anchor.y, self.anchor.width, self.anchor.height, self.x, self.y, self.width, self.height);
}

@end

/*-------------------------------------逻辑元素-------------------------------------*/
@interface LogicalElement()
{
    NSMutableArray *elementArray;
}

//所有元素中的最小x坐标值
@property (nonatomic, assign) CGFloat minX;
//所有元素中的最大x坐标值
@property (nonatomic, assign) CGFloat maxX;
//所有元素最小y坐标值
@property (nonatomic, assign) CGFloat minY;
//所有元素最大y坐标值
@property (nonatomic, assign) CGFloat maxY;
@property (nonatomic, assign) BOOL hasMarginX;
@property (nonatomic, assign) BOOL hasMarginY;
/*
 作用：初始化属性
 */
-(void)initProperty;

-(void)initFrame;

@end

@implementation LogicalElement

-(id)init{
    if (self = [super init]) {
        elementArray = [[NSMutableArray alloc] init];
        _hasMarginX = NO;
        _hasMarginY = NO;
        [self initProperty];
    }
    return self;
}

-(void)dealloc{
    [elementArray removeAllObjects];
}

-(void)initProperty{
    [super initProperty];
    self.minX = MAXFLOAT;
    self.maxX = - MAXFLOAT;
    self.minY = MAXFLOAT;
    self.maxY = - MAXFLOAT;
}

- (CGFloat)width {
    return self.maxX - self.minX + self.layout_marginLeft + self.layout_marginRight;
}

- (CGFloat)height {
    return self.maxY - self.minY + self.layout_marginTop + self.layout_marginBottom;
}

- (void)setX:(CGFloat)x {
    CGFloat deltaX = x - self.x;
    if (!self.hasMarginX) {
        deltaX += self.layout_marginLeft;
        self.hasMarginX = YES;
    }
    for (NSUInteger i = 0; i < [elementArray count]; i ++) {
        BaseElement *element = [elementArray objectAtIndex:i];
        element.x = element.x + deltaX;
    }
    _x = x;
}

- (void)setY:(CGFloat)y {
    CGFloat deltaY = y - self.y;
    if (!self.hasMarginY) {
        deltaY += self.layout_marginTop;
        self.hasMarginY = YES;
    }
    for (NSUInteger i = 0; i < [elementArray count]; i ++) {
        BaseElement *element = [elementArray objectAtIndex:i];
        element.y = element.y + deltaY;
    }
    _y = y;
}


-(void)addElement: (BaseElement *)element{
    if (!element) {
        return;
    }
    //保存元素
    [elementArray addObject:element];
    //x坐标最小值
    self.minX = fmin(self.minX, element.x);
    //x坐标最大值
    self.maxX = fmax(self.maxX, element.x + element.width);
    //y坐标最小值
    self.minY = fmin(self.minY, element.y);
    //y坐标最大值
    self.maxY = fmax(self.maxY, element.y + element.height);
    //确定最新的覆盖区域
    _x = self.minX;
    _y = self.minY;
    //_frame = CGRectMake(self.minX, self.minY, self.maxX - self.minX, self.maxY - self.minY);
}

-(UIView *)searchViewInDepthFirst {
    for (NSUInteger i = 0; i < [elementArray count]; i++) {
        BaseElement *e = [elementArray objectAtIndex:i];
        if ([e isKindOfClass:[ActualElement class]]) {
            return ((ActualElement *)e).content;
        }
        if ([e isKindOfClass:[LogicalElement class]]) {
            return [((LogicalElement *)e) searchViewInDepthFirst];
        }
    }
    return nil;
}

-(void)initFrame{
    //todo
}

- (void)clearOrigin {
    self.x = 0;
    self.y = 0;
}

@end

/*-------------------------------------虚构元素-------------------------------------*/
@implementation VirtualElement

- (CGFloat)width {
    return _width;
}

- (CGFloat)height {
    return _height;
}

- (void)setX:(CGFloat)x {
    _x = x;
}
- (void)setY:(CGFloat)y {
    _y = y;
}

-(void)initFrame{
    //abstract method
}

-(id)initWithFrame:(CGRect)rect {
    if (self = [super init]) {
        _x = rect.origin.x;
        _y = rect.origin.y;
        _width = rect.size.width;
        _height = rect.size.height;
    }
    return self;
}

@end

/*-------------------------------------真实元素-------------------------------------*/
@interface ActualElement()

/*
 作用：重置边缘修正值
 */
-(void)clearEdgeInset;

-(void)initFrame;

@end

@implementation ActualElement

-(id)init{
    if (self = [super init]) {
        //初始化属性
        self.hasInitFrame = false;
        [self clearEdgeInset];
        //Modified by liuchao for weatherStation proj
        self.properties = 0;
        
    }
    return self;
}

-(void)dealloc{
    
}

- (void)setContent:(UIView *)content {
    self.x = content.frame.origin.x;
    self.y = content.frame.origin.y;
    _content = content;
    //    DLOG(@"%@", NSStringFromCGRect(content.frame))
}


-(void)clearEdgeInset{
    self.edgeInsetLeft = 0;
    self.edgeInsetRight = 0;
    self.edgeInsetTop = 0;
    self.edgeInsetBottom = 0;
    
    [self setGenEdgeInset:YES];
}

- (CGFloat)width {
    return self.content.frame.size.width + self.layout_marginLeft + self.layout_marginRight - self.edgeInsetLeft - self.edgeInsetRight;
}

- (CGFloat)height {
    return self.content.frame.size.height + self.layout_marginTop + self.layout_marginBottom - self.edgeInsetTop - self.edgeInsetBottom;
}

- (void)setX:(CGFloat)x {
    CGFloat xPos = x + self.layout_marginLeft - self.edgeInsetLeft;
    self.content.frame = CGRectMake(xPos, self.content.frame.origin.y, self.content.frame.size.width, self.content.frame.size.height);
    _x = x;
}

- (void)setY:(CGFloat)y {
    CGFloat yPos = y + self.layout_marginTop - self.edgeInsetTop;
    self.content.frame = CGRectMake(self.content.frame.origin.x, yPos, self.content.frame.size.width, self.content.frame.size.height);
    _y = y;
}

-(BOOL)pixelIsVisibleByR:(int)R G:(int)G B:(int)B {
    int nVisble = 0;
//    DLOG(@"%d %d  %d", R, G, B)
    if (R > 230) {
        nVisble++;
    }
    if (G > 230) {
        nVisble++;
    }
    if (B > 230) {
        nVisble++;
    }
    return nVisble < 2;
}

-(void)initFrame{
    if (self.content) {
//        return;///////
        if ([self.content isKindOfClass:[UILabel class]]) {
            UILabel *lbl = (UILabel*)self.content;
            //nil 或 @"" 时，取出的是无效图片
            if ((lbl.text != nil) && (![lbl.text isEqualToString: @""])) {
                //还原真实大小，如果设置了自动伸缩，就可能因为frames设置过小而得不到指定字号
                CGRect oriRect = lbl.frame;
                BOOL hasFit = NO;
                if (!lbl.adjustsFontSizeToFitWidth) {
                    if (oriRect.size.width == 0 || oriRect.size.height == 0) {
//                        [lbl adjustLabelSizeWithMinimumFontSize:0];
                        [lbl sizeToFit];
                        oriRect = lbl.frame;
                        hasFit = YES;
                    }
                    if (![self supportProperty:LayoutNoSizeToFit]) {
                        if (!hasFit) {
//                            [lbl adjustLabelSizeWithMinimumFontSize:0];
                            [lbl sizeToFit];
                            oriRect = lbl.frame;
                            hasFit = YES;
                        }
                    }
                }
                if (![self supportProperty:LayoutNoEdgeInset]) {
                    if (!hasFit && !lbl.adjustsFontSizeToFitWidth) {
//                        [lbl adjustLabelSizeWithMinimumFontSize:0];
                        [lbl sizeToFit];
                    }
                    //NSLog(@"%f  ,  %f", lbl.frame.size.width, lbl.frame.size.height);
                    if (lbl.frame.size.width != 0 && lbl.frame.size.height != 0) {
                        //白色背景黑色字体进行计算
                        UIColor *oriFontColor = lbl.textColor;
                        lbl.textColor = [UIColor blackColor];
                        
                        UIColor *oriBkColor = lbl.backgroundColor;
                        lbl.backgroundColor = [UIColor whiteColor];
                        UIView *subView = lbl;
                        
                        CGRect rect = subView.frame;
                        subView.frame = CGRectMake(rect.origin.x, rect.origin.y, ceil(rect.size.width), ceil(rect.size.height));
                        UIGraphicsBeginImageContext(subView.frame.size);
                        [subView.layer renderInContext:UIGraphicsGetCurrentContext()];
                        UIImage *imageShot = UIGraphicsGetImageFromCurrentImageContext();
                        UIGraphicsEndImageContext();
                        
                        CGImageRef cgImage = [imageShot CGImage];
                        CGDataProviderRef provider = CGImageGetDataProvider(cgImage);
                        if (!provider) {
                            return;
                        }
                        CFDataRef bitmapData = CGDataProviderCopyData(provider);
                        
                        const UInt8* data;
                        
                        data = CFDataGetBytePtr(bitmapData);
                        size_t bytesPerRow = CGImageGetBytesPerRow(cgImage);
                        size_t imgWidth = CGImageGetWidth(cgImage);
                        size_t imgHeight = CGImageGetHeight(cgImage);
                        size_t bpp = CGImageGetBitsPerPixel(cgImage);
                        size_t bpc = CGImageGetBitsPerComponent(cgImage);
                        size_t bytes_per_pixel = bpp / bpc;
                        bool bFind;
                        
                        if (self.isGenLeftEdgeInset) {
                            //寻找最左边黑色像素,左方调整边距
                            bFind = false;
                            for (int col = 0; col < imgWidth; col++){
                                for (int row = 0; row < imgHeight; row++){
                                    const UInt8* pixel = data + row * bytesPerRow + col * bytes_per_pixel;
                                    if (![self pixelIsVisibleByR:pixel[0] G:pixel[1] B:pixel[2]]) {
                                        continue;
                                    }
                                    self.edgeInsetLeft = col;
                                    bFind = true;
                                    break;
                                }
                                if (bFind) {
                                    break;
                                }
                            }
                        }
                        if (self.isGenRightEdgeInset) {
                            //右方调整边距
                            bFind = false;
                            int imgW = (int)imgWidth;
                            for (int col = imgW - 1; col >= 0; col--) {
                                for (int row = 0; row < imgHeight; row++){
                                    const UInt8* pixel = data + row * bytesPerRow + col * bytes_per_pixel;
                                    if (![self pixelIsVisibleByR:pixel[0] G:pixel[1] B:pixel[2]]) {
                                        continue;
                                    }
                                    self.edgeInsetRight = imgWidth + 1 - (col + 1);
                                    bFind = true;
                                    break;
                                }
                                if (bFind) {
                                    break;
                                }
                            }
                        }
                        if (self.isGenTopEdgeInset) {
                            //上方调整边距
                            bFind = false;
                            for (int row = 0; row < imgHeight; row++) {
                                for (int col = 0; col < imgWidth; col++) {
                                    const UInt8* pixel = data + row * bytesPerRow + col * bytes_per_pixel;
                                    if (![self pixelIsVisibleByR:pixel[0] G:pixel[1] B:pixel[2]]) {
                                        continue;
                                    }
                                    self.edgeInsetTop = row;
                                    bFind = true;
                                    break;
                                }
                                if (bFind) {
                                    break;
                                }
                            }
                        }
                        if (self.isGenBottomEdgeInset) {
                            //下方调整边距
                            bFind = false;
                            int imgH = (int)imgHeight;
                            for (int row = imgH - 1; row >= 0; row--) {
                                for (int col = 0; col < imgWidth; col++) {
                                    const UInt8* pixel = data + row * bytesPerRow + col * bytes_per_pixel;
                                    if (![self pixelIsVisibleByR:pixel[0] G:pixel[1] B:pixel[2]]) {
                                        continue;
                                    }
                                    self.edgeInsetBottom = imgHeight - (row + 1);
                                    bFind = true;
                                    break;
                                }
                                if (bFind) {
                                    break;
                                }
                            }
                        }
                        //还原字体、背景色
                        lbl.backgroundColor = oriBkColor;
                        lbl.textColor = oriFontColor;
                        //释放
                        CFRelease(bitmapData);
                        //
                        if ([self supportProperty:LayoutNoSizeToFit]) {
                            lbl.frame = oriRect;
                        }
                        
                    }
                   
                }
            }
        }
    }
}

@end
