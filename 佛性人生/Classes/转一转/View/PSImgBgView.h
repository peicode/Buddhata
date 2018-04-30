//
//  PSImgBgView.h
//  佛性人生
//
//  Created by sunny&pei on 2018/4/26.
//  Copyright © 2018年 sunny&pei. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PSImgDelegate<NSObject>
@optional
-(void)sendRandomAngle: (float )angle;
@end
@interface PSImgBgView : UIView<CAAnimationDelegate>
@property(nonatomic,strong)UIImageView *iconView;
@property(nonatomic,strong)UIImageView *btnView;
@property(nonatomic,strong)CADisplayLink *link;
@property(nonatomic,strong)CABasicAnimation *anim;
@property(nonatomic,assign)float endAngle;
@property(nonatomic,weak)id<PSImgDelegate> delegete;
@end
