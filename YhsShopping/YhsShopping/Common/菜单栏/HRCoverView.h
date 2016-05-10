//
//  HRCoverView.h
//  QQpopmenu
//
//  Created by admin on 16/4/16.
//  Copyright © 2016年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^task)(UIViewController *);

@interface HRCoverView : UIView

@property (nonatomic, copy) task jump;
@end
