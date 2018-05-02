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
    UIColor *color0 = [UIColor colorWithRed:254/255.0 green:221/255.0 blue:0 alpha:1];
    UIColor *color1 = [UIColor colorWithRed:253/255.0 green:195/255.0 blue:70/255.0 alpha:1];
    UIColor *color2 = [UIColor colorWithRed:252/255.0 green:88/255.0 blue:115/255.0 alpha:1];
    UIColor *color3 = [UIColor colorWithRed:201/255.0 green:93/255.0 blue:231/255.0 alpha:1];
    UIColor *color4 = [UIColor colorWithRed:125/255.0 green:93/255.0 blue:231/255.0 alpha:1];
    UIColor *color5 = [UIColor colorWithRed:50/255.0 green:161/255.0 blue:230/255.0 alpha:1];
    UIColor *color6 = [UIColor colorWithRed:88/255.0 green:199/255.0 blue:236/255.0 alpha:1];
    UIColor *color7 = [UIColor colorWithRed:58/255.0 green:209/255.0 blue:156/255.0 alpha:1];
    UIColor *color8 = [UIColor colorWithRed:109/255.0 green:221/255.0 blue:69/255.0 alpha:1];
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
+(NSMutableArray *)returnColorArray{
    NSMutableArray *array = [NSMutableArray array];
    UIColor *color0 = [UIColor colorWithRed:254/255.0 green:221/255.0 blue:0 alpha:1];
    UIColor *color1 = [UIColor colorWithRed:253/255.0 green:195/255.0 blue:70/255.0 alpha:1];
    UIColor *color2 = [UIColor colorWithRed:252/255.0 green:88/255.0 blue:115/255.0 alpha:1];
    UIColor *color3 = [UIColor colorWithRed:201/255.0 green:93/255.0 blue:231/255.0 alpha:1];
    UIColor *color4 = [UIColor colorWithRed:125/255.0 green:93/255.0 blue:231/255.0 alpha:1];
    UIColor *color5 = [UIColor colorWithRed:50/255.0 green:161/255.0 blue:230/255.0 alpha:1];
    UIColor *color6 = [UIColor colorWithRed:88/255.0 green:199/255.0 blue:236/255.0 alpha:1];
    UIColor *color7 = [UIColor colorWithRed:58/255.0 green:209/255.0 blue:156/255.0 alpha:1];
    UIColor *color8 = [UIColor colorWithRed:109/255.0 green:221/255.0 blue:69/255.0 alpha:1];
    [array addObject:color0];
    [array addObject:color1];
    [array addObject:color2];
    [array addObject:color3];
    [array addObject:color4];
    [array addObject:color5];
    [array addObject:color6];
    [array addObject:color7];
    [array addObject:color8];
    return array;
}
@end
