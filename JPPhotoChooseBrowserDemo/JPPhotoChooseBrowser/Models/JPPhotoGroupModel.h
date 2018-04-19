//
//  JPPhotoGroupModel.h
//  相册组列表的Model
//
//  Copyright © dongjiangpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/PHCollection.h>
#import <UIKit/UIKit.h>

@interface JPPhotoGroupModel : NSObject

/**
 *  组名
 */
@property (nonatomic , copy) NSString *groupName;

/**
 *  缩略图
 */
@property (nonatomic , strong) UIImage *thumbImage;

/**
 *  组里面的图片个数
 */
@property (nonatomic , assign) NSInteger assetsCount;

/**
 *  类型 : Saved Photos...
 */
@property (nonatomic , copy) NSString *type;

/** PHotoKit group */
@property(nonatomic,strong) PHAssetCollection *assetCollection;


@end
