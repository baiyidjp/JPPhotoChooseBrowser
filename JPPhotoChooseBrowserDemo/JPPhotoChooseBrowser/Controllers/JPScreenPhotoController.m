//
//  JPScreenPhotoController.m
//  WeChat_D
//
//  Created by tztddong on 16/8/11.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "JPScreenPhotoController.h"
#import "JPPhotoModel.h"
#import "JPPhotoShowController.h"
#import "UIView+JP_Frame.h"

#define PHOTOCELL_ID @"UICollectionViewCell"

@interface JPScreenPhotoController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource,JPPhotoShowControllerDelegate>

@end

@implementation JPScreenPhotoController
{
    UIView                   *topView;
    UIView                   *bottomView;
    UIButton                 *backBtn;
    UIButton                 *selectBtn;
    UIButton                 *sendBtn;
    BOOL                     isHiddenView;
    NSInteger                currentCount;
    JPPhotoShowController    *currentPhotoShowController;
    NSInteger                allCount;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

- (BOOL)prefersStatusBarHidden{
    
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self p_SetupPageUI];
    
    topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, JP_SCREENWIDTH, JP_KNAVHEIGHT)];
    topView.backgroundColor = [UIColor blackColor];
    topView.alpha = 0.9;
    [self.view addSubview:topView];
    
    
    backBtn = [[UIButton alloc]initWithFrame:CGRectMake(JP_KMARGIN,topView.jp_h*0.5-15 , 15, 30)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"barbuttonicon_back_15x30_"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backToList) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backBtn];
    
    selectBtn = [[UIButton alloc]initWithFrame:CGRectMake(topView.jp_w - 42-JP_KMARGIN, topView.jp_h*0.5-21, 42, 42)];
    [selectBtn setBackgroundImage:[UIImage imageNamed:@"FriendsSendsPicturesSelectBigNIcon_42x42_"] forState:UIControlStateNormal];
    [selectBtn setBackgroundImage:[UIImage imageNamed:@"FriendsSendsPicturesSelectBigYIcon_42x42_"] forState:UIControlStateSelected];
    [selectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [selectBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [selectBtn addTarget:self action:@selector(clickSelectBtn) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:selectBtn];
    
    JPPhotoModel *photoModel = self.isPre ? self.seletedPhotoArray[self.currentIndexPath.item] : self.photoDataArray[self.currentIndexPath.item];
    selectBtn.selected = photoModel.isSelect;
    [selectBtn setTitle:[NSString stringWithFormat:@"%zd",photoModel.chooseIndex] forState:UIControlStateSelected];
    
    //判断是否已经滑动到最后面一页
    allCount = self.isPre ? self.seletedPhotoArray.count : self.photoDataArray.count;
    
    bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, JP_SCREENHEIGHT-JP_TAB_BAR_HEIGHT, JP_SCREENWIDTH, JP_TAB_BAR_HEIGHT)];
    bottomView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:bottomView];
    
    sendBtn = [[UIButton alloc]initWithFrame:CGRectMake(bottomView.jp_w-JP_KMARGIN-60, bottomView.jp_h*0.5-15, 60, 30)];
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendBtn setBackgroundColor:[UIColor colorWithRed:0.000 green:0.411 blue:0.000 alpha:1.000]];
    [sendBtn.titleLabel setFont:JP_FONTSIZE(15)];
    [sendBtn addTarget:self action:@selector(sendPhoto) forControlEvents:UIControlEventTouchUpInside];
    sendBtn.layer.cornerRadius = 3;
    sendBtn.layer.masksToBounds = YES;
    [bottomView addSubview:sendBtn];
    
    //当前所在图片的下标
    currentCount = self.currentIndexPath.item;
    
}

