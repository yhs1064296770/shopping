//
//  BaseViewController.h
//  YhsShopping
//
//  Created by 姚海深 on 16/5/6.
//  Copyright © 2016年 姚海深. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

/**
 * 2016.4.28 修改 姚海深
 *  设置导航栏
 *
 *  @param title      标题
 *  @param rightTitle 设置文字或图片（设置图片需要在加前缀img:）
 *  @param leftNeed   是否需要左边的按钮
 */
- (void)setNavigation:(NSString *)title rightButton:(NSString *)rightTitle andNeedLeftButton:(BOOL) leftNeed;
- (void)leftClick:(UIButton *)button;
- (void)rightClick:(UIButton *)button;


@end
