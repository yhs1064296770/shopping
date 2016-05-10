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
#import "HRCoverView.h"

@interface YhsHomeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSArray *dataArr;

@property (nonatomic,assign) NSInteger cellType;

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

- (IBAction)clickRightItem:(id)sender {
    HRCoverView *cover = [[HRCoverView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    //跳转
    cover.jump = ^(UIViewController *vc){
        
        [self.navigationController pushViewController:vc animated:YES];
    };
    
    [self.tabBarController.view addSubview:cover];
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
    UIView *subView1 = [[YhsBaseHomeView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100) andDataArr:@[@"bg_crjyy.png" ,@"bg_jtwfcx.png"] clickHandler:^(NSInteger num) {
        NSLog(@"%ld",(long)num);
    }];
    
    __weak typeof(self) myself = self;
    UIView *subView2  = [[YhsBaseHomeView alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 44) andDataTitle:@[@"办事指南",@"出入境预约",@"网上返脏",@"违法查询",@"重名查询",@"求助咨询",@"违法举报",@"地图应用",@"查询审批",@"办证查询",@"失物认领"]  clickHandler:^(NSInteger num) {
        myself.cellType = num;
        NSLog(@"%ld",(long)num);
        [self.tableView reloadData];
    }];
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, subView1.frame.size.height+subView2.frame.size.height)];
    [headView addSubview:subView1];
    [headView addSubview:subView2];
    
    self.tableView.tableHeaderView = headView;
    
}

#pragma mark -- 设置cell的多少和cell的高度
- (NSInteger)section:(NSInteger)section andCellArr:(NSArray*)cellConts{
    for (int i =0; i<cellConts.count; i++) {
        if (section == i) {
            NSInteger num = [cellConts[i] integerValue];
            return num;
        }
    }
    return 0;
}


#pragma  UITableView代理  UITableViewDelegate,UITableViewDataSource

//根据有几种tableviewcell类型返回多少个分区
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [YhsCommon findAllOf:[YhsBaseHomeTableViewCell class]].count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"%ld",(long)self.cellType);
    switch (self.cellType) {
        case 101:
            return [self section:section andCellArr:@[@2,@2,@1,@3]];
            break;
        case 102:
            return [self section:section andCellArr:@[@3,@2,@1,@0]];
            break;
        case 103:
            return [self section:section andCellArr:@[@2,@1,@1,@1]];
            break;
        case 104:
            return [self section:section andCellArr:@[@2,@2,@4,@4]];
            break;
        case 105:
            return [self section:section andCellArr:@[@0,@2,@6]];
            break;
        case 106:
            return [self section:section andCellArr:@[@2,@0,@4]];
            break;
        case 107:
            return [self section:section andCellArr:@[@2,@2,@0]];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     return [self section:indexPath.section andCellArr:@[@44,@60,@50,@125]];
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
