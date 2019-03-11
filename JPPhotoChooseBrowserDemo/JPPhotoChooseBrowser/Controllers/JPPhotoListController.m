//
//  JPPhotoListController.m
//
//
//  Copyright © dongjiangpeng. All rights reserved.
//

#import "JPPhotoListController.h"
#import "JPPhotoModel.h"
#import "JPPhotoGroupModel.h"
#import "JPPhotoCollectionViewCell.h"
#import "JPScreenPhotoController.h"
#import "JPPhotoKitManager.h"
#import "UIView+JP_Frame.h"
#import "BaseConst.h"
#import "JPPhotoManager.h"
#import "NSIndexSet+Convenience.h"
#import "UICollectionView+Convenience.h"

#define ROW_COUNT 4
#define PHOTOCELL_ID @"JPPhotoCollectionViewCell"
@interface JPPhotoListController ()<UICollectionViewDelegate,UICollectionViewDataSource,JPPhotoCollectionViewCellDelegate,PHPhotoLibraryChangeObserver>

/** collectionView */
@property(nonatomic,strong) UICollectionView *collectionView;
/** cache manager */
@property(nonatomic,strong) PHCachingImageManager *imageManager;

/** item size */
@property(nonatomic,assign) CGSize itemSize;
/** previousPreheatRect */
@property(nonatomic,assign) CGRect previousPreheatRect;

/** assetsFetchResults photo assets */
@property(nonatomic,strong) PHFetchResult *assetsFetchResults;
/** photoModels */
@property(nonatomic,strong) NSMutableArray *photoDataArray;
/** selectedPhotoModels */
@property(nonatomic,strong) NSMutableArray *seletedPhotoArray;
/** selectedIndexpaths */
@property(nonatomic,strong) NSMutableArray *seletedPhotoIndexPathArray;

@end

@implementation JPPhotoListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *cancleBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 32, 32)];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    [cancleBtn.titleLabel setFont:JP_FONTSIZE(15)];
    [cancleBtn addTarget:self action:@selector(clickCancleBtn) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:cancleBtn];
    self.navigationItem.rightBarButtonItem = item;
    
    [self p_SetUI];
    
    [self resetCachedAssets];
    
    [self p_SetDefaultData];

}

- (void)dealloc {
    
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Begin caching assets in and around collection view's visible rect.
    [self updateCachedAssets];
}

- (void)p_SetUI{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    CGFloat itemWH = (JP_SCREENWIDTH - (ROW_COUNT+1)*JP_KMARGIN/2)/ROW_COUNT;
    layout.itemSize = CGSizeMake(itemWH, itemWH);
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(JP_KMARGIN/2, JP_KNAVHEIGHT+JP_KMARGIN/2, JP_SCREENWIDTH-JP_KMARGIN, JP_SCREENHEIGHT-JP_KNAVHEIGHT-JP_TAB_BAR_HEIGHT-JP_KMARGIN-JP_HOME_INDICATOR_HEIGHT) collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    [collectionView registerClass:[JPPhotoCollectionViewCell class] forCellWithReuseIdentifier:PHOTOCELL_ID];
    collectionView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    self.itemSize = CGSizeMake(itemWH, itemWH);
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, JP_SCREENHEIGHT-JP_TAB_BAR_HEIGHT, JP_SCREENWIDTH, JP_TAB_BAR_HEIGHT)];
    bottomView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:bottomView];

    UIButton *preViewBtn = [[UIButton alloc]initWithFrame:CGRectMake(JP_KMARGIN, JP_KMARGIN+JP_KMARGIN/2, 40, 20)];
    [preViewBtn setTitle:@"预览" forState:UIControlStateNormal];
    [preViewBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [preViewBtn.titleLabel setFont:JP_FONTSIZE(15)];
    [preViewBtn addTarget:self action:@selector(p_ClickPreViewBtn) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:preViewBtn];

    UIButton *sendBtn = [[UIButton alloc]initWithFrame:CGRectMake(bottomView.jp_w-JP_KMARGIN-60, JP_KMARGIN, 60, 30)];
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendBtn setBackgroundColor:[UIColor colorWithRed:31/255.0 green:185/255.0 blue:34/255.0 alpha:1.000]];
    [sendBtn.titleLabel setFont:JP_FONTSIZE(15)];
    [sendBtn addTarget:self action:@selector(p_ClickSendPhoto) forControlEvents:UIControlEventTouchUpInside];
    sendBtn.layer.cornerRadius = 3;
    sendBtn.layer.masksToBounds = YES;
    [bottomView addSubview:sendBtn];
}

