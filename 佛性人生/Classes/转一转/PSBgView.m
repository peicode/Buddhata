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
//    UIBezierPath *line1 = [UIBezierPath bezierPath];
    
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    return self;
}
-(void)drawRect:(CGRect)rect{
    UIColor *color = [UIColor redColor];
    [color set];//设置线条颜色
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(self.frame.size.width/2, self.frame.size.height)];
    [path stroke];
}
@end
