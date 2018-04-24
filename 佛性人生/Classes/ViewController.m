//
//  ViewController.m
//  佛性人生
//
//  Created by sunny&pei on 2018/4/4.
//  Copyright © 2018年 sunny&pei. All rights reserved.
//

#import "ViewController.h"
#import "PSShakeViewController.h"
#import "UIViewController+XWTransition.h"
#import "XWCoolAnimator+XWMiddlePageFlip.h"
#import "XWCoolAnimator.h"
#import "PSTransController.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *shakeBtn;
- (IBAction)shakeBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *turnBtn;
- (IBAction)turnBtn:(UIButton *)sender;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.shakeBtn.frame= CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/2) ;
    
    self.turnBtn.frame = CGRectMake(0, self.view.frame.size.height/2, self.view.frame.size.width, self.view.frame.size.height/2);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)shakeBtnClick:(UIButton *)sender {
    XWCoolAnimator *animator = [XWCoolAnimator xw_animatorWithType:XWCoolTransitionAnimatorTypePageMiddleFlipFromBottom];
    PSShakeViewController *shakeVc = [[PSShakeViewController alloc]init];
    shakeVc.modalPresentationStyle = UIModalPresentationPageSheet;
    shakeVc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self xw_presentViewController:shakeVc withAnimator:animator];
}
- (IBAction)turnBtn:(UIButton *)sender {
    XWCoolAnimator *animator = [XWCoolAnimator xw_animatorWithType:XWCoolTransitionAnimatorTypePageMiddleFlipFromTop];
    PSTransController *transVc = [[PSTransController alloc]init];
    transVc.modalPresentationStyle = UIModalPresentationPageSheet;
    transVc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    [self xw_presentViewController:transVc withAnimator:animator];
}
@end
