//
//  JPPhotoManager.h
//  管理类
//
//  Created by Keep丶Dream on 2017/10/20.
//  Copyright © 2017年 dong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol JPPhotoManagerDelegate <NSObject>

/**
 取消选择图片
 */
- (void)jp_ImagePickerControllerDidCancel;

/**
 完成选择图片

 @param thumbImages 缩略图
 @param originalImages 原图
 */
- (void)jp_ImagePickerControllerDidFinishPickingMediaWithThumbImages:(NSArray *)thumbImages originalImages:(NSArray *)originalImages;
@end

@interface JPPhotoManager : NSObject

/**
 单例 使用单例调用启动方法

 @return 单例
 */
+ (JPPhotoManager *)sharedPhotoManager;

/**
 启动图片选择器 默认最多选择9个

 @param viewController 当前所在的控制器
 */
- (void)jp_OpenPhotoListWithController:(UIViewController *)viewController;

/**
 启动图片选择器

 @param viewController 当前所在的控制器
 @param maxImageCount 最大图片选择数(默认可不传,使用上面接口 设为9)
 */
- (void)jp_OpenPhotoListWithController:(UIViewController *)viewController MaxImageCount:(NSInteger)maxImageCount;

/**
 发送照片

 @param imageArray 已选中的照片
 */
- (void)jp_SendSeletedPhotosWithArray:(NSArray *)imageArray success:(void(^)(BOOL isSuccess))success;

/** deleagte */
@property(nonatomic,weak) id<JPPhotoManagerDelegate> delegate;


@end
