//
//  JPChoosePicView.m
//  
//
//  Created by Keep丶Dream on 2017/10/18.
//  Copyright © 2017年 dong. All rights reserved.
//

#import "JPChoosePicView.h"
#import "JPPhoto.h"
#import "JPShowBigImageView.h"

@interface JPChoosePicView()<UICollectionViewDelegate,UICollectionViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate,JPPhotoManagerDelegate>
/** addBtn */
@property(nonatomic,weak) UIButton *addBtn;
/** collection */
@property(nonatomic,weak) UICollectionView *collectionView;

@end

@implementation JPChoosePicView
{
    CGFloat _viewWidth;
    CGFloat _itemW;
}

-(NSMutableArray *)imageArray {
    
    if (!_imageArray) {
        
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.backgroundColor = [UIColor clearColor];
        [self p_SetupUI];
    }
    return self;
}

#pragma mark -UI
- (void)p_SetupUI {
    
    _viewWidth = self.frame.size.width;
    _itemW = (_viewWidth-10*2)/3.0;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
    layout.itemSize = CGSizeMake(_itemW, _itemW);
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, _viewWidth, self.frame.size.height) collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    collectionView.backgroundColor = [UIColor clearColor];
    [self addSubview:collectionView];
    self.collectionView = collectionView;
    
    UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, _itemW, _itemW)];
    [addBtn setBackgroundImage:[UIImage imageNamed:@"add_pic"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(p_AddBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:addBtn];
    self.addBtn = addBtn;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    if (cell.subviews.count) {
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.contentView.bounds];
    UIImage *image = (UIImage *)self.imageArray[indexPath.item];
    imageView.image = image;
    [cell.contentView addSubview:imageView];
    
    UIButton *closeImageBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(imageView.frame) - 20, 0, 20, 20)];
    [closeImageBtn setBackgroundImage:[UIImage imageNamed:@"close_icon"] forState:UIControlStateNormal];
    [closeImageBtn addTarget:self action:@selector(p_CloseImage:) forControlEvents:UIControlEventTouchUpInside];
    closeImageBtn.tag = indexPath.item;
    
    imageView.userInteractionEnabled = YES;
    [imageView addSubview:closeImageBtn];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UIImage *image = (UIImage *)self.imageArray[indexPath.item];
    [JPShowBigImageView showBigImageWithImage:image];
}


#pragma mark -changeBtn
- (void)p_ChangeBtnFrame {
    
    NSInteger arrCount = self.imageArray.count;
    
    if (arrCount >= 9) {
        self.addBtn.hidden = YES;
    }else {
        self.addBtn.hidden = NO;
    }
    NSInteger btnX = (_itemW+10)*(arrCount%3);
    NSInteger btnY = (_itemW+10)*(arrCount/3);
    [UIView animateWithDuration:0.3 animations:^{
        self.addBtn.frame = CGRectMake(btnX, btnY, _itemW, _itemW);
    }];
}

#pragma mark -删除
- (void)p_CloseImage:(UIButton *)closeBtn {
    
    [self.collectionView  performBatchUpdates:^ {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:closeBtn.tag inSection:0];
        [self.imageArray removeObjectAtIndex:closeBtn.tag];
        [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
        
    } completion:^(BOOL finished) {
        [self.collectionView  reloadData];
        
    }];
    [self p_ChangeBtnFrame];
}

#pragma mark -p_AddBtnClick
- (void)p_AddBtnClick {

    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertCtrl addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //启动图片选择器
        [[JPPhotoManager sharedPhotoManager] jp_OpenPhotoListWithController:self.superViewController MaxImageCount:9-self.imageArray.count];
        //设置代理
        [JPPhotoManager sharedPhotoManager].delegate = self;
    }]];
    [alertCtrl addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        UIImagePickerController *cameraCtrl = [[UIImagePickerController alloc] init];
        cameraCtrl.sourceType = UIImagePickerControllerSourceTypeCamera;
        cameraCtrl.allowsEditing = NO;
        cameraCtrl.delegate = self;
        [self.superViewController  presentViewController:cameraCtrl animated:YES completion:nil];
        
    }]];
        
    [alertCtrl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self.superViewController presentViewController:alertCtrl animated:YES completion:nil];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.imageArray addObject:image];
    [self.collectionView reloadData];
    [self p_ChangeBtnFrame];
}
#pragma mark - JPPhotoManagerDelegate
- (void)jp_ImagePickerControllerDidFinishPickingMediaWithThumbImages:(NSArray *)thumbImages originalImages:(NSArray *)originalImages {
    
    [self.imageArray addObjectsFromArray:originalImages];
    [self.collectionView reloadData];
    [self p_ChangeBtnFrame];

}

- (void)jp_ImagePickerControllerDidCancel {
    
}
@end
