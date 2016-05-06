//
//  FJQScrollView.m
//  FJQScrollView
//
//  Created by 傅家琦 on 16/4/26.
//  Copyright © 2016年 集广科技. All rights reserved.
//

#import "FJQScrollView.h"
#import "UIImageView+WebCache.h"

#define pageSize 16

//获得RGB颜色
#define RGBA(r, g, b, a)                    [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r, g, b)                        RGBA(r, g, b, 1.0f)

#define pageColor RGB(67, 199, 176)


//2016.04.25  傅家琦 修改
#define LOG(...) NSLog(__VA_ARGS__);
#define LOG_METHOD NSLog(@"%s", __func__);
#define SCREENH [UIScreen mainScreen].bounds.size.height
#define SCREENW [UIScreen mainScreen].bounds.size.width
#define COLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define kScreenBounds [UIScreen mainScreen].bounds
//颜色
#define MAIN_COLOR [UIColor colorWithRed:44/255.0 green:156/255.0 blue:243/255.0 alpha:1]



@interface FJQScrollView () <UIScrollViewDelegate>

@property (nonatomic, copy) NSArray *imageArray;

@end


@implementation FJQScrollView

{
    __weak  UIImageView *_leftImageView,*_centerImageView,*_rightImageView;
    
    __weak  UIScrollView *_scrollView;
    
    __weak  UIPageControl *_PageControl;
    
    NSTimer *_timer;
    
    /** 当前显示的是第几个*/
    NSInteger _currentIndex;
    
    /** 图片个数*/
    NSInteger _MaxImageCount;
    
    /** 是否是网络图片*/
    BOOL _isNetworkImage;
}

#pragma mark - 本地图片

-(instancetype)initWithFrame:(CGRect)frame WithLocalImages:(NSArray *)imageArray
{
    if (imageArray.count < 2 ) {
        return nil;
    }
    self = [super initWithFrame:frame];
    if ( self) {
        
        _isNetworkImage = NO;
        
        /** 创建滚动view*/
        [self createScrollView];
        
        /** 加入本地image*/
        [self setImageArray:imageArray];
        
        /** 设置数量*/
        [self setMaxImageCount:_imageArray.count];
    }
    
    return self;
}

#pragma mark - 网络图片

-(instancetype)initWithFrame:(CGRect)frame WithNetImages:(NSArray *)imageArray
{
    if (imageArray.count < 2 ) {
        return nil;
    }
    self = [super initWithFrame:frame];
    if ( self) {
        
        _isNetworkImage = YES;
        
        /** 创建滚动view*/
        [self createScrollView];
        
        /** 加入本地image*/
        [self setImageArray:imageArray];
        
        /** 设置数量*/
        [self setMaxImageCount:_imageArray.count];
    }
    
    return self;
}

#pragma mark - 设置数量

-(void)setMaxImageCount:(NSInteger)MaxImageCount
{
    _MaxImageCount = MaxImageCount;
    
    /** 复用imageView初始化*/
    [self initImageView];
    
    /** pageControl*/
    [self createPageControl];
    
    /** 定时器*/
    [self setUpTimer];
    
    /** 初始化图片位置*/
    [self changeImageLeft:_MaxImageCount-1 center:0 right:1];
}

- (void)createScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    [self addSubview:scrollView];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    
    /** 复用，创建三个*/
    scrollView.contentSize = CGSizeMake(SCREENW * 3, 0);
    
    /** 设置滚动延时时间*/
    _AutoScrollDelay = 0;
    
    /** 开始显示的是第一个   前一个是最后一个   后一个是第二张*/
    _currentIndex = 0;
    
    _scrollView = scrollView;
}

-(void)setImageArray:(NSArray *)imageArray
{
    //如果是网络
    if (_isNetworkImage)
    {
        _imageArray = [imageArray copy];
        
    }else {
        //本地
        NSMutableArray *localimageArray = [NSMutableArray arrayWithCapacity:imageArray.count];
        for (NSString *imageName in imageArray) {
            [localimageArray addObject:[UIImage imageNamed:imageName]];
        }
        _imageArray = [localimageArray copy];
    }
}
//设置Image位置
- (void)initImageView {
    UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,SCREENW, SCREENH)];
    leftImageView.contentMode = UIViewContentModeScaleAspectFit;
    UIImageView *centerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENW, 0,SCREENW, SCREENH)];
    centerImageView.contentMode = UIViewContentModeScaleAspectFit;
    UIImageView *rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENW * 2, 0,SCREENW, SCREENH)];
    rightImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    centerImageView.userInteractionEnabled = YES;
    [centerImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidTap)]];
    
    [_scrollView addSubview:leftImageView];
    [_scrollView addSubview:centerImageView];
    [_scrollView addSubview:rightImageView];
    
    _leftImageView = leftImageView;
    _centerImageView = centerImageView;
    _rightImageView = rightImageView;
}

