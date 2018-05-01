//
//  LYSSlideMenuController.m
//  LYSSlideMenuController
//
//  Created by HENAN on 2018/3/26.
//  Copyright © 2018年 李阳帅. All rights reserved.
//

#import "LYSSlideMenuController.h"
#import <objc/runtime.h>

#define Rect(x,y,w,h) CGRectMake(x, y, w, h)
#define ScreenWidth CGRectGetWidth(self.view.frame)
#define ScreenHeight CGRectGetHeight(self.view.frame)

typedef NS_ENUM(NSUInteger, LYSScrollViewType) {
    LYSScrollViewType_menu                = 10000,
    LYSScrollViewType_content             = 10001
};

@interface LYSSlideMenuController ()<UIScrollViewDelegate>

@property (nonatomic,strong,readwrite)UIScrollView *menuScrollView;
@property (nonatomic,strong,readwrite)UIScrollView *contentScrollView;

@property (nonatomic,strong)NSMutableArray *labelArys;

@property (nonatomic,assign)NSInteger lastIndex;

@property (nonatomic,strong)UIView *bottomLine;

@end

@implementation LYSSlideMenuController

- (BOOL)superExistNav
{
    UIViewController *parentVC = self;
    while (parentVC != nil && ![parentVC isKindOfClass:[UINavigationController class]]) {
        parentVC = parentVC.parentViewController;
    }
    return [parentVC isKindOfClass:[UINavigationController class]];
}

- (BOOL)superExistTab
{
    UIViewController *parentVC = self;
    while (parentVC != nil && ![parentVC isKindOfClass:[UITabBarController class]]) {
        parentVC = parentVC.parentViewController;
    }
    return [parentVC isKindOfClass:[UITabBarController class]];
}

- (UIView *)bottomLine
{
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = self.bottomLineColor;
    }
    return _bottomLine;
}

- (CGFloat)menuHeight
{
    if (_menuHeight == 0) {
        _menuHeight = 40;
    }
    return _menuHeight;
}

- (NSInteger)pageNumberOfItem
{
    if (_pageNumberOfItem == 0) {
        _pageNumberOfItem = (self.titles.count > 5 ? 5 : self.titles.count);
    }
    return _pageNumberOfItem;
}

- (CGFloat)bottomLineWidth
{
    if (_bottomLineWidth == 0 || _bottomLineWidth > ScreenWidth / self.pageNumberOfItem) {
        _bottomLineWidth = ScreenWidth / self.pageNumberOfItem;
    }
    return _bottomLineWidth;
}

- (NSMutableArray *)labelArys
{
    if (!_labelArys) {
        _labelArys = [NSMutableArray array];
    }
    return _labelArys;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.showBottomLine = YES;
        self.bottomLineHeight = 2;
        self.bottomLineColor = [UIColor redColor];
        
        self.titleColor = [UIColor blackColor];
        self.titleFont = [UIFont systemFontOfSize:14];
        self.titleSelectColor = [UIColor redColor];
        self.titleSelectFont = [UIFont systemFontOfSize:14];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self customBaseView];
    [self customTopView];
    [self customBottomView];
    
    // 默认选中第一个
    [self menuUpdateStyle:self.currentItem];
    [self menuScrollToCenter:self.currentItem];
    [self menuUpdateBottomLine:self.currentItem];
    [self motionChangePage:self.currentItem];
    self.lastIndex = self.currentItem;
}

