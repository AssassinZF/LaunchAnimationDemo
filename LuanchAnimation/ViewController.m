//
//  ViewController.m
//  LuanchAnimation
//
//  Created by Daisy on 2017/7/29.
//  Copyright © 2017年 zf. All rights reserved.
//

#import "ViewController.h"
#import "LaunchViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor blackColor];
    button.bounds = CGRectMake(0, 0, 100, 50);
    button.center = self.view.center;
    [button addTarget:self action:@selector(showAnimation:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Show" forState:UIControlStateNormal];
    [self.view addSubview:button];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showAnimation:(id)sender {
    LaunchViewController *vc = [[LaunchViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
