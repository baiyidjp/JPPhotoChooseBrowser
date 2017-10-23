//
//  JPChoosePicView.h
//  ThreePic
//
//  Created by Keep丶Dream on 2017/10/18.
//  Copyright © 2017年 dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JPChoosePicView : UIView

/** viewController */
@property(nonatomic,strong) UIViewController *superViewController;

/**
 图片的数组
 */
@property(nonatomic,strong) NSMutableArray<UIImage *> *imageArray;

@end