#pragma mark - set default data
- (void)p_SetDefaultData {
    
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
    
    PHAssetCollection *assetCollection = self.groupModel.assetCollection;
    if (![assetCollection isKindOfClass:[PHAssetCollection class]]) {
        return;
    }
    
    // Configure the asset collection.
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
    fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:fetchOptions];
    self.assetsFetchResults = assetsFetchResult;
    
    for (NSInteger i = 0; i < assetsFetchResult.count; i++) {
        
        PHAsset *asset = assetsFetchResult[i];
        JPPhotoModel *photoModel = [[JPPhotoModel alloc]init];
        photoModel.phAsset = asset;
        photoModel.indexPath = [NSIndexPath indexPathForRow:self.photoDataArray.count inSection:0];
        photoModel.imageManager = self.imageManager;
        [self.photoDataArray addObject:photoModel];
    }
}


#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.photoDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    JPPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PHOTOCELL_ID forIndexPath:indexPath];
    
    cell.photoModel = [self.photoDataArray objectAtIndex:indexPath.item];

    cell.delegate = self;
    
    return cell;
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    JPScreenPhotoController *screenPhotoCtrl = [[JPScreenPhotoController alloc]init];
    screenPhotoCtrl.seletedPhotoArray = self.seletedPhotoArray;
    screenPhotoCtrl.seletedPhotoIndexPathArray = self.seletedPhotoIndexPathArray;
    screenPhotoCtrl.photoDataArray = self.photoDataArray;
    screenPhotoCtrl.currentIndexPath = indexPath;
    screenPhotoCtrl.maxImageCount = self.maxImageCount;
    screenPhotoCtrl.isPre = NO;
    [screenPhotoCtrl setSelectedChooseBtn:^(NSArray *indexPaths) {
        [collectionView reloadItemsAtIndexPaths:indexPaths];
    }];
    [self.navigationController pushViewController:screenPhotoCtrl animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Update cached assets for the new visible area.
    [self updateCachedAssets];
}

#pragma mark - PHPhotoLibraryChangeObserver

- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    // Check if there are changes to the assets we are showing.
    PHFetchResultChangeDetails *collectionChanges = [changeInstance changeDetailsForFetchResult:self.assetsFetchResults];
    if (collectionChanges == nil) {
        return;
    }
    
    /*
     Change notifications may be made on a background queue. Re-dispatch to the
     main queue before acting on the change as we'll be updating the UI.
     */
    dispatch_async(dispatch_get_main_queue(), ^{
        // Get the new fetch result.
        self.assetsFetchResults = [collectionChanges fetchResultAfterChanges];
        
        if (![collectionChanges hasIncrementalChanges] || [collectionChanges hasMoves]) {
            // Reload the collection view if the incremental diffs are not available
            [self.collectionView reloadData];
            
        } else {
            /*
             Tell the collection view to animate insertions and deletions if we
             have incremental diffs.
             */
            [self.collectionView performBatchUpdates:^{
                NSIndexSet *removedIndexes = [collectionChanges removedIndexes];
                if ([removedIndexes count] > 0) {
                    [self.collectionView deleteItemsAtIndexPaths:[removedIndexes aapl_indexPathsFromIndexesWithSection:0]];
                }
                
                NSIndexSet *insertedIndexes = [collectionChanges insertedIndexes];
                if ([insertedIndexes count] > 0) {
                    [self.collectionView insertItemsAtIndexPaths:[insertedIndexes aapl_indexPathsFromIndexesWithSection:0]];
                }
                
                NSIndexSet *changedIndexes = [collectionChanges changedIndexes];
                if ([changedIndexes count] > 0) {
                    [self.collectionView reloadItemsAtIndexPaths:[changedIndexes aapl_indexPathsFromIndexesWithSection:0]];
                }
            } completion:NULL];
        }
        
        [self resetCachedAssets];
    });
}

#pragma mark - Asset Caching

- (void)resetCachedAssets {
    
    [self.imageManager stopCachingImagesForAllAssets];
    self.previousPreheatRect = CGRectZero;
}

