//
//  JPPhotoShowController.h
//  负责单张照片的显示的控制器
//
//  Copyright © 2017年 dongjiangpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JPPhotoShowControllerDelegate <NSObject>

- (void)tapImage;

@end

@class JPPhotoModel;
@interface JPPhotoShowController : UIViewController

- (instancetype)initWithImageModel:(JPPhotoModel *)model SelectedIndex:(NSInteger)index;

/** delegate */
@property(nonatomic,assign) id<JPPhotoShowControllerDelegate> delegate;
/** 当前点击的序号 */
@property(nonatomic,assign)NSInteger  selectIndex;
/** 当前显示图片的View */
@property(nonatomic,strong) UIImageView *imageV;

@end
