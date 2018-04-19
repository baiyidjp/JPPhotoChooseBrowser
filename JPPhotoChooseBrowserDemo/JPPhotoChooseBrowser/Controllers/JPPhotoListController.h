//
//  JPPhotoListController.h
//  相册里的相片列表
//
//  Copyright © dongjiangpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@class JPPhotoGroupModel;
@interface JPPhotoListController : UIViewController

/** name */
@property(nonatomic,strong) JPPhotoGroupModel *groupModel;

/** maxIndex */
@property(nonatomic,assign) NSInteger maxImageCount;

@end
