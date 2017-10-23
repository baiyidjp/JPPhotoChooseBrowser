//
//  ViewController.m
//  JPPhotoChooseBrowserDemo
//
//  Created by Keep丶Dream on 2017/10/23.
//  Copyright © 2017年 dong. All rights reserved.
//

#import "ViewController.h"
#import "JPChoosePicView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    JPChoosePicView *picView = [[JPChoosePicView alloc] initWithFrame:CGRectMake(0, 100,self.view.frame.size.width, (self.view.frame.size.width-40)/3)];
    picView.superViewController = self;
    [self.view addSubview:picView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
