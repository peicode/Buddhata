//
//  PSTransController.m
//  佛性人生
//
//  Created by sunny&pei on 2018/4/11.
//  Copyright © 2018年 sunny&pei. All rights reserved.
//

#import "PSTransController.h"
#import "UIViewController+XWTransition.h"
#import "XWCircleSpreadAnimator.h"
#import "PSMenuViewController.h"
#import "PSBgView.h"
@interface PSTransController ()<CAAnimationDelegate>
@property(nonatomic,strong)UIImageView *bgImgView;
@property(nonatomic,strong)CADisplayLink *link;
@property(nonatomic,strong)CABasicAnimation *anim;
@property(nonatomic,strong)UIButton *menuBtn;
@property(nonatomic,strong)NSMutableArray *turnArray;
@property(nonatomic,strong)UIImageView *btnImgView;
@property(nonatomic,strong)UILabel *resultLab;
@end

@implementation PSTransController
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
    /**
     用于测试代码
     **/
//    PSBgView *bg = [[PSBgView alloc]init];
//    bg.frame = CGRectMake(0, 0, 50, 100);
//    bg.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:bg];
    
    
    //////
    //添加按钮
    _menuBtn  = [[UIButton alloc]init];
    _menuBtn.frame = CGRectMake(self.view.frame.size.width*0.5-20, self.view.frame.size.height-100, 40, 40);
    _menuBtn.layer.masksToBounds = YES;
    _menuBtn.layer.cornerRadius = 20;
    [_menuBtn setTitle:@"菜单" forState:UIControlStateNormal];
    _menuBtn.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_menuBtn];
    [_menuBtn addTarget:self action:@selector(menuBtnClick) forControlEvents:UIControlEventTouchUpInside];
    //添加背景
    [self setAllUI];
    //添加GO按钮图片
    UIImageView *btnimage = [[UIImageView alloc]initWithFrame:CGRectMake(PSSCREENW/2-81, PSSCREENH/2-81, 81, 81)];
    btnimage.center = _bgImgView.center;
    btnimage.image = [UIImage imageNamed:@"sure"];
    [self.view addSubview:btnimage];
    btnimage.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnClick)];
    [btnimage addGestureRecognizer:tap];
    self.btnImgView = btnimage;
    //返回按钮
    UIButton *backBtn  = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2,100 , 100, 40)];
    [backBtn setTitle:@"BACK" forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:backBtn];
    //显示结果
    _resultLab = [[UILabel alloc]init];
    _resultLab.frame = CGRectMake(0, 0, 100, 30);
    _resultLab.center = CGPointMake(self.view.frame.size.width*0.5, self.bgImgView.frame.origin.y-30);
    
    _resultLab.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:_resultLab];
}
#pragma mark ---设置UI控件
- (void)setAllUI{
    
    _bgImgView = [[UIImageView alloc]init];
    _bgImgView.frame = CGRectMake(0, 0, 280, 280);
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:_bgImgView.bounds];
    CAShapeLayer *pathlayer = [CAShapeLayer layer];
    pathlayer.lineWidth = 1;
//    pathlayer.strokeColor
    pathlayer.path = path.CGPath;
    _bgImgView.layer.mask = pathlayer;
    _bgImgView.image = [UIImage imageNamed:@"LuckyBaseBackground"];
    _bgImgView.center = self.view.center;
//    _bgImgView.layer.cornerRadius = 286;
    _bgImgView.layer.masksToBounds = YES;
    [self.view addSubview:_bgImgView];
    _bgImgView.userInteractionEnabled = YES;
    
    //添加uilabel
    //获取转盘上所需总数
    int count = (int)self.turnArray.count;
    //旋转的度数   360/count
    
    for (int i = 0; i< count; i++) {
//        UILabel *label = [[UILabel alloc]init];
        //背景图的半径
//        float radius = _bgImgView.bounds.size.width/2;
        float radius = _bgImgView.bounds.size.width/2+30;
        //每一个label旋转的弧度
        CGFloat angle = ((360/count)*i)/180.0*M_PI;
        
        //求出每个角度的余弦值
        //        CGFloat tank = cosf(radius*2*M_PI/count);
        //计算label的宽
        double a = 1-cos(360/count/180.0*M_PI);
        float width = (float)sqrt(2*radius*radius*a)+1;
        float height = radius*cos(180/count/180.0*M_PI);
//        label.bounds = CGRectMake(0, 0, width, radius);
//        label.layer.anchorPoint = CGPointMake(0.5, 1.0);
//        label.layer.position = CGPointMake(_bgImgView.frame.size.width*0.5, _bgImgView.frame.size.height*0.5);
//        label.center = CGPointMake(CGRectGetHeight(_bgImgView.frame)/2, CGRectGetHeight(_bgImgView.frame)/2);
//        label.text = [NSString stringWithFormat:@"%@", self.turnArray[i]];
//        label.textColor = [UIColor whiteColor];
//        label.textAlignment = NSTextAlignmentCenter;
//        label.font = [UIFont boldSystemFontOfSize:14];
//
//        label.transform = CGAffineTransformMakeRotation(angle);
//        [_bgImgView addSubview:label];
        //*****测试代码
        PSBgView *bg = [[PSBgView alloc]init];
//        bg.backgroundColor = [UIColor redColor];
        bg.bounds = CGRectMake(0, 0, width, height);
        NSLog(@"----%d---%@",i,NSStringFromCGRect(bg.frame));
        bg.layer.anchorPoint = CGPointMake(0.5, 1.0);
        bg.layer.position = CGPointMake(_bgImgView.bounds.size.width*0.5,_bgImgView.bounds.size.height*0.5);
        bg.center = CGPointMake(CGRectGetHeight(_bgImgView.bounds)/2, CGRectGetHeight(_bgImgView.bounds)/2);
        bg.label.text = [NSString stringWithFormat:@"%@", self.turnArray[i]];
        bg.transform = CGAffineTransformMakeRotation(angle);
        [_bgImgView addSubview:bg];
    }
}
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{

    //self.turnArray = [self returnResultArray];
    [self stoprotating];
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
    [self.anim removeObserver:self forKeyPath:@"toValue"];
}

