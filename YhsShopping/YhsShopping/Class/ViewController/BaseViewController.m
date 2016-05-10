//
//  BaseViewController.m
//  YhsShopping
//
//  Created by 姚海深 on 16/5/6.
//  Copyright © 2016年 姚海深. All rights reserved.
//

#import "BaseViewController.h"
#define COLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  导航条
 */
- (void)setNavigation:(NSString *)title rightButton:(NSString *)rightTitle andNeedLeftButton:(BOOL) leftNeed{
    self.title = title;
    
    //设置NavigationBar背景颜色
    [[UINavigationBar appearance] setBarTintColor:COLOR(32, 152, 243)];
    //@{}代表Dictionary
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 25, 25);
    [leftButton setImage:[UIImage imageNamed:@"Unknown"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    if (leftNeed) {
        self.navigationItem.leftBarButtonItem = left;
    }else{
        self.navigationItem.leftBarButtonItem = nil;
    }
    
    if (!(rightTitle == nil || [rightTitle isEqualToString:@""])) {
    
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.frame = CGRectMake(0, 0, 25, 25);
        if ([rightTitle hasPrefix:@"img:"]) {
            [rightButton setImage:[UIImage imageNamed:[rightTitle substringFromIndex:4]] forState:UIControlStateNormal];
        }else{
            [rightButton setTitle:rightTitle forState:UIControlStateNormal];
        }
        [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        rightButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
        self.navigationItem.rightBarButtonItem = right;
    }
}
- (void)leftClick:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightClick:(UIButton *)button{
    
}

@end
