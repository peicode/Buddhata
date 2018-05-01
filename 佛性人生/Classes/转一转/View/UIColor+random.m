//
//  UIColor+random.m
//  佛性人生
//
//  Created by sunny&pei on 2018/5/1.
//  Copyright © 2018年 sunny&pei. All rights reserved.
//

#import "UIColor+random.h"

@implementation UIColor (random)
+(UIColor *)randomColor{
    NSMutableArray *array = [NSMutableArray array];
    UIColor *color0 = [UIColor colorWithRed:61/255.0 green:205/255.0 blue:252/255.0 alpha:1];
    UIColor *color1 = [UIColor colorWithRed:254/255.0 green:210/255.0 blue:0 alpha:1];
    UIColor *color2 = [UIColor colorWithRed:254/255.0 green:149/255.0 blue:0 alpha:1];
    UIColor *color3 = [UIColor colorWithRed:254/255.0 green:90/255.0 blue:0 alpha:1];
    UIColor *color4 = [UIColor colorWithRed:254/255.0 green:0/255.0 blue:227/255.0 alpha:1];
    UIColor *color5 = [UIColor colorWithRed:161/255.0 green:0 blue:254/255.0 alpha:1];
    UIColor *color6 = [UIColor colorWithRed:102/255.0 green:0 blue:254/255.0 alpha:1];
    UIColor *color7 = [UIColor colorWithRed:0 green:84/255.0 blue:254/255.0 alpha:1];
    UIColor *color8 = [UIColor colorWithRed:61/255.0 green:160/255.0 blue:252/255.0 alpha:1];
    [array addObject:color0];
    [array addObject:color1];
    [array addObject:color2];
    [array addObject:color3];
    [array addObject:color4];
    [array addObject:color5];
    [array addObject:color6];
    [array addObject:color7];
    [array addObject:color8];
    int a = arc4random()%9;
    
    return array[a];
}
@end
