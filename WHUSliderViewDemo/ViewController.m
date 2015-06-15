//
//  ViewController.m
//  WHUSliderViewDemo
//
//  Created by SuperNova on 15/6/15.
//  Copyright (c) 2015年 SuperNova. All rights reserved.
//

#import "ViewController.h"
#import "WHUSliderView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIViewController* v1=[[UIViewController alloc] init];
    v1.title=@"标题1232323";
    v1.view.backgroundColor=[UIColor lightGrayColor];
    UIViewController* v2=[[UIViewController alloc] init];
    v2.view.backgroundColor=[UIColor grayColor];
    v2.title=@"标题24545452";
    UIViewController* v3=[[UIViewController alloc] init];
    v3.view.backgroundColor=[UIColor greenColor];
    v3.title=@"标retret题22";
    UIViewController* v4=[[UIViewController alloc] init];
    v4.view.backgroundColor=[UIColor redColor];
    v4.title=@"标ret题22";
    UIViewController* v5=[[UIViewController alloc] init];
    v5.view.backgroundColor=[UIColor blackColor];
    v5.title=@"标rtr题22";
    UIViewController* v6=[[UIViewController alloc] init];
    v6.view.backgroundColor=[UIColor yellowColor];
    v6.title=@"trt标题22";
    
    
    WHUSliderView* hv=[[WHUSliderView alloc] init];
    hv.translatesAutoresizingMaskIntoConstraints=NO;
    [self.view addSubview:hv];
    NSDictionary* viewDic=NSDictionaryOfVariableBindings(hv);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[hv]|" options:0 metrics:nil views:viewDic]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[hv]|" options:0 metrics:nil views:viewDic]];
    hv.controllerArray=@[v1,v2,v3,v4,v5,v6];
    hv.selectedColor=[UIColor redColor];
    [hv constructUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
