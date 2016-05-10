//
//  YHSTitleScrollView.m
//  YhsShopping
//
//  Created by 姚海深 on 16/5/9.
//  Copyright © 2016年 姚海深. All rights reserved.
//

#import "YHSTitleScrollView.h"
@interface YHSTitleScrollView ()<UIScrollViewDelegate>
{
    UIScrollView *_titleScrollView;
    
    UIScrollView *_contentScrollView;
    
    NSInteger _lastSelectedTag;
    
    NSInteger _pageNum;
}
@end

@implementation YHSTitleScrollView

- (id)initWithFrame:(CGRect)frame andDataArr:(NSArray *)dataArr{
    self = [super initWithFrame:frame];
    if (self) {
        _titleScrollView = [[UIScrollView alloc]initWithFrame:frame];
        _titleScrollView.backgroundColor = [UIColor whiteColor];
        _titleScrollView.showsHorizontalScrollIndicator = NO;
        _titleScrollView.showsVerticalScrollIndicator = NO;
        CGFloat ponitX = frame.origin.x;
        NSInteger tag = 100;
        for (NSString *str in dataArr) {
            CGRect rect = [self calculateTextHeight:[UIFont fontWithName:@"HelveticaNeue" size:17] givenText:str givenWidth:MAXFLOAT];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(ponitX, frame.origin.y, rect.size.width+10, frame.size.height-1)];
            label.text = str;
            label.tag = ++tag;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapLabel:)];
            [label addGestureRecognizer:tap];
            ponitX = ponitX + label.frame.size.width;
            [_titleScrollView addSubview:label];
        }
        [self addSubview:_titleScrollView];
    }
    return self;
}

- (void)TapLabel:(UITapGestureRecognizer *)sender{
    
    
}


- (CGRect) calculateTextHeight:(UIFont *)font givenText:(NSString *)text givenWidth:(NSInteger)width{
    
    NSDictionary *attributes = @{NSFontAttributeName: font};
    // NSString class method: boundingRectWithSize:options:attributes:context is
    // available only on ios7.0 sdk.
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:attributes
                                     context:nil];
    return rect;
    
}

@end
