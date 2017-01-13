//
// REActivityViewController.m
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

#import "REActivityViewController.h"
#import "REActivityView.h"

CGFloat const kActivityViewLandscapeWidht = 410;

@interface REActivityViewController ()
{
    void(^dismiscom)();
}

@property (strong, readonly, nonatomic) UIView *backgroundView;

- (NSInteger)height;

@end

@implementation REActivityViewController

- (instancetype)initWithViewController:(UIViewController *)viewController activities:(NSArray *)activities settingAct:(NSArray *)settingArr
{
    self = [super init];
    if (self) {
        self.presentingController = viewController;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            _backgroundView.backgroundColor = [UIColor blackColor];
            _backgroundView.alpha = 0;
            [self.view addSubview:_backgroundView];
        } else {
            self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 417);
        }
        
        _activities = activities;
        _settingArr = settingArr;
        
        _activityView = [[REActivityView alloc] initWithFrame:CGRectMake(0,
                                                                         UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ?
                                                                         [UIScreen mainScreen].bounds.size.height : 0,
                                                                         self.view.frame.size.width, self.height)
                                                   activities:activities setActivities:settingArr];
        _activityView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _activityView.activityViewController = self;
        [self.view addSubview:_activityView];
        self.preferredContentSize = CGSizeMake(SCREEN_WIDTH, self.height - 60);
    }
    return self;
}

- (void)loadView
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
        self.view = [[UIView alloc] initWithFrame:rootViewController.view.bounds];
        self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    } else {
        [super loadView];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(mjdismissView)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
}

- (void)presentFromRootViewController
{
    UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    [self presentFromViewController:rootViewController];
}

- (void)presentFromViewController:(UIViewController *)controller
{
    [self presentFromViewController:controller completion:nil];
}

- (void)presentFromViewController:(UIViewController *)controller  completion:(void (^)(void))completion
{
    dismiscom = completion;
    self.rootViewController = controller;
    [controller addChildViewController:self];
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
        CGRect frame = self.activityView.frame;
        frame.size.width = kActivityViewLandscapeWidht;
        [self updateActivityViewFrame:frame];
    }
    [self.view setFrame:[UIScreen mainScreen].bounds];
    [controller.view addSubview:self.view];
    [self didMoveToParentViewController:controller];
    
    [MJTopNotification canShow:NO];
}

- (void)didMoveToParentViewController:(UIViewController *)parent
{
    [super didMoveToParentViewController:parent];
    _backgroundView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    __typeof (&*self) __weak weakSelf = self;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [UIView animateWithDuration:0.2 animations:^{
            weakSelf.backgroundView.alpha = 0.4;
            CGRect frame = weakSelf.activityView.frame;
            CGFloat superHeight = CGRectGetHeight(weakSelf.rootViewController.view.frame);
            UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
            if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
                frame.size.width = kActivityViewLandscapeWidht;
            }
            frame.origin.y = superHeight - self.height;
            [weakSelf updateActivityViewFrame:frame];
        }];
    }
}

- (NSInteger)height
{
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsPortrait(interfaceOrientation) || UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if (_activities.count <= 3) {
                return 158;
        }
        if (_activities.count <= 6){
            if (_settingArr != nil && _settingArr.count > 0) {
                return 387;
            }else{
                return 266;
            }
        }
        if (IS_IPHONE_5 && _activities.count > 9) {
            return 517;
        }
        return 417;
    } else {
        if (_activities.count <= 3) return 169;
        return 264;
    }
}

-(void)mjdismissView{
    [self dismissViewControllerAnimated:YES completion:dismiscom];
}


- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    [MJTopNotification canShow:YES];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        __typeof (&*self) __weak weakSelf = self;
        [UIView animateWithDuration:0.2 animations:^{
            _backgroundView.alpha = 0;
            CGRect frame = _activityView.frame;
            frame.origin.y = [UIScreen mainScreen].bounds.size.height;
            _activityView.frame = frame;
        } completion:^(BOOL finished) {
            [weakSelf.view removeFromSuperview];
            [weakSelf removeFromParentViewController];
            if (completion)
                completion();
        }];
    } else {
        [self.presentingPopoverController dismissPopoverAnimated:YES];
        [self performBlock:^{
            if (completion)
                completion();
        } afterDelay:0.4];
    }
    if ([self.presentingController isKindOfClass:[UINavigationController class]] ) {
        if (((UINavigationController *)self.presentingController).interactivePopGestureRecognizer.enabled == NO) {
            ((UINavigationController *)self.presentingController).interactivePopGestureRecognizer.enabled = YES;
        }
    }
    
    if (dismiscom){
        dismiscom();
    }
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    CGPoint tap = [gestureRecognizer locationInView:self.view];
    CGRect actViewRect = _activityView.frame;
    if (CGRectContainsPoint(actViewRect, tap)) {
        return NO;
    }
    return YES;
}

#pragma mark - Helpers

- (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay
{
    block = [block copy];
    [self performSelector:@selector(runBlockAfterDelay:) withObject:block afterDelay:delay];
}

- (void)runBlockAfterDelay:(void (^)(void))block
{
	if (block != nil)
		block();
}

#pragma mark - Orientation

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        CGRect frame = self.activityView.frame;
        CGFloat superHeight = CGRectGetHeight(self.rootViewController.view.frame);
        if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
            frame.size.width = CGRectGetWidth(self.rootViewController.view.frame);
        } else {
            frame.size.width = kActivityViewLandscapeWidht;
        }
        
        frame.origin.y = superHeight - self.height;
        [self updateActivityViewFrame:frame];
    }
}

- (void)updateActivityViewFrame:(CGRect)frame
{
    frame.size.height = self.height;
    self.activityView.frame = frame;
    self.activityView.centerX = self.rootViewController.view.centerX;
}

@end
