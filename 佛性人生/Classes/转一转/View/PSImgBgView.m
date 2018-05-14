//
//  PSImgBgView.m
//  佛性人生
//
//  Created by sunny&pei on 2018/4/26.
//  Copyright © 2018年 sunny&pei. All rights reserved.
//

#import "PSImgBgView.h"
#import "PSBgView.h"
@implementation PSImgBgView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        _iconView = [[UIImageView alloc]init];
        if(SCREENW == 414){
            _iconView.frame = CGRectMake(0, 0, 369,369);
        }else if(SCREENH == 812){
            
            _iconView.frame = CGRectMake(0, 0, 360,360);
        }else{
           _iconView.frame = CGRectMake(0, 0, 334,334);
        }
        
        _iconView.userInteractionEnabled = YES;
        _btnView = [[UIImageView alloc]init];
        _btnView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnClick)];
        [_btnView addGestureRecognizer:tap];
        //设置背景图的尺寸
        _iconView.image = [UIImage imageNamed:@"zhuanpan"];
        //设置按钮的图片
        _btnView.frame = CGRectMake(self.bounds.size.width/2-81, self.bounds.size.height/2-81, 71, 119);
        _btnView.center = _iconView.center;
        _btnView.image = [UIImage imageNamed:@"strat"];
        [self addSubview:_iconView];
        [self addSubview:_btnView];
        
    }
    
    return self;
}
- (void)drawRect:(CGRect)rect {
    //画圆 截出圆形layer
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:self.bounds];
    CAShapeLayer *pathlayer = [CAShapeLayer layer];
    pathlayer.lineWidth = 2;
    pathlayer.fillColor = [UIColor colorWithRed:95/255.0 green:175/255.0 blue:246/255.0 alpha:1].CGColor;
    pathlayer.path = path.CGPath;
    self.layer.mask = pathlayer;
    self.layer.masksToBounds = YES;
    
}
/**
 监听旋转按钮的点击
 */
- (void)btnClick{
    if (self.delegete && [self.delegete respondsToSelector:@selector(judgeArrayNull)]) {
        if ([self.delegete judgeArrayNull] == NO) {
            return;
        }
    }
    [self startRotating];
    //概率 创造一个随机数（0，360）arc4random()%360
    self.lotteryPro = arc4random()%360;
    //设置转动圈数
    NSInteger circleNum = 6;
    CGFloat perAngle = M_PI/180.0;
    //核心动画
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    
    self.endAngle = 360*perAngle*circleNum+self.lotteryPro*perAngle;
    anim.toValue = [NSNumber numberWithFloat:self.endAngle];
    
    anim.duration = 3.0f;
    anim.delegate = self;
    //慢-快-慢
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    // 始终保持最新的效果
    anim.fillMode = kCAFillModeForwards;
    // 动画结束的时候，保持结束时的状态
    anim.removedOnCompletion = NO;
    self.anim = anim;
    
    //
    [self.iconView.layer addAnimation:anim forKey:@"rotation"];
//    [self.iconView.layer addObserver:self forKeyPath:@"transform" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
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
    self.iconView.transform = CGAffineTransformRotate(self.iconView.transform, M_PI_4/10);
}
- (void)stoprotating{
    [self.link invalidate];
    self.link = nil;
    
}
#pragma mark - 动画停止
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    if (self.delegete && [self.delegete respondsToSelector:@selector(sendRandomAngle:)]) {
        [self.delegete sendRandomAngle:self.lotteryPro];
    }
    [self stoprotating];
}
#pragma mark - KVO监听旋转角度的变化

@end
