//
//  LYSSlideMenuController.h
//  LYSSlideMenuController
//
//  Created by HENAN on 2018/3/26.
//  Copyright © 2018年 李阳帅. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LYSSlideMenuController;

@protocol LYSSlideMenuControllerDelegate<NSObject>

/**
 子视图第一次加载页面

 @param slideMenuController 主视图控制器
 @param index 页面下标
 */
- (void)slideMenuController:(LYSSlideMenuController *)slideMenuController didViewDidLoad:(NSInteger)index;

@optional
// 页面生命周期方法
- (void)slideMenuController:(LYSSlideMenuController *)slideMenuController viewWillAppear:(NSInteger)index;
- (void)slideMenuController:(LYSSlideMenuController *)slideMenuController viewDidAppear:(NSInteger)index;
- (void)slideMenuController:(LYSSlideMenuController *)slideMenuController viewWillDisappear:(NSInteger)index;
- (void)slideMenuController:(LYSSlideMenuController *)slideMenuController viewDidDisappear:(NSInteger)index;

@end

@interface LYSSlideMenuController : UIViewController

/**
 一个页面显示几个按钮
 */
@property (nonatomic,assign)NSInteger pageNumberOfItem;


@property (nonatomic,assign)NSInteger currentItem;
@property (nonatomic,assign)CGFloat menuHeight;

/**
 顶部菜单数据
 */
@property (nonatomic,strong)NSArray<NSString *> *titles;

@property (nonatomic,assign)BOOL showBottomLine;
@property (nonatomic,assign)CGFloat bottomLineHeight;
@property (nonatomic,assign)CGFloat bottomLineWidth;
@property (nonatomic,strong)UIColor *bottomLineColor;

@property (nonatomic,strong)UIFont *titleFont;
@property (nonatomic,strong)UIFont *titleSelectFont;

@property (nonatomic,strong)UIColor *titleColor;
@property (nonatomic,strong)UIColor *titleSelectColor;

/**
 内容页面控制器菜单(为了避免页面显示时候,同时加载多个页面数据,可以遵循LYSSlideMenuControllerDelegate代理,在代理方法里面进行数据加载)
 */
@property (nonatomic,strong)NSArray<UIViewController<LYSSlideMenuControllerDelegate> *> *controllers;
@end