#pragma mark - 加载基本视图 -
- (void)customBaseView
{
    CGFloat navHeight = [self superExistNav] ? 64 : 0;
    CGFloat tabHeight = [self superExistTab] ? 49 : 0;
    self.menuScrollView = [[UIScrollView alloc] init];
    self.menuScrollView.showsHorizontalScrollIndicator = NO;
    self.menuScrollView.delegate = self;
    self.menuScrollView.tag = LYSScrollViewType_menu;
    [self.view addSubview:self.menuScrollView];
    self.menuScrollView.frame = Rect(0, navHeight, ScreenWidth, self.menuHeight);
    
    UIView *line = [[UIView alloc] init];
    line.frame = Rect(0, CGRectGetMaxY(self.menuScrollView.frame), ScreenWidth, 0.5);
    line.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line];
    
    self.contentScrollView = [[UIScrollView alloc] init];
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    self.contentScrollView.pagingEnabled = YES;
    self.contentScrollView.delegate = self;
    self.contentScrollView.tag = LYSScrollViewType_content;
    self.contentScrollView.bounces = NO;
    [self.view addSubview:self.contentScrollView];
    self.contentScrollView.frame = Rect(0, CGRectGetMaxY(line.frame), ScreenWidth, ScreenHeight - navHeight - tabHeight - CGRectGetMaxY(line.frame) + CGRectGetMinY(self.menuScrollView.frame));
}

#pragma mark - 加载顶部视图数据 -
- (void)customTopView
{
    CGFloat itemWidth = ScreenWidth / self.pageNumberOfItem;
    for (int i = 0; i < self.titles.count; i++) {
        UILabel *item = [[UILabel alloc] init];
        item.frame = Rect(itemWidth * i, 0, itemWidth, self.menuHeight);
        item.text = self.titles[i];
        item.font = self.titleFont;
        item.textColor = self.titleColor;
        item.textAlignment = NSTextAlignmentCenter;
        item.tag = 10000 + i;
        [self.menuScrollView addSubview:item];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemClickTap:)];
        item.userInteractionEnabled = YES;
        [item addGestureRecognizer:tap];
        [self.labelArys addObject:item];
    }
    self.menuScrollView.contentSize = CGSizeMake(itemWidth * self.titles.count, self.menuHeight);
    if (self.showBottomLine == YES) {
        self.bottomLine.frame = CGRectMake((self.currentItem * itemWidth) + ((itemWidth - self.bottomLineWidth) / 2.0), self.menuHeight - self.bottomLineHeight, self.bottomLineWidth, self.bottomLineHeight);
        [self.menuScrollView addSubview:self.bottomLine];
    }
}

// 加载视图
- (void)customBottomView
{
    for (int i = 0; i < self.controllers.count; i++) {
        UIViewController *vc = self.controllers[i];
        vc.view.frame = Rect(ScreenWidth * i, 0, ScreenWidth, CGRectGetHeight(self.contentScrollView.frame));
        [self addChildViewController:vc];
        [self.contentScrollView addSubview:vc.view];
        objc_setAssociatedObject(vc, @"lysIsLoad", @(NO), OBJC_ASSOCIATION_ASSIGN);
    }
    self.contentScrollView.contentSize = CGSizeMake(ScreenWidth * self.controllers.count, CGRectGetHeight(self.contentScrollView.frame));
}

#pragma mark - scrollView代理方法 -
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView.tag == LYSScrollViewType_content) {
        NSInteger index = scrollView.contentOffset.x / ScreenWidth;
        if (self.lastIndex != index) {
            [self menuUpdateStyle:index];
            [self menuScrollToCenter:index];
            [self menuUpdateBottomLine:index];
            [self motionChangePage:index];
            self.lastIndex = index;
        }
    }
}

#pragma mark - 菜单点击回调 -
- (void)itemClickTap:(UIGestureRecognizer *)sender{
    NSInteger index = sender.view.tag - 10000;
    if (self.lastIndex != index) {
        [self menuUpdateStyle:index];
        [self menuScrollToCenter:index];
        [self menuUpdateBottomLine:index];
        [self contentScrollToCenter:index];
        [self motionChangePage:index];
        self.lastIndex = index;
    }
}

