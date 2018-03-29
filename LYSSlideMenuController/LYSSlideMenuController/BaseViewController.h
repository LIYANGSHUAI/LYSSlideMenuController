//
//  BaseViewController.h
//  LYSSlideMenuController
//
//  Created by HENAN on 2018/3/29.
//  Copyright © 2018年 李阳帅. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LYSSlideMenuController.h"
#import "MJRefresh.h"
@interface BaseViewController : UIViewController<LYSSlideMenuControllerDelegate>
- (void)show;
- (void)hidden;
@end
