//
// REActivityView.h
// REActivityViewController
//
// Copyright (c) 2013 Roman Efimov (https://github.com/romaonthego)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "REActivityView.h"
#import "REActivityViewController.h"

#ifdef __IPHONE_6_0 // iOS6 and later
#   define NSTextAlignmentCenter    NSTextAlignmentCenter
#   define NSTextAlignmentLeft      NSTextAlignmentLeft
#   define NSTextAlignmentRight     NSTextAlignmentRight
#   define UILineBreakModeTailTruncation     NSLineBreakByTruncatingTail
#   define UILineBreakModeMiddleTruncation   NSLineBreakByTruncatingMiddle
#endif

@implementation REActivityView

- (id)initWithFrame:(CGRect)frame activities:(NSArray *)activities setActivities:(NSArray *)setArr
{    
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        _activities = activities;
        _settingActivites = setArr;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, (IS_IPHONE_5)? 517 :417)];
//            _backgroundImageView.image = [UIImage imageNamed:@"REActivityViewController.bundle/Background"];
//             UIImage *backImage = [UIImage imageNamed:@"share_view_background.png"];
//            backImage = [backImage stretchableMiddleImage];
//            _backgroundImageView.image = backImage;
            _backgroundImageView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9];
            _backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            [self addSubview:_backgroundImageView];
        }
    
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 19, frame.size.width, self.frame.size.height - 50)];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollView.scrollsToTop = NO;
        [self addSubview:_scrollView];
        if (setArr != nil && setArr.count > 0) {
            _scrollView.frame = CGRectMake(0, 19, frame.size.width, self.frame.size.height - 171);
            
            _settingView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 171, SCREEN_WIDTH, 121)];
            _settingView.backgroundColor = [UIColor clearColor];
            [self addSubview:_settingView];
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
            lineView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.35];
            [_settingView addSubview:lineView];
            
            _settingSV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 21, SCREEN_WIDTH, 100)];
            _settingSV.backgroundColor = [UIColor clearColor];
            _settingSV.showsHorizontalScrollIndicator = NO;
            _settingSV.showsVerticalScrollIndicator = NO;
            _settingSV.delegate = self;
            _settingSV.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            _settingSV.scrollsToTop = NO;
            [_settingView addSubview:_settingSV];
            
            int page = 0;
            for (int i = 0; i < _settingActivites.count ; i ++) {
                REActivity *act = [_settingActivites objectAtIndex:i];
                NSInteger index = _activities.count;
                if (i % 3 == 0) {
                    page ++;
                }
                UIView *view = [self viewForActivity:act index:index + i  x:13 + i*80 + i*27 y:0 ];
                [_settingSV addSubview:view];
            }
            _settingSV.contentSize = CGSizeMake(page * frame.size.width, _settingSV.frame.size.height);
            _settingSV.pagingEnabled = YES;
        }
        
        
        NSInteger index = 0;
        NSInteger row = -1;
        NSInteger page = -1;
        for (REActivity *activity in _activities) {
            NSInteger col;
            
            col = index % 3;
            if (index % 3 == 0) row++;
            if (IS_IPHONE_5) {
                if (index % 12 == 0) {
                    row = 0;
                    page++;
                }
            } else {
                if (index % 9 == 0) {
                    row = 0;
                    page++;
                }
            }

            UIView *view = [self viewForActivity:activity
                                           index:index
                                               x:(13 + col*80 + col*27) + page * frame.size.width
                                               y:row*80 + row*20];
            [_scrollView addSubview:view];
            index++;
        }
        _scrollView.contentSize = CGSizeMake((page +1) * frame.size.width, _scrollView.frame.size.height);
        _scrollView.pagingEnabled = YES;
        
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, frame.size.height - 84, frame.size.width, 10)];
        _pageControl.numberOfPages = page + 1;
        [_pageControl addTarget:self action:@selector(pageControlValueChanged:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_pageControl];
        
        if (_pageControl.numberOfPages <= 1) {
            _pageControl.hidden = YES;
            _scrollView.scrollEnabled = NO;
        }

        _cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_cancelButton addTarget:self action:@selector(cancelButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [_cancelButton setTitle:NSLocalizedString(@"cancel", @"") forState:UIControlStateNormal];
        _cancelButton.titleEdgeInsets = UIEdgeInsetsZero;
        _cancelButton.frame = CGRectMake(22, 345, 276, 47);
        [_cancelButton.titleLabel setFont:[UIFont systemFontOfSize:23]];

        [self addSubview:_cancelButton];
    }
    return self;
}

- (UIView *)viewForActivity:(REActivity *)activity index:(NSInteger)index x:(NSInteger)x y:(NSInteger)y
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(x, y, 80, 80)];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, 0, 60, 60);
    button.tag = index;
    [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:activity.image forState:UIControlStateNormal];
    [button setBackgroundImage:activity.hightedImage forState:UIControlStateHighlighted];
    button.accessibilityLabel = activity.title;
    [view addSubview:button];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 65, 80, 30)];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
