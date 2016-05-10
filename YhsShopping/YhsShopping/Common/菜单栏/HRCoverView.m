//
//  HRCoverView.m
//  QQpopmenu
//
//  Created by admin on 16/4/16.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "HRCoverView.h"

@interface HRCoverView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *imagesArr;

@property (nonatomic, strong) NSArray *labelArr;
@end

@implementation HRCoverView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        self.backgroundColor = [UIColor clearColor];
        
        UITableView *tableView = [[UITableView alloc] init];
        
        tableView.layer.cornerRadius = 5;
        tableView.scrollEnabled = NO;
        
        tableView.delegate = self;
        
        tableView.dataSource = self;
        
        tableView.separatorColor = [UIColor grayColor];
            //设置分割线在cell的图片下面
        tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        tableView.tableFooterView = [[UIView alloc] init];
        
        [self addSubview:tableView];
        
            _tableView = tableView;
        
      
        
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.imagesArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.imageView.image = self.imagesArr[indexPath.row];
    cell.textLabel.text = self.labelArr[indexPath.row];
    return cell;
}



#pragma make- 布局
- (void)layoutSubviews{
    
    CGRect rect = self.tableView.frame;
    
    rect.size.width = 165;
    rect.size.height = self.imagesArr.count *45;
    rect.origin.y = 80;
    rect.origin.x = self.bounds.size.width - rect.size.width;
    
    self.tableView.frame = rect;
    
    
    

}
    //画三角形
- (void)drawRect:(CGRect)rect{
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextMoveToPoint(ctx, self.bounds.size.width - 20, 60);
    CGContextAddLineToPoint(ctx, self.bounds.size.width - 30, 80);
    CGContextAddLineToPoint(ctx, self.bounds.size.width-10, 80);
    CGContextAddLineToPoint(ctx, self.bounds.size.width-20, 60);
    [[UIColor whiteColor] set];
    
    CGContextFillPath(ctx);
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        //取消选中效果
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    HRFriendController *vc = [[HRFriendController alloc] init];
    
    if (self.jump) {
        self.jump(nil);
    }
    [self removeFromSuperview];
}

#pragma make-懒加载
- (NSArray *)imagesArr{
    
    if (!_imagesArr) {
        _imagesArr = @[
                [UIImage imageNamed:@"right_menu_addFri@3x.png"],
                [UIImage imageNamed:@"right_menu_facetoface@3x.png"],
                [UIImage imageNamed:@"right_menu_multichat@3x.png"],
                [UIImage imageNamed:@"right_menu_payMoney@3x.png"],
                [UIImage imageNamed:@"right_menu_QR@3x.png"],
                [UIImage imageNamed:@"right_menu_sendFile@3x.png"]
                ];
    }
    return _imagesArr;
}

#pragma make -懒加载

- (NSArray *)labelArr{

    if (!_labelArr) {
        _labelArr = @[@"添加好友",@"面对面快传",@"创建讨论组",@"收钱",@"扫一扫",@"发送到电脑"];
    }
    return _labelArr;
}

// 一旦触摸此视图变回从父控件中移除
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [UIView animateWithDuration:0.5 animations:^{
        self.transform = CGAffineTransformMakeScale(0.01, 0.01);
            //缩小到指定的位置
        self.center = CGPointMake([UIScreen mainScreen].bounds.size.width-20,64);
        
    }completion:^(BOOL finished) {
         [self removeFromSuperview];
    }];
    
}

@end
