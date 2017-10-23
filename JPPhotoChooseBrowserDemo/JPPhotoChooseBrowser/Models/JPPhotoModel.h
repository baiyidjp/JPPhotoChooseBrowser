//
//  JPPhotoModel.h
//  WeChat_D
//
//  Created by tztddong on 16/8/10.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

typedef void(^GetThumbImageBlock)(UIImage *thumbImage);
typedef void(^GetFullScreenImageBlock)(UIImage *fullScreenImage);
typedef void(^GetFullResolutDataBlock)(NSData *fullResolutData);
typedef void(^GetFullResolutDataSizeBlock)(CGFloat fullResolutDataSize);
typedef void(^GetFullScreenImageDataBlock)(NSData *fullScreenImageData);

@interface JPPhotoModel : NSObject

+ (PHImageManager *)sharedPHImageManager;

/** ios8 PHAsset */
@property(nonatomic,strong) PHAsset *phAsset;

/** 获取缩略图 */
- (void)JPThumbImageWithBlock:(GetThumbImageBlock)GetThumbImageBlock;

/** 获取屏幕大小的原图 */
- (void)JPFullScreenImageWithBlock:(GetFullScreenImageBlock)GetFullScreenImageBlock;//适应屏幕的原图

/** 原图的本地路径 */
@property(nonatomic,strong) NSString *originalImageFileURL;
/** 原图的data */
@property(nonatomic,strong) NSData *originalImageData;
/** 原图片的大小 */
@property(nonatomic,assign) CGFloat originalImageSize;

/** 获取是否是视频类型, Default = false */
@property (assign,nonatomic) BOOL isVideoType;

/** 是否被选中 */
@property(nonatomic,assign)BOOL isSelect;
/** 选中的顺序 */
@property(nonatomic,assign) NSInteger chooseIndex;

/** 是否显示原图(后续发送的时候判断是否发送原图) */
@property(nonatomic,assign)BOOL isShowFullImage;

/** 获取视频的时长 */
- (NSString *)videoTime;

/** 当前点击的indexPath */
@property(nonatomic,strong)NSIndexPath *indexPath;

@end
