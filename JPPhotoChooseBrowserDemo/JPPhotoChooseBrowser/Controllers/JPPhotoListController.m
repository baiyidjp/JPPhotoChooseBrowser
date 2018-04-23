//
//  JPPhotoListController.m
//
//
//  Copyright © dongjiangpeng. All rights reserved.
//

#import "JPPhotoListController.h"
#import "JPPhotoModel.h"
#import "JPPhotoCollectionViewCell.h"
#import "JPScreenPhotoController.h"
#import "JPPhotoKitManager.h"
#import "UIView+JP_Frame.h"
#import "BaseConst.h"
#import "JPPhotoManager.h"

#define ROW_COUNT 4
#define PHOTOCELL_ID @"JPPhotoCollectionViewCell"
@interface JPPhotoListController ()<UICollectionViewDelegate,UICollectionViewDataSource,JPPhotoCollectionViewCellDelegate>
@property(nonatomic,strong)NSMutableArray *photoDataArray;
@property(nonatomic,strong)NSMutableArray *seletedPhotoArray;
@property(nonatomic,strong)NSMutableArray *seletedPhotoIndexPathArray;
@end

@implementation JPPhotoListController
{
    UICollectionView    *photoCollectionView;
    UIButton            *preViewBtn;
    UIButton            *sendBtn;
}
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
    
    [self setCollectionView];
    
    NSArray *photoList = [[JPPhotoKitManager sharedPhotoKitManager] jp_GetPhotoListWithModel:self.groupModel];
    [self.photoDataArray addObjectsFromArray:photoList];
    [photoCollectionView reloadData];
}


- (void)clickCancleBtn{
    
    [[JPPhotoManager sharedPhotoManager] jp_CancelChoosePhoto];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

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

- (void)setCollectionView{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    CGFloat itemWH = (JP_SCREENWIDTH - (ROW_COUNT+1)*JP_KMARGIN/2)/ROW_COUNT;
    layout.itemSize = CGSizeMake(itemWH, itemWH);
    photoCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(JP_KMARGIN/2, JP_KMARGIN/2, JP_SCREENWIDTH-JP_KMARGIN, JP_SCREENHEIGHT-44-JP_KMARGIN-JP_HOME_INDICATOR_HEIGHT) collectionViewLayout:layout];
    photoCollectionView.delegate = self;
    photoCollectionView.dataSource = self;
    photoCollectionView.backgroundColor = [UIColor whiteColor];
    [photoCollectionView registerClass:[JPPhotoCollectionViewCell class] forCellWithReuseIdentifier:PHOTOCELL_ID];
    photoCollectionView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:photoCollectionView];
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, JP_SCREENHEIGHT-JP_TAB_BAR_HEIGHT, JP_SCREENWIDTH, JP_TAB_BAR_HEIGHT)];
    bottomView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:bottomView];
    
    preViewBtn = [[UIButton alloc]initWithFrame:CGRectMake(JP_KMARGIN, JP_KMARGIN+JP_KMARGIN/2, 40, 20)];
    [preViewBtn setTitle:@"预览" forState:UIControlStateNormal];
    [preViewBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [preViewBtn.titleLabel setFont:JP_FONTSIZE(15)];
    [preViewBtn addTarget:self action:@selector(preViewBtn) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:preViewBtn];
    
    sendBtn = [[UIButton alloc]initWithFrame:CGRectMake(bottomView.jp_w-JP_KMARGIN-60, JP_KMARGIN, 60, 30)];
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendBtn setBackgroundColor:[UIColor colorWithRed:31/255.0 green:185/255.0 blue:34/255.0 alpha:1.000]];
    [sendBtn.titleLabel setFont:JP_FONTSIZE(15)];
    [sendBtn addTarget:self action:@selector(sendPhoto) forControlEvents:UIControlEventTouchUpInside];
    sendBtn.layer.cornerRadius = 3;
    sendBtn.layer.masksToBounds = YES;
    [bottomView addSubview:sendBtn];

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
        [photoCollectionView reloadItemsAtIndexPaths:indexPaths];
    }];
    [self.navigationController pushViewController:screenPhotoCtrl animated:YES];
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
            [photoCollectionView reloadItemsAtIndexPaths:@[indexPath]];
        }else {
            for (NSInteger i = 0; i < self.seletedPhotoIndexPathArray.count ;i++) {
                JPPhotoModel *model = [self.seletedPhotoArray objectAtIndex:i];
                if (model.chooseIndex > photoModel.chooseIndex) {
                    model.chooseIndex -= 1;
                }
            }
            [photoCollectionView reloadItemsAtIndexPaths:self.seletedPhotoIndexPathArray];
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
- (void)preViewBtn{
    
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
        [photoCollectionView reloadItemsAtIndexPaths:indexPaths];
    }];
    [self.navigationController pushViewController:screenPhotoCtrl animated:YES];
}

- (void)sendPhoto{
    
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

@end
