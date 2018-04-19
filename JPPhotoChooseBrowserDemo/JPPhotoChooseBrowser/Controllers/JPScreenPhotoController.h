//
//  JPScreenPhotoController.h
//  负责全屏展示照片的控制器
//
//  Copyright © dongjiangpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectedChooseBtn)(NSArray *indexPaths);

@interface JPScreenPhotoController : UIViewController

@property(nonatomic,strong)NSMutableArray *seletedPhotoArray;
@property(nonatomic,strong)NSMutableArray *seletedPhotoIndexPathArray;
@property(nonatomic,strong)NSMutableArray *photoDataArray;
@property(nonatomic,strong)NSIndexPath *currentIndexPath;
/** 是否是预览界面 */
@property(nonatomic,assign) BOOL isPre;

/** maxIndex */
@property(nonatomic,assign) NSInteger maxImageCount;

/** blcok回到 ListController 刷新 */
@property(nonatomic,copy) SelectedChooseBtn selectedChooseBtn;
@end
