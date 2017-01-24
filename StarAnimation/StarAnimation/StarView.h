//
//  AppDelegate.h
//  StarAnimation
//
//  Created by 李鹏跃 on 17/1/24.
//  Copyright © 2017年 13lipengyue. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface StarView : UIView
/**半径*/
@property(nonatomic) CGFloat radius;
/**填充 范围 0到1*/
@property(nonatomic) CGFloat value;
/**内部颜色*/
@property(nonatomic,strong) UIColor *starColor;
/**外线的颜色*/
@property(nonatomic,strong) UIColor *boundsColor;
/**五角星的路径*/
@property(nonatomic,assign) CGMutablePathRef starPath;//五角星的路径
/**内切圆的半径*/
@property(nonatomic,assign) CGFloat littleRadius;

/**根据五角星路径 生成动画*/
@property (nonatomic,copy) void(^animationBlock)();


- (void)animationStartWithView: (UIView *)view; 
@end
