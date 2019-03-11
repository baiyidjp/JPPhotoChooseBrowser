//
//  JPPhotoModel.m
//
//
//  Copyright © dongjiangpeng. All rights reserved.
//

#import "JPPhotoModel.h"
#import <objc/runtime.h>
#import "BaseConst.h"

const char * kThumbImageKey = "kThumbImageKey";//缩略图
const char * kFullScreenImageKey = "kFullScreenImageKey";//屏幕大小图
const char * kOriginalImageKey = "kOriginalImageKey";//原图
const char * kPHImageFileURLKey = "kPHImageFileURLKey";//原图本地路径
const char * kOriginalImageData = "kOriginalImageData";//原图data
const char * kOriginalImageSize = "kOriginalImageSize";//原图大小

@implementation JPPhotoModel

+ (PHImageManager *)sharedPHImageManager{
    
    static PHImageManager *imageManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imageManager = [[PHImageManager alloc] init];
    });
    return imageManager;
}

- (void)setPhAsset:(PHAsset *)phAsset {
    
    _phAsset = phAsset;
    
    //图片的属性
//    [self getOriginalImageSizeWithAsset:phAsset];
}

#pragma mark - 缩略图相关

- (void)jp_ThumbImageWithBlock:(GetThumbImageBlock)GetThumbImageBlock {
    
    //取出关联对象 所关联的值
    UIImage *image = objc_getAssociatedObject(self, kThumbImageKey);
    if (image != nil) {
        GetThumbImageBlock(image);
        return;
    }
    
    CGFloat itemWH = (JP_SCREENWIDTH - (4+1)*JP_KMARGIN/2)/4;
    CGFloat screenScale = [UIScreen mainScreen].scale;
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
    [self.imageManager requestImageForAsset:self.phAsset targetSize:CGSizeMake(itemWH*screenScale, itemWH*screenScale) contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage *result, NSDictionary *info) {
//        NSLog(@"1-----缩略图");
        GetThumbImageBlock(result);
        //此处设置关联对象
        objc_setAssociatedObject(self, kThumbImageKey, result, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }];

}

#pragma mark - 全屏图

- (void)jp_FullScreenImageWithBlock:(GetFullScreenImageBlock)GetFullScreenImageBlock {
 
    UIImage *image = objc_getAssociatedObject(self, kFullScreenImageKey);
    if (image != nil) {
        GetFullScreenImageBlock(image,YES);
        return;
    }
    CGFloat screenScale = [UIScreen mainScreen].scale;
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;

    [[JPPhotoModel sharedPHImageManager] requestImageForAsset:self.phAsset targetSize:CGSizeMake(JP_SCREENWIDTH*screenScale, JP_SCREENHEIGHT*screenScale) contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage *result, NSDictionary *info) {
        NSLog(@"2---全屏图");
        if ([[info valueForKey:@"PHImageResultIsDegradedKey"]integerValue]==0){
            // Do something with the FULL SIZED image
            GetFullScreenImageBlock(result,YES);
            //此处设置关联对象
            objc_setAssociatedObject(self, kFullScreenImageKey, result, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        } else {
            // Do something with the regraded image
            GetFullScreenImageBlock(result,NO);
        }
        
    }];

}

#pragma mark - 原图相关元素

//原图的路径
- (NSString *)originalImageFileURL {
    
    NSString *path = objc_getAssociatedObject(self, kPHImageFileURLKey);
    return path;
}

//原图的data
- (NSData *)originalImageData {
    
    NSData *data= objc_getAssociatedObject(self, kOriginalImageData);
    return data;
}

//原图的大小
- (CGFloat)originalImageSize {
    
    NSString *size = objc_getAssociatedObject(self, kOriginalImageSize);
    return [size floatValue];
}

- (void)getOriginalImageSizeWithAsset:(PHAsset *)phAsset {
    
    [[JPPhotoModel sharedPHImageManager] requestImageDataForAsset:phAsset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {

        if (imageData) {
            
            CGFloat dataSize = imageData.length/(1024*1024.0);
            objc_setAssociatedObject(self, kOriginalImageSize, [NSString stringWithFormat:@"%f",dataSize], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            objc_setAssociatedObject(self, kOriginalImageData, imageData, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            objc_setAssociatedObject(self, kPHImageFileURLKey, [info objectForKey:@"PHImageFileURLKey"], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }];
}


- (BOOL)isVideoType{
    
    PHAssetMediaType mediaType = self.phAsset.mediaType;
    return mediaType == PHAssetMediaTypeVideo ? YES : NO;

}

- (NSString *)videoTime{
    
    NSInteger time = (NSInteger)self.phAsset.duration;
    NSInteger minute = time / 60;
    CGFloat second = time % 60;
    return [NSString stringWithFormat:@"%zd:%.2f",minute,second];
}

@end