//    label.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75];
//    label.shadowOffset = CGSizeMake(0, 1);
    label.text = activity.title;
    label.font = [UIFont systemFontOfSize:12];
    label.numberOfLines = 0;
    [label setNumberOfLines:0];
    [label sizeToFit];
    CGRect frame = label.frame;
    frame.origin.x = roundf((view.frame.size.width - frame.size.width) / 2.0f);
    label.frame = frame;
    [view addSubview:label];
    
    return view;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        // For iPhone and iPod
        CGRect scrollViewFrame = _scrollView.frame;
        CGRect cancelButtonFrame = _cancelButton.frame;
        UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        
        if (UIInterfaceOrientationIsPortrait(interfaceOrientation)) {
            scrollViewFrame.origin.y = 19;
            
            cancelButtonFrame.size.width = 276;
            cancelButtonFrame.origin.x = (self.frame.size.width - cancelButtonFrame.size.width) / 2.0f;
        } else {
            scrollViewFrame.origin.y = 29;
            
            cancelButtonFrame.size.width = 236;
            cancelButtonFrame.origin.x = (self.frame.size.width - cancelButtonFrame.size.width) / 2.0f;
        }
        
        cancelButtonFrame.origin.y = self.frame.size.height - 50;
        _scrollView.frame = scrollViewFrame;
        _cancelButton.frame = cancelButtonFrame;
        
        NSInteger index = 0;
        NSInteger row = -1;
        NSInteger page = -1;
        for (UIView *view in [_scrollView subviews]) {
            NSInteger col;
            CGRect frame = view.frame;
            int num = 3;
            if (UIInterfaceOrientationIsPortrait(interfaceOrientation)) {
                
                
                CGFloat viewWidth = frame.size.width;
                CGFloat interval = (SCREEN_WIDTH - (viewWidth*num))/(num+1);
                
                col = index%num;
                if (index % num == 0) row++;
                if (IS_IPHONE_5) {
                    if (index % 12 == 0) {
                        row = 0;
                        page++;
                    }
                } else {
                    if (index % 9 == 0) { // ????这个分支是什么？？？
                        row = 0;
                        page++;
                    }
                }
                
                frame.origin.x = (interval+(col%num)*(viewWidth+interval)) + page * self.frame.size.width;
                frame.origin.y = row*80 + row*20;

            } else {
                col = index%num;
                if (index % num == 0) row++;
                if (index % 6 == 0) {
                    row = 0;
                    page++;
                }

                frame.origin.x = (45 + col*80 + col*38) + page * self.frame.size.width;
                frame.origin.y = 0 +  row*80 + row*15;
            }
            
            view.frame = frame;
            
            index++;
        }
        
        _scrollView.contentSize = CGSizeMake((page +1) * self.frame.size.width, _scrollView.frame.size.height);
        _scrollView.pagingEnabled = YES;
        
        CGRect pageControlFrame = _pageControl.frame;
        pageControlFrame.origin.y = self.frame.size.height - 84;
        pageControlFrame.size.width = self.frame.size.width;
        _pageControl.frame = pageControlFrame;
        _pageControl.numberOfPages = page + 1;
        
        if (_pageControl.numberOfPages <= 1) {
            _pageControl.hidden = YES;
            _scrollView.scrollEnabled = NO;
        } else {
            _pageControl.hidden = NO;
            _scrollView.scrollEnabled = YES;
        }
        
        [self pageControlValueChanged:_pageControl];
    } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        // For iPad
        CGRect frame = _cancelButton.frame;
        frame.origin.y = self.frame.size.height - 47 - 16;
        frame.origin.x = (self.frame.size.width - frame.size.width) / 2.0f;
        _cancelButton.frame = frame;
    }
}

#pragma mark -
#pragma mark Button action

- (void)cancelButtonPressed
{
    [_activityViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)buttonPressed:(UIButton *)button
{
    NSInteger index = button.tag;
    REActivity *activity;
    if (index >= _activities.count) {
        index = button.tag - _activities.count;
        activity = [_settingActivites objectAtIndex:index];
    }else{
        activity = [_activities objectAtIndex:index];
    }
    activity.activityViewController = _activityViewController;
    if (activity.actionBlock) {
        activity.actionBlock(activity, _activityViewController);
    }
}

#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _pageControl.currentPage = scrollView.contentOffset.x / scrollView.frame.size.width;
}

#pragma mark -

- (void)pageControlValueChanged:(UIPageControl *)pageControl
{
    CGFloat pageWidth = _scrollView.contentSize.width /_pageControl.numberOfPages;
    CGFloat x = _pageControl.currentPage * pageWidth;
    [_scrollView scrollRectToVisible:CGRectMake(x, 0, pageWidth, _scrollView.frame.size.height) animated:YES];
}

@end
