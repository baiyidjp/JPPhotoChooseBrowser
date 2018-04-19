//
//  JPPhotoOperation.h
//  JPPhotoChooseBrowserDemo
//
//  Created by baiyi on 2018/4/19.
//  Copyright © 2018年 dong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JPPhotoModel.h"

@interface JPPhotoOperation : NSOperation

+ (instancetype)addOperationWithModel:(JPPhotoModel *)model completeBlock:(GetFullScreenImageBlock)completeBlock;

@end