- (void)updateCachedAssets {
    
    BOOL isViewVisible = [self isViewLoaded] && [[self view] window] != nil;
    if (!isViewVisible) { return; }
    
    // The preheat window is twice the height of the visible rect.
    CGRect preheatRect = self.collectionView.bounds;
    preheatRect = CGRectInset(preheatRect, 0.0f, -0.5f * CGRectGetHeight(preheatRect));
    
    /*
     Check if the collection view is showing an area that is significantly
     different to the last preheated area.
     */
    CGFloat delta = ABS(CGRectGetMidY(preheatRect) - CGRectGetMidY(self.previousPreheatRect));
    if (delta > CGRectGetHeight(self.collectionView.bounds) / 3.0f) {
        
        // Compute the assets to start caching and to stop caching.
        NSMutableArray *addedIndexPaths = [NSMutableArray array];
        NSMutableArray *removedIndexPaths = [NSMutableArray array];
        
        [self computeDifferenceBetweenRect:self.previousPreheatRect andRect:preheatRect removedHandler:^(CGRect removedRect) {
            NSArray *indexPaths = [self.collectionView aapl_indexPathsForElementsInRect:removedRect];
            [removedIndexPaths addObjectsFromArray:indexPaths];
        } addedHandler:^(CGRect addedRect) {
            NSArray *indexPaths = [self.collectionView aapl_indexPathsForElementsInRect:addedRect];
            [addedIndexPaths addObjectsFromArray:indexPaths];
        }];
        
        NSArray *assetsToStartCaching = [self assetsAtIndexPaths:addedIndexPaths];
        NSArray *assetsToStopCaching = [self assetsAtIndexPaths:removedIndexPaths];
        
        // Update the assets the PHCachingImageManager is caching.
        [self.imageManager startCachingImagesForAssets:assetsToStartCaching
                                            targetSize:self.itemSize
                                           contentMode:PHImageContentModeAspectFill
                                               options:nil];
        [self.imageManager stopCachingImagesForAssets:assetsToStopCaching
                                           targetSize:self.itemSize
                                          contentMode:PHImageContentModeAspectFill
                                              options:nil];
        
        // Store the preheat rect to compare against in the future.
        self.previousPreheatRect = preheatRect;
    }
}

- (void)computeDifferenceBetweenRect:(CGRect)oldRect andRect:(CGRect)newRect removedHandler:(void (^)(CGRect removedRect))removedHandler addedHandler:(void (^)(CGRect addedRect))addedHandler {
    
    if (CGRectIntersectsRect(newRect, oldRect)) {
        CGFloat oldMaxY = CGRectGetMaxY(oldRect);
        CGFloat oldMinY = CGRectGetMinY(oldRect);
        CGFloat newMaxY = CGRectGetMaxY(newRect);
        CGFloat newMinY = CGRectGetMinY(newRect);
        
        if (newMaxY > oldMaxY) {
            CGRect rectToAdd = CGRectMake(newRect.origin.x, oldMaxY, newRect.size.width, (newMaxY - oldMaxY));
            addedHandler(rectToAdd);
        }
        
        if (oldMinY > newMinY) {
            CGRect rectToAdd = CGRectMake(newRect.origin.x, newMinY, newRect.size.width, (oldMinY - newMinY));
            addedHandler(rectToAdd);
        }
        
        if (newMaxY < oldMaxY) {
            CGRect rectToRemove = CGRectMake(newRect.origin.x, newMaxY, newRect.size.width, (oldMaxY - newMaxY));
            removedHandler(rectToRemove);
        }
        
        if (oldMinY < newMinY) {
            CGRect rectToRemove = CGRectMake(newRect.origin.x, oldMinY, newRect.size.width, (newMinY - oldMinY));
            removedHandler(rectToRemove);
        }
    } else {
        addedHandler(newRect);
        removedHandler(oldRect);
    }
}

- (NSArray *)assetsAtIndexPaths:(NSArray *)indexPaths {
    if (indexPaths.count == 0) { return nil; }
    
    NSMutableArray *assets = [NSMutableArray arrayWithCapacity:indexPaths.count];
    for (NSIndexPath *indexPath in indexPaths) {
        PHAsset *asset = self.assetsFetchResults[indexPath.item];
        [assets addObject:asset];
    }
    
    return assets;
}