#pragma mark - 页面切换回调 -
- (void)motionChangePage:(NSInteger)index {
    if (self.lastIndex != index) {
        UIViewController<LYSSlideMenuControllerDelegate> *lastVC = self.controllers[self.lastIndex];
        UIViewController<LYSSlideMenuControllerDelegate>  *currentVC = self.controllers[index];
        NSNumber *value = objc_getAssociatedObject(currentVC, @"lysIsLoad");
        if (![value boolValue]) {
            if ([currentVC respondsToSelector:@selector(slideMenuController:didViewDidLoad:)]) {
                [currentVC slideMenuController:self didViewDidLoad:index];
            }
            objc_setAssociatedObject(currentVC, @"lysIsLoad", @(YES), OBJC_ASSOCIATION_ASSIGN);
        }
        if ([lastVC respondsToSelector:@selector(slideMenuController:viewWillDisappear:)]) {
            [lastVC slideMenuController:self viewWillDisappear:self.lastIndex];
        }
        if ([currentVC respondsToSelector:@selector(slideMenuController:viewWillAppear:)]) {
            [currentVC slideMenuController:self viewWillAppear:index];
        }
        if ([lastVC respondsToSelector:@selector(slideMenuController:viewDidDisappear:)]) {
            [lastVC slideMenuController:self viewDidDisappear:self.lastIndex];
        }
        if ([currentVC respondsToSelector:@selector(slideMenuController:viewDidAppear:)]) {
            [currentVC slideMenuController:self viewDidAppear:index];
        }
    }else {
        UIViewController<LYSSlideMenuControllerDelegate>  *currentVC = self.controllers[index];
        if ([currentVC respondsToSelector:@selector(slideMenuController:didViewDidLoad:)]) {
            [currentVC slideMenuController:self didViewDidLoad:index];
        }
        objc_setAssociatedObject(currentVC, @"lysIsLoad", @(YES), OBJC_ASSOCIATION_ASSIGN);
        if ([currentVC respondsToSelector:@selector(slideMenuController:viewWillAppear:)]) {
            [currentVC slideMenuController:self viewWillAppear:index];
        }
        if ([currentVC respondsToSelector:@selector(slideMenuController:viewDidAppear:)]) {
            [currentVC slideMenuController:self viewDidAppear:index];
        }
    }
}

// 内容滚动
- (void)contentScrollToCenter:(NSInteger)index {
    CGFloat left = ScreenWidth * index;
    [self.contentScrollView setContentOffset:CGPointMake(left, 0) animated:YES];
}

// 顶部菜单滚动
- (void)menuScrollToCenter:(NSInteger)index{
    CGFloat itemWidth = ScreenWidth / self.pageNumberOfItem;
    UILabel *label = self.labelArys[index];
    CGFloat left = label.center.x - ScreenWidth / 2.0;
    left = left <= 0 ? 0 : left;
    CGFloat maxLeft = itemWidth * self.titles.count - ScreenWidth;
    left = left >= maxLeft ? maxLeft : left;
    [self.menuScrollView setContentOffset:CGPointMake(left, 0) animated:YES];
}

// 顶部菜单切换样式
- (void)menuUpdateStyle:(NSInteger)index{
    UILabel *lastLabel = self.labelArys[self.lastIndex];
    lastLabel.font = self.titleFont;
    lastLabel.textColor = self.titleColor;
    UILabel *label = self.labelArys[index];
    label.textColor = self.titleSelectColor;
    label.font = self.titleSelectFont;
}

// 顶部菜单底部细线滚动
- (void)menuUpdateBottomLine:(NSInteger)index{
    if (self.showBottomLine == YES) {
        CGFloat itemWidth = ScreenWidth / self.pageNumberOfItem;
        [UIView animateWithDuration:0.1 animations:^{
            self.bottomLine.frame = CGRectMake((index * itemWidth) + ((itemWidth - self.bottomLineWidth) / 2.0), self.menuHeight - self.bottomLineHeight, self.bottomLineWidth, self.bottomLineHeight);
        }];
    }
}
@end