/** 设置分页控制器 */
- (void)p_SetupPageUI {
    //UIPageViewControllerTransitionStyleScroll滑动换页  UIPageViewControllerNavigationOrientationHorizontal横向滚动  UIPageViewControllerOptionInterPageSpacingKey页间距
    UIPageViewController *pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:@{@"UIPageViewControllerOptionInterPageSpacingKey":@20}];
    
    JPPhotoShowController *showController = [[JPPhotoShowController alloc] initWithImageModel:self.isPre ? self.seletedPhotoArray[self.currentIndexPath.item] : self.photoDataArray[self.currentIndexPath.item] SelectedIndex:self.currentIndexPath.item];
    currentPhotoShowController = showController;
    showController.delegate = self;
    //设置show为page的子控制器
    [pageViewController setViewControllers:@[showController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    //将分页控制器添加为当前的子控制器
    [self.view addSubview:pageViewController.view];
    [self addChildViewController:pageViewController];
    [pageViewController didMoveToParentViewController:self];
    
    //代理
    pageViewController.delegate = self;
    pageViewController.dataSource = self;
    
    //设置手势
    self.view.gestureRecognizers = pageViewController.gestureRecognizers;
}

/**
 返回前一页控制器
 
 @param pageViewController pageViewController description
 @param viewController 当前显示的控制器
 @return 返回前一页控制器 返回Nil 就是到头了
 */
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    //取出当前控制器的序号
    JPPhotoShowController *currentCtrl = (JPPhotoShowController *)viewController;
    NSInteger index = currentCtrl.selectIndex;
    //判断是否已经滑动到最前面一页
    if (index <= 0) {
        return nil;
    }
    index --;
    JPPhotoShowController *beforeCtrl = [[JPPhotoShowController alloc] initWithImageModel:self.isPre ? self.seletedPhotoArray[index] : self.photoDataArray[index] SelectedIndex:index];
    beforeCtrl.delegate = self;
    return beforeCtrl;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    //取出当前控制器的序号
    JPPhotoShowController *currentCtrl = (JPPhotoShowController *)viewController;
    NSInteger index = currentCtrl.selectIndex;
    //判断是否已经滑动到最后面一页
    if (index >= allCount-1) {
        return nil;
    }
    index ++;
    JPPhotoShowController *afterCtrl = [[JPPhotoShowController alloc] initWithImageModel:self.isPre ? self.seletedPhotoArray[index] : self.photoDataArray[index] SelectedIndex:index];
    afterCtrl.delegate = self;
    return afterCtrl;
    
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    
    // viewControllers[0] 是当前显示的控制器，随着分页控制器的滚动，调整数组的内容次序
    // 始终保证当前显示的控制器的下标是 0
    // 一定注意，不要使用 childViewControllers
    
    JPPhotoShowController *showController = (JPPhotoShowController *)pageViewController.viewControllers[0];
    currentPhotoShowController = showController;
    currentCount = currentPhotoShowController.selectIndex;
    
    JPPhotoModel *photoModel = self.isPre ? self.seletedPhotoArray[currentCount] : self.photoDataArray[currentCount];
    selectBtn.selected = photoModel.isSelect;
    [selectBtn setTitle:[NSString stringWithFormat:@"%zd",photoModel.chooseIndex] forState:UIControlStateSelected];
}

#pragma mark - 点击选择按钮
- (void)clickSelectBtn{
    
    JPPhotoModel *photoModel = self.isPre ? self.seletedPhotoArray[currentCount] : self.photoDataArray[currentCount];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    for (JPPhotoModel *model in self.photoDataArray) {
        if (model == photoModel) {
            indexPath = model.indexPath;
        }
    }
    
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
            selectBtn.selected = YES;
            [selectBtn setTitle:[NSString stringWithFormat:@"%zd",photoModel.chooseIndex] forState:UIControlStateSelected];
            if (self.selectedChooseBtn) {
                self.selectedChooseBtn(@[indexPath]);
            }
        }else {
            for (NSInteger i = 0; i < self.seletedPhotoArray.count ;i++) {
                JPPhotoModel *model = [self.seletedPhotoArray objectAtIndex:i];
                if (model.chooseIndex > photoModel.chooseIndex) {
                    model.chooseIndex -= 1;
                }
            }
            if (self.selectedChooseBtn) {
                self.selectedChooseBtn([self.seletedPhotoIndexPathArray copy]);
            }
            if (!self.isPre) {
                
                [self.seletedPhotoArray removeObject:photoModel];
            }
            [self.seletedPhotoIndexPathArray removeObject:indexPath];
            selectBtn.selected = NO;
        }

    }
}

#pragma mark 点击图片后 改变状态
- (void)tapImage {
    
    isHiddenView = !isHiddenView;
    if (isHiddenView) {
        [UIView animateWithDuration:0.3 animations:^{
            topView.jp_y = -topView.jp_h;
            bottomView.jp_y = JP_SCREENHEIGHT;
        }];
    }else {
        [UIView animateWithDuration:0.3 animations:^{
            topView.jp_y = 0;
            bottomView.jp_y = JP_SCREENHEIGHT-bottomView.jp_h;
        }];

    }
}

- (void)backToList{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sendPhoto{
    
    if (!self.seletedPhotoArray.count) {
        UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"请最少选择一张照片" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertCtrl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertCtrl animated:YES completion:nil];
        return;
    }
    
    
    NSMutableArray *thumbImageArr = [NSMutableArray array];
    NSMutableArray *originalImageArr = [NSMutableArray array];
    for (JPPhotoModel *model in self.seletedPhotoArray) {
        [model JPThumbImageWithBlock:^(UIImage *thumbImage) {
            [thumbImageArr addObject:thumbImage];
        }];
        [model JPFullScreenImageWithBlock:^(UIImage *fullScreenImage) {
            [originalImageArr addObject:fullScreenImage];
        }];
    }
    
    NSDictionary *imageInfo = @{@"JPThumbImageKey":thumbImageArr,
                                @"JPOriginalImageKey": originalImageArr
                                };
    [[NSNotificationCenter defaultCenter] postNotificationName:@"JPSendPhotoKey" object:nil userInfo:imageInfo];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"JPSendPhotoKey" object:nil];
}

@end
