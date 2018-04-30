//
//  PSTransViewController.m
//  佛性人生
//
//  Created by sunny&pei on 2018/4/26.
//  Copyright © 2018年 sunny&pei. All rights reserved.
//

#import "PSTransViewController.h"
#import "UIViewController+XWTransition.h"
#import "XWCircleSpreadAnimator.h"
#import "PSMenuViewController.h"
#import "PSBgView.h"
#import "PSImgBgView.h"
@interface PSTransViewController ()<CAAnimationDelegate,PSImgDelegate>
@property(nonatomic,strong)PSImgBgView *bgView;
@property(nonatomic,strong)UIButton *menuBtn;
@property(nonatomic,strong)UILabel *resultLab;
@property(nonatomic,strong)NSMutableArray *turnArray;
@property(nonatomic,strong)UIImageView *BGImageView;
@end

@implementation PSTransViewController
{
    FMDatabase *_database;
}
-(NSMutableArray *)turnArray{
    if (_turnArray== nil) {
        _turnArray = [self returnResultArray];
    }
    return _turnArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _BGImageView = [[UIImageView alloc]init];
    _BGImageView.frame = CGRectMake(0, 0, PSSCREENW, PSSCREENH);
    _BGImageView.image = [UIImage imageNamed:@"bgTurn"];
    [self.view addSubview:_BGImageView];
    [self setupMainUI];
    [self setupOtherUI];
}
/**
 转盘界面 (添加转盘上的组件)
 */
-(void)setupMainUI{
    _bgView = [[PSImgBgView alloc]init];
    _bgView.frame = CGRectMake(0, 0, 286, 286);
    _bgView.center = self.view.center;
    _bgView.delegete = self;
    [self.view addSubview:_bgView];
    //添加uilabel
    //获取转盘上所需总数
        int count = (int)self.turnArray.count;
    //旋转的度数   360/count
    for (int i = 0; i< count; i++) {
        //背景图的半径
        //        float radius = _bgImgView.bounds.size.width/2;
        float radius = self.bgView.iconView.bounds.size.width/2+30;
        //每一个label旋转的弧度
        CGFloat angle = ((360.0/count)*i)/180.0*M_PI;
        //求出每个角度的余弦值
        //计算label的宽
        double a = 1-cos(360.0/count/180.0*M_PI);
        float width = (float)sqrt(2*radius*radius*a);
        float height = radius*cos(180.0/count/180.0*M_PI);
        //*****测试代码
        PSBgView *bg = [[PSBgView alloc]init];
        //        bg.backgroundColor = [UIColor redColor];
        bg.bounds = CGRectMake(0, 0, width, height);
        //        NSLog(@"----%d---%@",i,NSStringFromCGRect(bg.frame));
        bg.layer.anchorPoint = CGPointMake(0.5, 1.0);
        bg.layer.position = CGPointMake(self.bgView.iconView.bounds.size.width*0.5,self.bgView.iconView.bounds.size.height*0.5);
        bg.center = CGPointMake(CGRectGetHeight(self.bgView.iconView.bounds)/2, CGRectGetHeight(self.bgView.iconView.bounds)/2);
        bg.label.text = [NSString stringWithFormat:@"%@", self.turnArray[i]];
        bg.transform = CGAffineTransformMakeRotation(angle);
        [self.bgView.iconView addSubview:bg];
    }
}
-(void)setupOtherUI{
    //菜单
    _menuBtn  = [[UIButton alloc]init];
    _menuBtn.frame = CGRectMake(self.view.frame.size.width-50, 29, 24, 24);
    [_menuBtn setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    [self.view addSubview:_menuBtn];
    [_menuBtn addTarget:self action:@selector(menuBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //返回按钮
    UIButton *backBtn  = [[UIButton alloc]initWithFrame:CGRectMake(12, 29, 14, 24)];
//    [backBtn setTitle:@"BACK" forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"back1"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:backBtn];
    //显示结果
    _resultLab = [[UILabel alloc]init];
    _resultLab.frame = CGRectMake(0, 0, PSSCREENW, 35);
    _resultLab.center = CGPointMake(self.view.frame.size.width*0.5, self.bgView.frame.origin.y-30);
    _resultLab.font = [UIFont fontWithName:@"MFLiHei_Noncommercial-Regular" size:35];
    _resultLab.textColor = [UIColor whiteColor];
    _resultLab.textAlignment = NSTextAlignmentCenter;
//    _resultLab.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:_resultLab];
}
/**
 点击进入转盘菜单选项栏
 */
-(void)menuBtnClick{
    //****需要看 是否导入了头文件
    XWCircleSpreadAnimator *animator = [XWCircleSpreadAnimator xw_animatorWithStartCenter:self.menuBtn.center radius:20];
    PSMenuViewController *conVc = [[PSMenuViewController alloc]init];
    conVc.transVc = self;
    [self xw_presentViewController:conVc withAnimator:animator];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 返回按钮
 */
- (void)backBtnClick{
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
/**
 强制刷新 子控件
 */
-(void)refreshUILabelFormBGView{
    [self.bgView removeFromSuperview];
    //需要刷新
    self.turnArray = [self returnResultArray];
    [self setupMainUI];
}

/**
 这里显示结果
 */
-(void)sendRandomAngle:(float)angle1{
    int count = (int)self.turnArray.count;
    float a = 360.0/count;
    a = a/2;
    float angle = angle1;
    NSLog(@"%f",angle);
    int b = angle/a;
    int c = (int)angle%(int)a;
    NSLog(@"%d",b);
    NSLog(@"%d",c);
    if (angle<a) {
        self.resultLab.text = self.turnArray[0];
    }else{
        if (c == 0) {
            self.resultLab.text = self.turnArray[count-b/2];
        }else{
            self.resultLab.text = self.turnArray[count-b/2-1];
        }
    }
    
    
    
}
@end

