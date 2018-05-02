//
//  PSBgView.h
//  佛性人生
//
//  Created by sunny&pei on 2018/4/19.
//  Copyright © 2018年 sunny&pei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSBgView : UIView

@property(nonatomic,strong)UIImageView *bgImgView;
@property(nonatomic,strong)NSMutableArray *turnArray;
@property(nonatomic,strong)UILabel *label;
@property(nonatomic,assign)int num;
//设置转盘上填充的颜色
-(void)bringCount:(int)count;
@end
