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
#import "PSTransViewController.h"
@interface ViewController ()
@property (strong, nonatomic)UIButton *shakeBtn;
@property (strong, nonatomic)UIButton *turnBtn;


@end

@implementation ViewController
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.shakeBtn = [[UIButton alloc]init];
    self.turnBtn = [[UIButton alloc]init];
    if (SCREENH == 812) {
        self.shakeBtn.frame= CGRectMake(0, 0, PSSCREENW, 406) ;
        [self.shakeBtn setImage:[UIImage imageNamed:@"shakeX"] forState:UIControlStateNormal];
        self.turnBtn.frame = CGRectMake(0, 406, PSSCREENW, 406);
        [self.turnBtn setImage:[UIImage imageNamed:@"turn_ipX"] forState:UIControlStateNormal];
    }else if(SCREENW == 375 || SCREENW == 414){
        self.shakeBtn.frame= CGRectMake(0, 0, PSSCREENW, PSSCREENH/2) ;
        [self.shakeBtn setImage:[UIImage imageNamed:@"shake"] forState:UIControlStateNormal];
        self.turnBtn.frame = CGRectMake(0, self.view.frame.size.height/2, self.view.frame.size.width, self.view.frame.size.height/2);
        [self.turnBtn setImage:[UIImage imageNamed:@"turn"] forState:UIControlStateNormal];
    }else{
        self.shakeBtn.frame= CGRectMake(0, 0, PSSCREENW, PSSCREENH/2) ;
        [self.shakeBtn setBackgroundImage:[UIImage imageNamed:@"shake"] forState:UIControlStateNormal];
//        self.shakeBtn.imageView
        self.turnBtn.frame = CGRectMake(0, self.view.frame.size.height/2, self.view.frame.size.width, self.view.frame.size.height/2);
        [self.turnBtn setBackgroundImage:[UIImage imageNamed:@"turn"] forState:UIControlStateNormal];
    }
    [self.view addSubview:self.shakeBtn];
    [self.view addSubview:self.turnBtn];
    
    [self.shakeBtn addTarget:self action:@selector(shakeBtnClick:) forControlEvents:UIControlEventTouchDown];
    [self.turnBtn addTarget:self action:@selector(turnBtn:) forControlEvents:UIControlEventTouchDown];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)shakeBtnClick:(UIButton *)sender {
    XWCoolAnimator *animator = [XWCoolAnimator xw_animatorWithType:XWCoolTransitionAnimatorTypePageMiddleFlipFromBottom];
    PSShakeViewController *shakeVc = [[PSShakeViewController alloc]init];
//    shakeVc.modalPresentationStyle = UIModalPresentationPageSheet;
//    shakeVc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//    [self presentViewController:shakeVc animated:YES completion:nil];
    [self xw_presentViewController:shakeVc withAnimator:animator];
}
- (void)turnBtn:(UIButton *)sender {
    XWCoolAnimator *animator = [XWCoolAnimator xw_animatorWithType:XWCoolTransitionAnimatorTypePageMiddleFlipFromTop];
    PSTransViewController *transVc = [[PSTransViewController alloc]init];
//    transVc.modalPresentationStyle = UIModalPresentationPageSheet;
//    transVc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//
    [self xw_presentViewController:transVc withAnimator:animator];
}
@end
