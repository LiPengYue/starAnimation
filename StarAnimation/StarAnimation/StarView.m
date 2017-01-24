//
//  AppDelegate.h
//  StarAnimation
//
//  Created by 李鹏跃 on 17/1/24.
//  Copyright © 2017年 13lipengyue. All rights reserved.
//

#import "StarView.h"
#define th M_PI/180
@interface StarView ()<CAAnimationDelegate>
@property (nonatomic,weak) UIView *demoView;
@end

@implementation StarView
//生成成员变量
@synthesize littleRadius = _littleRadius;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat x = frame.size.width / 2;
        CGFloat y = frame.size.height / 2;
        self.radius = x < y ? x:y;
        self.value = 1;
        self.starColor = [UIColor yellowColor];
        self.backgroundColor=[UIColor clearColor];
        self.boundsColor = [UIColor blackColor];
        self.opaque = NO;
    }
    return self;
}
-(void) setFrame:(CGRect)frame
{
    CGFloat x = frame.size.width / 2;
    CGFloat y = frame.size.height / 2;
    self.radius = x < y ? x:y;
    
    [super setFrame:frame];
    [self setNeedsDisplay];
    
}
-(id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        CGFloat x = self.frame.size.width / 2;
        CGFloat y = self.frame.size.height / 2;
        self.radius = x < y ? x:y;
        self.value = 1;
        self.starColor = [UIColor yellowColor];
        self.backgroundColor = [UIColor clearColor];
        self.boundsColor = [UIColor blackColor];
        
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    __block CGRect rang;
    [self starPathWithRect:rect andPathBlock:^(CGRect range, CGMutablePathRef path) {
        rang = range;
    }];
    
    //1.获取当前上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //2.创建色彩空间
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    
    //3.创建渐变对象
    CGGradientRef gradientRef = CGGradientCreateWithColorComponents(colorSpaceRef, (CGFloat[]) {
        1.0f,0.8f,0.5f,1.0f,//第一个颜色RGB 和透明度
        0.6f,0.5f,0.6f,1.0f,//第二个颜色RGB 和透明度
        0.3f,0.2f,0.f,1.0f,//第三个颜色RGB 和透明度
        .0f,0.0f,0.3f,1.0f
    }, (CGFloat []) {
        0.0f,0.3f,.6f,1//四个颜色的比例
    }, 4);//颜色的个数
    
    //释放色彩空间
    CGColorSpaceRelease(colorSpaceRef);
    
    //绘制
    CGContextDrawLinearGradient(context, gradientRef, CGPointMake(0.0f, 0.0f), CGPointMake(rect.size.width,rect.size.height), 0);
    
    //释放变色对象
    CGGradientRelease(gradientRef);

    CGContextAddPath(context, self.starPath);
    
    CGContextSetFillColorWithColor(context, self.starColor.CGColor);
    
    CGContextSetStrokeColorWithColor(context, self.boundsColor.CGColor);
    
    CGContextStrokePath(context);
    
    CGContextAddPath(context, self.starPath);
    CGContextClip(context);
    CGContextFillRect(context, rang);
    
    CFRelease(self.starPath);
}

//MARK: 计算五角星的路径
- (CGMutablePathRef) starPathWithRect: (CGRect)rect andPathBlock: (void (^)(CGRect range, CGMutablePathRef path))pathBlock{
    
    CGFloat centerX = rect.size.width / 2;
    CGFloat centerY = rect.size.height / 2;
    
    CGFloat r0 = self.littleRadius;
    CGFloat x1[5]={0},y1[5]={0},x2[5]={0},y2[5]={0};
    
    for (int i = 0; i < 5; i ++)
    {
        x1[i] = centerX + self.radius * cos((90 + i * 72) * th); /* 计算出大圆上的五个平均分布点的坐标*/
        y1[i]=centerY - self.radius * sin((90 + i * 72) * th);
        
        x2[i]=centerX + r0 * cos((54 + i * 72) * th); /* 计算出小圆上的五个平均分布点的坐标*/
        y2[i]=centerY - r0 * sin((54 + i * 72) * th);
    }
    
    CGMutablePathRef starPath = CGPathCreateMutable();
    CGPathMoveToPoint(starPath, NULL, x1[0], y1[0]);
    
    
    for (int i = 1; i < 5; i ++) {
        CGPathAddLineToPoint(starPath, NULL, x2[i], y2[i]);
        CGPathAddLineToPoint(starPath, NULL, x1[i], y1[i]);
    }
    CGPathAddLineToPoint(starPath, NULL, x2[0], y2[0]);
    CGPathCloseSubpath(starPath);
    CGRect range = CGRectMake(x1[1], 0, (x1[4] - x1[1]) * self.value , y1[2]);
    if (pathBlock) {
        pathBlock(range, starPath);
    }
    return starPath;
}

-(void) setValue:(CGFloat)value{
    if (value < 0) {
        _value = 0;
    }
    else if(value > 1)
    {
        _value = 1;
    }
    else{
        _value = value;
    }
    [self setNeedsDisplay];
}

#pragma -mark 懒加载
- (CGMutablePathRef) starPath {
    if (!_starPath) {
        _starPath = [self starPathWithRect:self.bounds andPathBlock:nil];
    }
    return _starPath;
}
//计算小圆半径
- (CGFloat) littleRadius {
    if (!_littleRadius) {
        _littleRadius = self.radius * sin(18 * th)/cos(36 * th); /*计算小圆半径r0 */
    }
    return _littleRadius;
}

- (void)setLittleRadius:(CGFloat)littleRadius {
    _littleRadius = self.radius * sin(littleRadius * th)/cos(36 * th); /*计算小圆半径r0 */
}

//动画：
- (void)animationStartWithView: (UIView *)view {
    
    //这里预留了view的接口 如果想自己设计动画可以改一下
      //创建layer
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    CGPathRef path = [self starPathWithRect:self.bounds andPathBlock:nil];
    shapeLayer.path = path;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = 3.0f;
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    [self.layer addSublayer:shapeLayer];

    
    //创建帧动画
    CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"strokeStart"];
    
    keyAnimation.values = @[
                          [NSNumber numberWithFloat:1.0f],
                          [NSNumber numberWithFloat:0.0f],
                          [NSNumber numberWithFloat:1.0]
                            ];
    keyAnimation.duration = 6.0;
    keyAnimation.removedOnCompletion = NO;
    keyAnimation.fillMode = kCAFillModeForwards;
    
    
    /**
    CAKeyframeAnimation *returnKeyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"strokeStart"];
    keyAnimation.values = @[
                            [NSNumber numberWithFloat:0.0f],
                            [NSNumber numberWithFloat:1.0f],
                            [NSNumber numberWithFloat:0.0]
                            ];
    
    keyAnimation.duration = 6.0;
    keyAnimation.removedOnCompletion = NO;
    keyAnimation.fillMode = kCAFillModeForwards;
  */
    
    //创建组动画 这里可以吧动画丰富些
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations = @[
                                  keyAnimation,
                                  
                                  ];
    groupAnimation.repeatCount = MAXFLOAT;
    groupAnimation.duration = 6.0f;
    //添加动画
    [shapeLayer addAnimation:groupAnimation forKey:@"startAnimation"];
   
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc]init];
    shapeLayer.path = [self starPathWithRect:self.bounds andPathBlock:nil];
    [self.layer setMask:shapeLayer];
}



@end
