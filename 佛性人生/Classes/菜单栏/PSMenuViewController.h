//
//  PSMenuViewController.h
//  佛性人生
//
//  Created by sunny&pei on 2018/4/4.
//  Copyright © 2018年 sunny&pei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSTransViewController.h"
#import "PSShakeViewController.h"
@class PSShakeViewController,PSTransViewController;
static  NSString *const editcellID = @"editCell";
@interface PSMenuViewController : UIViewController
@property(nonatomic,weak)PSTransViewController *transVc;
@property(nonatomic,weak)PSShakeViewController *shakeVc;
@end