//点击事件
- (void)imageViewDidTap
{
    
    [self.netDelagate didSelectedNetImageAtIndex:_currentIndex];
    [self.localDelagate didSelectedLocalImageAtIndex:_currentIndex];
}

-(void)createPageControl
{
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0,SCREENH - pageSize,SCREENW, 8)];
    
    //设置页面指示器的颜色
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    //设置当前页面指示器的颜色
    pageControl.currentPageIndicatorTintColor = pageColor;
    pageControl.numberOfPages = _MaxImageCount;
    pageControl.currentPage = 0;
    
    [self addSubview:pageControl];
    
    _PageControl = pageControl;
}

#pragma mark - 定时器

- (void)setUpTimer
{
    if (_AutoScrollDelay < 0.5) return;//太快了
    
    _timer = [NSTimer timerWithTimeInterval:_AutoScrollDelay target:self selector:@selector(scorll) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)scorll
{
    [_scrollView setContentOffset:CGPointMake(_scrollView.contentOffset.x +SCREENW, 0) animated:YES];
}

#pragma mark - 给复用的imageView赋值

- (void)changeImageLeft:(NSInteger)LeftIndex center:(NSInteger)centerIndex right:(NSInteger)rightIndex
{
    if (_isNetworkImage)
    {
        
        [_leftImageView sd_setImageWithURL:[NSURL URLWithString:_imageArray[LeftIndex]] placeholderImage:_placeholderImage];
        [_centerImageView sd_setImageWithURL:[NSURL URLWithString:_imageArray[centerIndex]] placeholderImage:_placeholderImage];
        [_rightImageView sd_setImageWithURL:[NSURL URLWithString:_imageArray[rightIndex]] placeholderImage:_placeholderImage];
        
    }else
    {
        _leftImageView.image = _imageArray[LeftIndex];
        _centerImageView.image = _imageArray[centerIndex];
        _rightImageView.image = _imageArray[rightIndex];
    }
    
    [_scrollView setContentOffset:CGPointMake(SCREENW, 0)];
}

#pragma mark - 滚动代理

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self setUpTimer];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeTimer];
}

- (void)removeTimer
{
    if (_timer == nil) return;
    [_timer invalidate];
    _timer = nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //开始滚动，判断位置，然后替换复用的三张图
    [self changeImageWithOffset:scrollView.contentOffset.x];
}

- (void)changeImageWithOffset:(CGFloat)offsetX
{
    if (offsetX >= SCREENW * 2)
    {
        _currentIndex++;
        
        if (_currentIndex == _MaxImageCount-1)
        {
            [self changeImageLeft:_currentIndex-1 center:_currentIndex right:0];
            
        }else if (_currentIndex == _MaxImageCount)
        {
            
            _currentIndex = 0;
            
            [self changeImageLeft:_MaxImageCount-1 center:0 right:1];
            
        }else
        {
            [self changeImageLeft:_currentIndex-1 center:_currentIndex right:_currentIndex+1];
        }
        _PageControl.currentPage = _currentIndex;
        
    }
    
    if (offsetX <= 0)
    {
        _currentIndex--;
        
        if (_currentIndex == 0) {
            
            [self changeImageLeft:_MaxImageCount-1 center:0 right:1];
            
        }else if (_currentIndex == -1) {
            
            _currentIndex = _MaxImageCount-1;
            [self changeImageLeft:_currentIndex-1 center:_currentIndex right:0];
            
        }else {
            [self changeImageLeft:_currentIndex-1 center:_currentIndex right:_currentIndex+1];
        }
        
        _PageControl.currentPage = _currentIndex;
    }
}

-(void)dealloc
{
    [self removeTimer];
}

#pragma mark - set方法，设置间隔时间

- (void)setAutoScrollDelay:(NSTimeInterval)AutoScrollDelay
{
    _AutoScrollDelay = AutoScrollDelay;
    
    [self removeTimer];
    [self setUpTimer];
}


@end
