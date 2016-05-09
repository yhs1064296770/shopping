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

- (id)initWithFrame:(CGRect)frame andDataArr:(NSArray*)images clickHandler:(void(^)(NSInteger num)) block;

@end
