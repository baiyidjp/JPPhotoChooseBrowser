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
    
    JPChoosePicView *picView = [[JPChoosePicView alloc] initWithFrame:CGRectMake(15, 100,self.view.frame.size.width-30, self.view.frame.size.width-30)];
    picView.superViewController = self;
    [self.view addSubview:picView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
