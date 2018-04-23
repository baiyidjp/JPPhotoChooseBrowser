//
//  JPPhotoManager.m
//  
//
//  Created by Keep丶Dream on 2017/10/20.
//  Copyright © 2017年 dong. All rights reserved.
//

#import "JPPhotoManager.h"
#import "JPPhotoGroupListController.h"
#import "JPPhotoModel.h"
#import "JPPhotoOperation.h"
#import "JPPhotoAuthor.h"

@interface JPPhotoManager()
/** queue */
@property(nonatomic,strong) NSOperationQueue *imageQueue;
@end

@implementation JPPhotoManager

- (NSOperationQueue *)imageQueue{
    
    if (!_imageQueue) {
        
        _imageQueue = [[NSOperationQueue alloc] init];;
        _imageQueue.maxConcurrentOperationCount = 1;
    }
    return _imageQueue;
}


+ (JPPhotoManager *)sharedPhotoManager{
    
    static JPPhotoManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[JPPhotoManager alloc]init];
    });
    
    return manager;
}


- (void)jp_OpenPhotoListWithController:(UIViewController *)viewController {
    
    [self jp_OpenPhotoListWithController:viewController MaxImageCount:9];
}

- (void)jp_OpenPhotoListWithController:(UIViewController *)viewController MaxImageCount:(NSInteger)maxImageCount {
    
    [JPPhotoAuthor checkPhotoAuthorSuccess:^{

        JPPhotoGroupListController *photoCtrl = [[JPPhotoGroupListController alloc] init];
        photoCtrl.maxImageCount = maxImageCount;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:photoCtrl];
        [viewController presentViewController:nav animated:YES completion:nil];
        
    } Failure:^(NSString *message) {
        NSLog(@"%@",message);
    }];

    

}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)jp_SendSeletedPhotosWithArray:(NSArray *)imageArray success:(void (^)(BOOL))success {
    
    NSMutableArray *thumbImageArr = [NSMutableArray array];
    NSMutableArray *originalImageArr = [NSMutableArray array];
    __block NSInteger imageCount = 0;
    for (JPPhotoModel *model in imageArray) {
        [model jp_ThumbImageWithBlock:^(UIImage *thumbImage) {
            [thumbImageArr addObject:thumbImage];
        }];
        JPPhotoOperation *op = [JPPhotoOperation addOperationWithModel:model completeBlock:^(UIImage *fullScreenImage, BOOL isFull) {
            if (isFull) {
                imageCount ++;
                [originalImageArr addObject:fullScreenImage];
                if (imageCount == imageArray.count) {
                    if ([self.delegate respondsToSelector:@selector(jp_ImagePickerControllerDidFinishPickingMediaWithThumbImages:originalImages:)]) {
                        
                        [self.delegate jp_ImagePickerControllerDidFinishPickingMediaWithThumbImages:thumbImageArr originalImages:originalImageArr];
                        success(YES);
                    }
                }
            }
        }];
        [self.imageQueue addOperation:op];
    }

}

- (void)jp_CancelChoosePhoto {
    
    if ([self.delegate respondsToSelector:@selector(jp_ImagePickerControllerDidCancel)]) {
        [self.delegate jp_ImagePickerControllerDidCancel];
    }

}

@end
