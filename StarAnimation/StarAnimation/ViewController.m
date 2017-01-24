//
//  AppDelegate.h
//  StarAnimation
//
//  Created by 李鹏跃 on 17/1/24.
//  Copyright © 2017年 13lipengyue. All rights reserved.
//

#import "ViewController.h"
#import "StarView.h"
#import "DrawRectView.h"
#import "CKShimmerLabel.h"
@interface ViewController ()<UIWebViewDelegate>

@end

@implementation ViewController
- (void)loadView {
    self.view = [[DrawRectView alloc]initWithFrame:[UIScreen mainScreen].bounds];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    StarView *  view = [[StarView alloc] initWithFrame:CGRectMake(100, 100, 100 , 100)];
    //颜色
    view.boundsColor=[UIColor blueColor];
    
    view.radius = 50;
    view.littleRadius = 30;
    view.starColor = [UIColor clearColor];
    
    [view animationStartWithView:nil];
    [self.view addSubview:view];
    
    
    //----------------新年快乐
    CKShimmerLabel *shimmerLabel = [[CKShimmerLabel alloc]init];
    shimmerLabel.frame = CGRectMake(self.view.frame.size.width - 100, self.view.frame.size.height - 250,100,25);
    shimmerLabel.text = @"新年快乐~";
    shimmerLabel.font = [UIFont fontWithName:@"新年好" size:20];
    shimmerLabel.shimmerColor = [UIColor redColor];
    [shimmerLabel startShimmer];
    [self.view addSubview:shimmerLabel];
}




@end
