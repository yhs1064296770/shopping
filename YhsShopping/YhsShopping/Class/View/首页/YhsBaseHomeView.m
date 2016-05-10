//
//  YhsBaseHomeView.m
//  YhsShopping
//
//  Created by 姚海深 on 16/5/6.
//  Copyright © 2016年 姚海深. All rights reserved.
//

#import "YhsBaseHomeView.h"

#import "DCPicScrollView.h"

typedef void (^block) (NSInteger num);

@interface YhsBaseHomeView()<UIScrollViewDelegate>
{
    UIScrollView *_titleScrollView;
    
    UIScrollView *_contentScrollView;
    
    NSInteger _lastSelectedTag;
    
    NSInteger _pageNum;
}

@property (nonatomic, assign)block myblock;

@property (nonatomic,assign)NSInteger selectBtn;

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

- (id)initWithFrame:(CGRect)frame andDataTitle:(NSArray *)titles clickHandler:(void (^)(NSInteger))block{
    self = [super initWithFrame:frame];
    if (self ) {
        _titleScrollView = [[UIScrollView alloc]initWithFrame:frame];
        _titleScrollView.backgroundColor = [UIColor whiteColor];
        _titleScrollView.showsHorizontalScrollIndicator = NO;
        _titleScrollView.showsVerticalScrollIndicator = NO;
        CGFloat ponitX = frame.origin.x+10;
        NSInteger tag = 100;
        _pageNum = 100;
        for (NSString *str in titles) {
            CGRect rect = [self calculateTextHeight:[UIFont fontWithName:@"HelveticaNeue" size:17] givenText:str givenWidth:MAXFLOAT];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(ponitX, frame.origin.y, rect.size.width+10, frame.size.height-1)];
            label.text = str;
            label.tag = ++tag;
            _pageNum++;
             label.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapLabel:)];
            [label addGestureRecognizer:tap];
            ponitX = ponitX + label.frame.size.width;
            [_titleScrollView addSubview:label];
        }
        _lastSelectedTag = 100;
        _titleScrollView.contentSize = CGSizeMake(ponitX, frame.size.height);
        [self addSubview:_titleScrollView];
    }
    return self;
}

- (void)TapLabel:(UITapGestureRecognizer *)sender{
    if (sender.view.tag == _lastSelectedTag) {
        return;
    }
    //获取当前点击的Label
    UILabel *nowLabel = (UILabel *)[self viewWithTag:sender.view.tag ];
    //更改状态
    nowLabel.textColor = [UIColor redColor];

    //获取上一个点击按钮
    UILabel *nextLabel = (UILabel *)[self viewWithTag:_lastSelectedTag];
    nextLabel.textColor = [UIColor blackColor];
   

    UILabel *lastLabel = (UILabel *)[self viewWithTag:_pageNum];
    UILabel *firstLabel = (UILabel *)[self viewWithTag:100];
    
    if (_lastSelectedTag < sender.view.tag) {
        NSLog(@"%f",_titleScrollView.contentSize.width - lastLabel.frame.size.width);
        NSLog(@"%f",nowLabel.frame.origin.x - self.frame.size.width/2 + nowLabel.frame.size.width/2);
        NSLog(@"%f",lastLabel.frame.origin.x );
        if (nowLabel.frame.origin.x + (nowLabel.frame.origin.x - self.frame.size.width/2 + nowLabel.frame.size.width/2)>_titleScrollView.contentSize.width - lastLabel.frame.size.width) {
            //点击后自动居中
            [_titleScrollView setContentOffset:CGPointMake(_titleScrollView.contentSize.width- self.frame.size.width, nowLabel.frame.origin.y) animated:YES];
        }else{
            //点击后自动居中
            [_titleScrollView setContentOffset:CGPointMake(nowLabel.frame.origin.x - self.frame.size.width/2 + nowLabel.frame.size.width/2, self.frame.origin.y) animated:YES];
        }
    } else {
        if (firstLabel.frame.origin.x + (nextLabel.frame.origin.x - self.frame.size.width/2 + nowLabel.frame.size.width/2)>0) {
            [_titleScrollView setContentOffset:CGPointMake(self.frame.origin.x, self.frame.origin.y) animated:YES];
        }else{
             [_titleScrollView setContentOffset:CGPointMake(nowLabel.frame.origin.x - self.frame.size.width/2 + nowLabel.frame.size.width/2, self.frame.origin.y) animated:YES];
        }
    }
    _lastSelectedTag = sender.view.tag ;
    
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
