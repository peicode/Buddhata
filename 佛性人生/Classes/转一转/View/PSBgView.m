//
//  PSBgView.m
//  佛性人生
//
//  Created by sunny&pei on 2018/4/19.
//  Copyright © 2018年 sunny&pei. All rights reserved.
//

#import "PSBgView.h"
#import <QuartzCore/QuartzCore.h>

@implementation PSBgView
//static CGFloat * const linex = self.frame.size.width/2;
-(void)layoutSubviews{
    
    _label.frame = CGRectMake(0, 10, self.bounds.size.width, 20);
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    _label = [[UILabel alloc]init];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.text = @"廖佩志";
    _label.font = [UIFont systemFontOfSize:12];
    [_label sizeToFit];

    [self addSubview:_label];
    return self;
}
-(void)drawRect:(CGRect)rect{
    UIColor *color = [UIColor whiteColor];
    [color set];//设置线条颜色
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint center =CGPointMake(self.bounds.size.width/2, self.bounds.size.height);
    [path moveToPoint:center];
    [path addLineToPoint:center];
    [path addLineToPoint:CGPointMake(self.bounds.size.width, 0)];
    [path addLineToPoint:CGPointMake(0, 0)];
    [path fill];
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    lineLayer.lineWidth = 1;
    lineLayer.strokeColor = [UIColor whiteColor].CGColor;
    lineLayer.path = path.CGPath;
//    [self.layer addSublayer:lineLayer];
    self.layer.mask = lineLayer;
}
@end
