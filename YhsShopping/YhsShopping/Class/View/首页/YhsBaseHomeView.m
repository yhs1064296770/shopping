//
//  YhsBaseHomeView.m
//  YhsShopping
//
//  Created by 姚海深 on 16/5/6.
//  Copyright © 2016年 姚海深. All rights reserved.
//

#import "YhsBaseHomeView.h"

#import "DCPicScrollView.h"

@interface YhsBaseHomeView()

@end

@implementation YhsBaseHomeView

- (id)initWithFrame:(CGRect)frame andDataArr:(NSArray *)images clickHandler:(void (^)(NSInteger num))block{
    self = [super initWithFrame:frame];
    if (self ) {

        DCPicScrollView *DCView = [DCPicScrollView picScrollViewWithFrame:frame WithImageUrls:images];
        //设置背景颜色
        self.backgroundColor = [UIColor clearColor];
        //点击轮播图片触发的事件
        [DCView setImageViewDidTapAtIndex:^(NSInteger index) {
            block(index);
        }];
        //设置轮播图片刷新事件为2秒
        DCView.AutoScrollDelay = 3.0f;
        [self addSubview:DCView];
    }
    return self;
}


@end
