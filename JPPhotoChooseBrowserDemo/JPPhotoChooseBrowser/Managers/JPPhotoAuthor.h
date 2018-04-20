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

+ (void)checkPhotoAuthorSuccess:(CheckSuccess)success Failure:(CheckFailure)failure;
+ (void)checkCameraAuthorSuccess:(CheckSuccess)success Failure:(CheckFailure)failure;

@end
