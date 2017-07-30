//
//  LaunchViewController.m
//  LuanchAnimation
//
//  Created by Daisy on 2017/7/29.
//  Copyright © 2017年 zf. All rights reserved.
//

#import "LaunchViewController.h"
#import "LogoAnimation.h"

@interface LaunchViewController ()
{
    LogoAnimation *view;
}
@end

@implementation LaunchViewController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [view start];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    
    view = [LogoAnimation addWithSuperView:self.view];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
