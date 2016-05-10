//
//  YhsBaseHomeView.h
//  YhsShopping
//
//  Created by 姚海深 on 16/5/6.
//  Copyright © 2016年 姚海深. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YhsHome0TableViewCell.h"
#import "YhsHome1TableViewCell.h"
#import "YhsHome2TableViewCell.h"

@interface YhsBaseHomeView : UIView

/**
 *  轮播图
 *
 *  @param frame  frame
 *  @param images 图片数组（nsstring）
 *  @param block  点击图片触发的事件
 *
 *  @return 轮播图
 */
- (id)initWithFrame:(CGRect)frame andDataArr:(NSArray*)images clickHandler:(void(^)(NSInteger num)) block;

/**
 *  分段图
 *
 *  @param frame  frame
 *  @param titles 标题
 *  @param block  点击标题触发的事件
 *
 *  @return 分段图
 */
- (id)initWithFrame:(CGRect)frame andDataTitle:(NSArray*)titles clickHandler:(void(^)(NSInteger num)) block;


@end
