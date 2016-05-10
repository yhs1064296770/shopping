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

@property (nonatomic, copy)block myblock;

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
        self.myblock = block;
        _titleScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _titleScrollView.backgroundColor = [UIColor whiteColor];
        _titleScrollView.showsHorizontalScrollIndicator = NO;
        _titleScrollView.showsVerticalScrollIndicator = NO;
        CGFloat ponitX = frame.origin.x+10;
        NSInteger tag = 100;
        _pageNum = 100;
        for (NSString *str in titles) {
            CGRect rect = [self calculateTextHeight:[UIFont fontWithName:@"HelveticaNeue" size:17] givenText:str givenWidth:MAXFLOAT];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(ponitX, 0, rect.size.width+10, frame.size.height-1)];
            label.text = str;
            label.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
            label.textAlignment = NSTextAlignmentCenter;
            label.tag = ++tag;
            _pageNum++;
             label.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapLabel:)];
            [label addGestureRecognizer:tap];
            ponitX = ponitX + label.frame.size.width;
            if (label.tag == 101) {
                NSString *labelstr = label.text;
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:labelstr];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:255/255.0 green:151/255.0  blue:29/255.0  alpha:1] range:NSMakeRange(0,str.length)];
//                [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0,str.length)];
                label.attributedText = str;
            }
            [_titleScrollView addSubview:label];
        }
        _lastSelectedTag = 101;
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
    NSString *labelstr = nowLabel.text;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:labelstr];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:255/255.0 green:151/255.0  blue:29/255.0  alpha:1] range:NSMakeRange(0,str.length)];
//    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0,str.length)];
    nowLabel.attributedText = str;
    //获取上一个点击按钮
    UILabel *nextLabel = (UILabel *)[self viewWithTag:_lastSelectedTag];
    NSMutableAttributedString *nextstr  =  [[NSMutableAttributedString alloc] initWithString:nextLabel.text];;
    [nextstr addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(0,0)];//删除线
//    [nextstr addAttribute:NSStrikethroughColorAttributeName value:[UIColor colorWithRed:255/255.0 green:151/255.0  blue:29/255.0  alpha:1] range:NSMakeRange(0,nextstr.length)];//删除线蓝色
    nextLabel.attributedText = nextstr;
    
    if (_lastSelectedTag < sender.view.tag) {
        if (nowLabel.frame.origin.x - _titleScrollView.contentSize.width+nowLabel.frame.size.width+self.frame.size.width/2 >0) {
            //点击后自动居中
            [_titleScrollView setContentOffset:CGPointMake(_titleScrollView.contentSize.width- self.frame.size.width, nowLabel.frame.origin.y) animated:YES];
        }else{
            if (nowLabel.frame.origin.x <self.frame.size.width/2) {
                [_titleScrollView setContentOffset:CGPointMake(self.frame.origin.x, 0) animated:YES];
            }else{
                //点击后自动居中
                [_titleScrollView setContentOffset:CGPointMake(nowLabel.frame.origin.x - self.frame.size.width/2 + nowLabel.frame.size.width/2, 0) animated:YES];
            }
        }
    } else {
        if (nowLabel.frame.origin.x <self.frame.size.width/2) {
            [_titleScrollView setContentOffset:CGPointMake(self.frame.origin.x, 0) animated:YES];
        }else{
            if (nowLabel.frame.origin.x - _titleScrollView.contentSize.width+nowLabel.frame.size.width+self.frame.size.width/2 >0) {
                //点击后自动居中
                [_titleScrollView setContentOffset:CGPointMake(_titleScrollView.contentSize.width- self.frame.size.width, nowLabel.frame.origin.y) animated:YES];
            }else{
                [_titleScrollView setContentOffset:CGPointMake(nowLabel.frame.origin.x - self.frame.size.width/2 + nowLabel.frame.size.width/2, 0) animated:YES];
            }
        }
    }
    _lastSelectedTag = sender.view.tag ;
    self.myblock(sender.view.tag);
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
