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
@property(nonatomic,strong)UILabel *textLab;
@property(nonatomic,strong)NSMutableArray *mulArray;
@property(nonatomic,strong)UIImageView *bgView;
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
    
}
- (void)setAllSubViews{
    _bgView = [[UIImageView alloc]init];
    _bgView.frame = self.view.frame;
    _bgView.userInteractionEnabled = YES;
    _bgView.contentMode = UIViewContentModeScaleToFill;
    _bgView.image = [UIImage imageNamed:@"bgfo2"];
    [self.view addSubview:_bgView];
    
    
    _menuBtn  = [[UIButton alloc]init];
    _menuBtn.frame = CGRectMake(self.view.frame.size.width*0.5-20, self.view.frame.size.height*0.5+200, 40, 40);
    _menuBtn.layer.masksToBounds = YES;
    _menuBtn.layer.cornerRadius = 20;
    [_menuBtn setTitle:@"菜单" forState:UIControlStateNormal];
    _menuBtn.backgroundColor = [UIColor grayColor];
    [_bgView addSubview:_menuBtn];
    [_menuBtn addTarget:self action:@selector(menuBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //添加Label
    
    
    
    _textLab = [[UILabel alloc]init];
//    _textLab.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    _textLab.textAlignment = NSTextAlignmentCenter;
    _textLab.frame = CGRectMake(self.view.frame.size.width/2-100, self.view.frame.size.height/2-25, 200, 50);
    _textLab.font = [UIFont fontWithName:@"Hiragino Maru Gothic ProN" size:40];
    _textLab.textColor = [UIColor whiteColor];
    
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
        //这时候要重新加载一下数据库数据
        //1.添加动画
        
        //2.添加摇动声音
//        AudioServicesPlaySystemSound(self.soundBeginID);
        
        NSLog(@"正在摇动");
    }
    
}
-(void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    NSLog(@"取消摇动");
    
}
-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    
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
        //显示背景图   需要 逐渐显示  出来
        int l = arc4random() % 3;
        NSString *imgName = [NSString stringWithFormat:@"bg%d",l];
        [UIView animateWithDuration:1.0 animations:^{
            
            _bgView.image = [UIImage imageNamed:imgName];
        }];
        

//        NSLog(@"%lu",(unsigned long)self.mulArray.count);
        int count = (int)self.mulArray.count;
        int i = arc4random() % count;
        _textLab.text = _mulArray[i];
        //4.设置震动
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    });
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
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