/**
 返回按钮
 */
- (void)backBtnClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}
/**
   监听旋转按钮的点击
 */
- (void)btnClick{
//    NSLog(@"%lu",(unsigned long)self.turnArray.count);
    [self startRotating];
    
    //概率
    NSInteger lotteryPro = arc4random()%360;
//    NSLog(@"随机数是----%ld",(long)lotteryPro);
    //设置转动圈数
    NSInteger circleNum = 6;
    CGFloat perAngle = M_PI/180.0;
//    NSLog(@"perangleis------%f",perAngle);
    //核心动画
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    //KVO 监听核心动画转动多少弧度 ----test
    [anim addObserver:self forKeyPath:@"toValue" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    float endAngle = 360*perAngle*circleNum+lotteryPro*perAngle;
//    NSLog(@"最终概率是----%f",endAngle/M_PI*180);
    anim.toValue = [NSNumber numberWithFloat:endAngle];
    
    anim.duration = 3.0f;
    anim.delegate = self;
    //慢-快-慢
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    // 始终保持最新的效果
    anim.fillMode = kCAFillModeForwards;
     // 动画结束的时候，保持结束时的状态
    anim.removedOnCompletion = NO;
    self.anim = anim;
 
    //    [NSNotificationCenter defaultCente;r] add;
    //
    [_bgImgView.layer addAnimation:anim forKey:@"rotation"];
}
#pragma mark - KVO监听旋转角度的变化
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if([keyPath isEqualToString:@"toValue"]){
    NSLog(@"%@--%@--is changed",object,keyPath);
    NSLog(@"%@",change);
    id newA = [change valueForKey:@"new"];
    NSLog(@"%@",newA);
    }
}


/**
 开始旋转  屏幕刷新率相同的频率将内容画到屏幕上的定时器。
 */
- (void)startRotating{
    if (self.link) {
        return;
    }
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(update)];
    
    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    self.link = link;
}
- (void)update{
    self.bgImgView.transform = CGAffineTransformRotate(self.bgImgView.transform, M_PI_4/10);
}
- (void)stoprotating{
    [self.link invalidate];
    self.link = nil;
    
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
-(void)refreshUILabelFormBG{
    [self.bgImgView removeFromSuperview];
    
    //需要刷新
    self.turnArray = [self returnResultArray];
//    NSLog(@"%lu",self.turnArray.count);
    [self setAllUI];
    [self.view bringSubviewToFront:_btnImgView];
}
-(void)setLabels{
    //添加uilabel
    //获取转盘上所需总数
    int count = (int)self.turnArray.count;
    //旋转的度数   360/count
    
    for (int i = 0; i< count; i++) {
        //        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, M_PI*CGRectGetHeight(_bgImgView.frame)/count, CGRectGetHeight(_bgImgView.frame)*3/5)];
        UILabel *label = [[UILabel alloc]init];
        //        label.bounds = CGRectMake(0, 0, M_PI*CGRectGetHeight(_bgImgView.frame)/count, CGRectGetHeight(_bgImgView.frame)*3/5);
        //背景图的半径
        float radius = _bgImgView.frame.size.width/2-10;
        //每一个label旋转的弧度
        CGFloat angle = ((360/count)*i)/180.0*M_PI;
        //        cosf(<#float#>);
        //求出每个角度的余弦值
        //        CGFloat tank = cosf(radius*2*M_PI/count);
        //计算label的宽
        double a = 1-cos(360/count/180.0*M_PI);
        float width = (float)sqrt(2*radius*radius*a)/2+10;
        label.bounds = CGRectMake(0, 0, width, radius);
        label.layer.anchorPoint = CGPointMake(0.5, 1.0);
        label.layer.position = CGPointMake(_bgImgView.frame.size.width*0.5, _bgImgView.frame.size.height*0.5);
        label.center = CGPointMake(CGRectGetHeight(_bgImgView.frame)/2, CGRectGetHeight(_bgImgView.frame)/2);
        label.text = [NSString stringWithFormat:@"%@", self.turnArray[i]];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:14];
        
        label.transform = CGAffineTransformMakeRotation(angle);
        [_bgImgView addSubview:label];
    }
}
@end
