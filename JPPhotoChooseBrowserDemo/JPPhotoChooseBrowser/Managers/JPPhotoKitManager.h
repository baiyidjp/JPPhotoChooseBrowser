//
//  JPPhotoKitManger.h
//  单个相册中照片管理类
//
//  Copyright © dongjiangpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JPPhotoGroupModel;
@interface JPPhotoKitManager : NSObject

/**
 获取单例

 @return 单例
 */
+ (JPPhotoKitManager *)sharedPhotoKitManager;

/**
 获取所有相册组

 @return 相册组Model集合
 */
- (NSArray *)jp_GetPhotoGroupArray;

/**
 通过相册组的Model,获取当前相册的所有相片Model
 
 @param groupModel 相册组的Model
 
 @return 单独一个相册的数据
 */
- (NSArray *)jp_GetPhotoListWithModel:(JPPhotoGroupModel *)groupModel;


@end
