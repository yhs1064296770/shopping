//
//  YhsHomeViewController.m
//  YhsShopping
//
//  Created by 姚海深 on 16/5/6.
//  Copyright © 2016年 姚海深. All rights reserved.
//

#import "YhsHomeViewController.h"
#import "YhsBaseHomeView.h"
#import "YhsHomeModel.h"
#import "YhsCommon.h"

@interface YhsHomeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSArray *dataArr;

@end

@implementation YhsHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self baseSetting];
}

/**
 *  基础设置
 */
- (void)baseSetting{
    
    [self tableViewSetting];
    
}

/**
 *  UITableView基础设置：Cell的注册
 */
- (void)tableViewSetting{
    
    //获取YhsBaseHomeTableViewCell的类注册Cell
    for (NSString *tableViewCell in [YhsCommon findAllOf:[YhsBaseHomeTableViewCell class]]) {
        [self.tableView registerNib:[UINib nibWithNibName:tableViewCell bundle:nil] forCellReuseIdentifier:tableViewCell];
    }
    
    //设置tableview的headerview
    self.tableView.tableHeaderView = [[YhsBaseHomeView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100) andDataArr:@[@"bg_crjyy.png" ,@"bg_jtwfcx.png"] clickHandler:^(NSInteger num) {
        NSLog(@"%ld",(long)num);
    }];
}


#pragma  UITableView代理  UITableViewDelegate,UITableViewDataSource

//根据有几种tableviewcell类型返回多少个分区
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [YhsCommon findAllOf:[YhsBaseHomeTableViewCell class]].count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 4;
            break;
        case 2:
            return 1;
            break;
            
        default:
            break;
    }
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YhsBaseHomeTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:[YhsCommon findAllOf:[YhsBaseHomeTableViewCell class]][indexPath.section]];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:[YhsCommon findAllOf:[YhsBaseHomeTableViewCell class]][indexPath.section] owner:self options:nil].lastObject;
    }
    YhsHomeModel  *model = self.dataArr[0];
    cell.YhsHomeLabel0.text = model.label0;
    cell.YhsHomeLabel1.text = model.label1;
    [cell.YhsHomeButton0 setTitle:model.button0 forState:UIControlStateNormal];
    return cell;
}

- (NSArray *)dataArr {
	if(_dataArr == nil) {
        YhsHomeModel  *model = [YhsHomeModel new];
        model.label0 = @"wocao";
        model.label1 = @"shab";
        model.button0 = @"anniu";
        _dataArr = [NSArray arrayWithObject:model];
	}
	return _dataArr;
}

@end
