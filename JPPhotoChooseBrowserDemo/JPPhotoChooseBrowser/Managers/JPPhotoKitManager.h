//
//  JPPhotoKitManger.h
//  WeChat_D
//
//  Created by Keep丶Dream on 16/8/13.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^PHGroupArrBlock)(NSArray *groupArray);
typedef void(^PHPhotoListBlock)(NSArray *photoList);

@class JPPhotoGroupModel;
@interface JPPhotoKitManager : NSObject

/**
 获取单例

 @return 单例
 */
+ (JPPhotoKitManager *)sharedPhotoKitManager;

/**
 获取所有相册组

 @param PHGroupArrBlock 相册组Model集合
 */
- (void)PHGetPhotoGroupArrayWithBlock:(PHGroupArrBlock)PHGroupArrBlock;

/**
 通过相册组的Model,获取当前相册的所有相片Model

 @param groupModel 相册组的Model
 @param PHPhotoListBlock 当前相册下所有的相片的Model
 */
- (void)PHGetPhotoListWithModel:(JPPhotoGroupModel *)groupModel Block:(PHPhotoListBlock)PHPhotoListBlock;


@end
