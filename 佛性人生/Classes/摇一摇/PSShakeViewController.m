//
//  PSShakeViewController.m
//  佛性人生
//
//  Created by sunny&pei on 2018/4/4.
//  Copyright © 2018年 sunny&pei. All rights reserved.
//

#import "PSShakeViewController.h"
#import "PSMenuViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <QuartzCore/QuartzCore.h>
#import "UIViewController+XWTransition.h"
#import "XWCircleSpreadAnimator.h"
@interface PSShakeViewController ()
@property(nonatomic,assign)SystemSoundID soundBeginID;
@property(nonatomic,assign)SystemSoundID soundEndID;
@property(nonatomic,strong)UIButton *menuBtn;
@property(nonatomic,strong)UIButton *backBtn;
@property(nonatomic,strong)UILabel *textLab;
@property(nonatomic,strong)NSMutableArray *mulArray;
@property(nonatomic,strong)UIImageView *bgView;
@property(nonatomic,strong)UIImageView *headView;
@end

@implementation PSShakeViewController
{
    FMDatabase *_database;
}

-(SystemSoundID)soundBeginID{
    if (_soundBeginID == 0) {
        //获取资源的URL，音频文件要放在黄色文件夹中shake_begin.wav
        //***并且需要导入到资源文件中 ，否则找不到
        NSString *path = [[NSBundle mainBundle] pathForResource:@"shake_begin" ofType:@"wav"];
        NSURL *shakeBeginUrl = [NSURL fileURLWithPath:path];
        //给soundBeginID赋值
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)(shakeBeginUrl), &_soundBeginID);
    }
    return _soundBeginID;
}
-(SystemSoundID)soundEndID{
    if (_soundEndID == 0) {
        //获取资源的URL，音频文件要放在黄色文件夹中
        //***并且需要导入到资源文件中 ，否则找不到
        NSURL *shakeEndUrl = [[NSBundle mainBundle] URLForResource:@"shake_end" withExtension:@"wav"];
        //给soundBeginID赋值
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)(shakeEndUrl), &_soundEndID);
    }
    return _soundEndID;
}
-(NSMutableArray *)mulArray{
    if (_mulArray == nil) {
        //返回数组
        _mulArray = [self returnResultArray];
    }
    return _mulArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //使控制器成为第一响应者，并且可以摇动
    [UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;
    [self becomeFirstResponder];
    //设置背景以及相关组件
    [self setAllSubViews];
//    NSArray *fontFamilies = [UIFont familyNames];
//    for (int i = 0; i < [fontFamilies count]; i++)
//    {
//        NSString *fontFamily = [fontFamilies objectAtIndex:i];
//        NSArray *fontNames = [UIFont fontNamesForFamilyName:[fontFamilies objectAtIndex:i]];
//        NSLog (@"%@: %@", fontFamily, fontNames);
//    }
//    2018-04-30 11:15:53.620750+0800 佛性人生[38442:35506412] MF LiHei (Noncommercial): (
//                                                                                    "MFLiHei_Noncommercial-Regular"
//                                                                                    )
}
- (void)setAllSubViews{
    _bgView = [[UIImageView alloc]init];
    _bgView.frame = self.view.frame;
    _bgView.userInteractionEnabled = YES;
    _bgView.contentMode = UIViewContentModeScaleToFill;
    _bgView.image = [UIImage imageNamed:@"bgShake"];
    [self.view addSubview:_bgView];
    //菜单
    _menuBtn  = [[UIButton alloc]init];
    _menuBtn.frame = CGRectMake(self.view.frame.size.width-50, 29, 24, 24);
    [_menuBtn setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    [_bgView addSubview:_menuBtn];
    [_menuBtn addTarget:self action:@selector(menuBtnClick) forControlEvents:UIControlEventTouchUpInside];
    //返回
    _backBtn = [[UIButton alloc]init];
    _backBtn.frame = CGRectMake(12, 29, 14, 24);
    [_backBtn setImage:[UIImage imageNamed:@"back1"] forState:UIControlStateNormal];
    [_bgView addSubview:_backBtn];
    [_backBtn addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    //添加Label
    
    
    
    _textLab = [[UILabel alloc]init];
//    _textLab.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    _textLab.textAlignment = NSTextAlignmentCenter;
    _textLab.frame = CGRectMake(0 , 82, self.view.frame.size.width, 50);
    _textLab.font = [UIFont fontWithName:@"MFLiHei_Noncommercial-Regular" size:35];
    _textLab.textColor = [UIColor whiteColor];
    _textLab.text = @"施主，请摇晃你的手机";
    _textLab.textAlignment = NSTextAlignmentCenter;
    [_bgView addSubview:_textLab];
    
}

/**
 点击进入摇一摇菜单选项栏
 */
-(void)menuBtnClick{
    XWCircleSpreadAnimator *animator = [XWCircleSpreadAnimator xw_animatorWithStartCenter:self.menuBtn.center radius:20];
    PSMenuViewController *menuVc = [[PSMenuViewController alloc]init];
    [self xw_presentViewController:menuVc withAnimator:animator];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -摇一摇相关方法
-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    if(motion == UIEventSubtypeMotionShake){
        
        //1.添加动画
        _headView = [[UIImageView alloc]init];
        _headView.frame = CGRectMake(100, 179, 179, 259);
        _headView.image = [UIImage imageNamed:@"head"];
        [self.view addSubview:_headView];
//        _headView.layer.anchorPoint = CGPointMake(0.5, 1.0);
        CABasicAnimation *swingAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        swingAnimation.duration = 0.5;
        CAMediaTimingFunction *mediaTiming = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        swingAnimation.timingFunction = mediaTiming;
        swingAnimation.repeatCount = 4.0;
        float fvalue = -M_PI/10.0;
        float evalue = M_PI/10.0;
        swingAnimation.fromValue = [NSNumber numberWithDouble:fvalue];
        swingAnimation.toValue = [NSNumber numberWithDouble:evalue];
        swingAnimation.autoreverses = YES;
        
        [_headView.layer addAnimation:swingAnimation forKey:nil];
        // 晃动次数
//        static int numberOfShakes = 4;
//        // 晃动幅度（相对于总宽度）
//        static float vigourOfShake = 0.04f;
//        // 晃动延续时常（秒）
//        static float durationOfShake = 0.5f;
//
//        CAKeyframeAnimation *shakeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
//        //关键帧（点）
//        CGPoint layerPosition = CGPointMake(190, 330);
//
//        // 起始点
//        NSValue *value1=[NSValue valueWithCGPoint:CGPointMake(190, 330)];
//        // 关键点数组
//        NSMutableArray *values = [[NSMutableArray alloc] initWithObjects:value1, nil];
//        for (int i = 0; i<numberOfShakes; i++) {
//            // 左右晃动的点
//            NSValue *valueLeft = [NSValue valueWithCGPoint:CGPointMake(layerPosition.x-self.view.frame.size.width*vigourOfShake*(1-(float)i/numberOfShakes), layerPosition.y)];
//            NSValue *valueRight = [NSValue valueWithCGPoint:CGPointMake(layerPosition.x+self.view.frame.size.width*vigourOfShake*(1-(float)i/numberOfShakes), layerPosition.y)];
//
//            [values addObject:valueLeft];
//            [values addObject:valueRight];
//        }
//        // 最后回归到起始点
//        [values addObject:value1];
//
//        shakeAnimation.values = values;
//        shakeAnimation.duration = durationOfShake;
//
//        [head.layer addAnimation:shakeAnimation forKey:kCATransition];
        //2.添加摇动声音
//        AudioServicesPlaySystemSound(self.soundBeginID);
        
        NSLog(@"正在摇动");
    }
    
}
-(void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    NSLog(@"取消摇动");
    
}
-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    
    NSLog(@"%@",NSStringFromCGRect(_headView.frame));
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"结束摇动");
        
        //需要判断 是否有数据 ，如果没有 需要提示
        self.mulArray = [self returnResultArray];
        if(self.mulArray.count == 0){
            [self motionCancelled:motion withEvent:event];
            //提示用户要去添加
            UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"还没选项" message:@"快去添加吧！" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alertVc animated:YES completion:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:nil];
            });
            return;
        }
        //2.添加摇动声音
//        AudioServicesPlaySystemSound(self.soundEndID);
        //3.显示结果
        _bgView.image = [UIImage imageNamed:@"bgShake"];
//        NSLog(@"%lu",(unsigned long)self.mulArray.count);
        int count = (int)self.mulArray.count;
        int i = arc4random() % count;
        _textLab.text = _mulArray[i];
        //4.设置震动
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    });
    
}
-(void)backButtonClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 读取数据库里面的数据
 @return 返回一个数组
 */
-(NSMutableArray *)returnResultArray{
    //获得document目录路径
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    //sql路径
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"model.sqlite"];
    //实例化FMDatabase对象
    _database = [FMDatabase databaseWithPath:filePath];
    [_database open];
    NSString *buddaSql = @"CREATE TABLE IF NOT EXISTS budda (id integer PRIMARY KEY AUTOINCREMENT, context text NOT NULL);";
    [_database executeUpdate:buddaSql];
    FMResultSet *result = [_database executeQuery:@"SELECT * FROM budda"];
    NSMutableArray *array = [NSMutableArray array];
    while ([result next]) {
        NSString *con = [result stringForColumn:@"context"];
        [array addObject:con];
    }
    return array;
}

@end