#pragma mark 点击选中按钮的代理
- (void)thumbImageSeletedChooseIndexPath:(NSIndexPath *)indexPath selectedBtn:(UIButton *)selectedBtn {

    JPPhotoModel *photoModel = [self.photoDataArray objectAtIndex:indexPath.item];

    if (self.seletedPhotoIndexPathArray.count == self.maxImageCount && !photoModel.isSelect) {
        UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"最多选择%zd张图片",self.maxImageCount] message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertCtrl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertCtrl animated:YES completion:nil];

    }else {

        photoModel.isSelect = !photoModel.isSelect;
        if (photoModel.isSelect) {
            photoModel.chooseIndex = self.seletedPhotoIndexPathArray.count+1;
            [self.seletedPhotoIndexPathArray addObject:indexPath];
            [self.seletedPhotoArray addObject:photoModel];
            [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
        }else {
            for (NSInteger i = 0; i < self.seletedPhotoIndexPathArray.count ;i++) {
                JPPhotoModel *model = [self.seletedPhotoArray objectAtIndex:i];
                if (model.chooseIndex > photoModel.chooseIndex) {
                    model.chooseIndex -= 1;
                }
            }
            [self.collectionView reloadItemsAtIndexPaths:self.seletedPhotoIndexPathArray];
            [self.seletedPhotoIndexPathArray removeObject:indexPath];
            [self.seletedPhotoArray removeObject:photoModel];
        }

        CABasicAnimation*pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        pulse.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pulse.duration = 0.08;
        pulse.repeatCount= 1;
        pulse.autoreverses= YES;
        pulse.fromValue= [NSNumber numberWithFloat:0.7];
        pulse.toValue= [NSNumber numberWithFloat:1.3];
        [[selectedBtn layer] addAnimation:pulse forKey:nil];
    }
}

#pragma mark 预览
- (void)p_ClickPreViewBtn{

    if (!self.seletedPhotoArray.count) {
        UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"请最少选择一张照片" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertCtrl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertCtrl animated:YES completion:nil];
        return;
    }

    JPScreenPhotoController *screenPhotoCtrl = [[JPScreenPhotoController alloc]init];
    screenPhotoCtrl.seletedPhotoArray = self.seletedPhotoArray;
    screenPhotoCtrl.seletedPhotoIndexPathArray = self.seletedPhotoIndexPathArray;
    screenPhotoCtrl.photoDataArray = self.photoDataArray;
    screenPhotoCtrl.currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    screenPhotoCtrl.maxImageCount = self.maxImageCount;
    screenPhotoCtrl.isPre = YES;
    [screenPhotoCtrl setSelectedChooseBtn:^(NSArray *indexPaths) {
        [self.collectionView reloadItemsAtIndexPaths:indexPaths];
    }];
    [self.navigationController pushViewController:screenPhotoCtrl animated:YES];
}

#pragma mark - send photo

- (void)p_ClickSendPhoto{

    if (!self.seletedPhotoArray.count) {
        UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"请最少选择一张照片" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertCtrl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertCtrl animated:YES completion:nil];
        return;
    }

    [[JPPhotoManager sharedPhotoManager] jp_SendSeletedPhotosWithArray:[self.seletedPhotoArray copy] success:^(BOOL isSuccess) {
        if (isSuccess) {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }

    }];
}

- (void)clickCancleBtn{
    
    [[JPPhotoManager sharedPhotoManager] jp_CancelChoosePhoto];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - lazy init

- (NSMutableArray *)photoDataArray{
    
    if (!_photoDataArray) {
        _photoDataArray = [NSMutableArray array];
    }
    return _photoDataArray;
}

- (NSMutableArray *)seletedPhotoArray{
    
    if (!_seletedPhotoArray) {
        
        _seletedPhotoArray = [NSMutableArray array];
    }
    return _seletedPhotoArray;
}

- (NSMutableArray *)seletedPhotoIndexPathArray{
    
    if (!_seletedPhotoIndexPathArray) {
        
        _seletedPhotoIndexPathArray = [NSMutableArray array];
    }
    return _seletedPhotoIndexPathArray;
}

- (PHCachingImageManager *)imageManager{
    
    if (!_imageManager) {
        
        _imageManager = [[PHCachingImageManager alloc] init];;
    }
    return _imageManager;
}

@end
