//
//  JPPhotoAuthor.h
//  JPPhotoChooseBrowserDemo
//
//  Created by baiyi on 2018/4/20.
//  Copyright © 2018年 dong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CheckSuccess)(void);
typedef void(^CheckFailure)(NSString *message);

@interface JPPhotoAuthor : NSObject

/**
 检查相册权限

 @param success 已授权
 @param failure 未授权
 */
+ (void)checkPhotoAuthorSuccess:(CheckSuccess)success Failure:(CheckFailure)failure;

/**
 检查相机权限

 @param success 已授权
 @param failure 未授权
 */
+ (void)checkCameraAuthorSuccess:(CheckSuccess)success Failure:(CheckFailure)failure;

/**
 检查保存相册权限
 
 @param success 已授权
 @param failure 未授权
 */
+ (void)checkSavedPhotoAuthorSuccess:(CheckSuccess)success Failure:(CheckFailure)failure;

@end
