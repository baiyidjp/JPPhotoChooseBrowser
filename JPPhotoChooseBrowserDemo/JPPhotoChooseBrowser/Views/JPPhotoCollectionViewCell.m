//
//  JPPhotoCollectionViewCell.m
//  WeChat_D
//
//  Created by tztddong on 16/8/10.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "JPPhotoCollectionViewCell.h"
#import "JPPhotoModel.h"
#import "UIView+JP_Frame.h"

@interface JPPhotoCollectionViewCell()

@property(nonatomic,strong)UIImageView *photoImage;
@property(nonatomic,strong)UIButton *selectBtn;
@property(nonatomic,strong)UIView *bottomView;
@property(nonatomic,strong)UIImageView *videoImage;
@property(nonatomic,strong)UILabel *videoTime;

@end

@implementation JPPhotoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.userInteractionEnabled = YES;
        [self.contentView addSubview:self.photoImage];
        [self.contentView addSubview:self.selectBtn];
        [self.contentView addSubview:self.bottomView];
        [self.contentView addSubview:self.videoImage];
        [self.contentView addSubview:self.videoTime];
    }
    return self;
}

- (UIImageView *)photoImage{
    
    if (!_photoImage) {
        _photoImage = [[UIImageView alloc]init];
        [_photoImage setContentScaleFactor:[[UIScreen mainScreen] scale]];
        _photoImage.contentMode =  UIViewContentModeScaleAspectFill;
        _photoImage.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _photoImage.clipsToBounds  = YES;
    }
    return _photoImage;
}

- (UIButton *)selectBtn{
    
    if (!_selectBtn) {
        _selectBtn = [[UIButton alloc]init];
        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"FriendsSendsPicturesSelectIcon_27x27_"] forState:UIControlStateNormal];
        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"FriendsSendsPicturesSelectIcon_27x27_"] forState:UIControlStateHighlighted];
        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"FriendsSendsPicturesSelectYIcon_27x27_"] forState:UIControlStateSelected];
        [_selectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_selectBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_selectBtn addTarget:self action:@selector(clickSelectBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectBtn;
}

- (UIView *)bottomView{
    
    if (!_bottomView) {
        
        _bottomView = [[UIView alloc]init];
        _bottomView.backgroundColor = [UIColor blackColor];
        _bottomView.alpha = 0.5;
    }
    return _bottomView;
}

- (UIImageView *)videoImage{
    
    if (!_videoImage) {
        
        _videoImage = [[UIImageView alloc]init];
        _videoImage.image = [UIImage imageNamed:@"News_VideoBIG_31x31_"];
    }
    return _videoImage;
}

- (UILabel *)videoTime{
    
    if (!_videoTime) {
        _videoTime = [[UILabel alloc]init];
        _videoTime.textColor = [UIColor whiteColor];
        _videoTime.textAlignment = NSTextAlignmentRight;
        _videoTime.font = JP_FONTSIZE(10);
    }
    return _videoTime;
}

- (void)setPhotoModel:(JPPhotoModel *)photoModel{
    
    _photoModel = photoModel;
    
    [photoModel JPThumbImageWithBlock:^(UIImage *thumbImage) {
        
        self.photoImage.image = thumbImage;
    }];

    self.selectBtn.selected = photoModel.isSelect;
    [self.selectBtn setTitle:[NSString stringWithFormat:@"%zd",photoModel.chooseIndex] forState:UIControlStateSelected];
    
    self.selectBtn.hidden = photoModel.isVideoType;
    self.bottomView.hidden = !photoModel.isVideoType;
    self.videoImage.hidden = !photoModel.isVideoType;
    self.videoTime.hidden = !photoModel.isVideoType;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    self.photoImage.frame = self.bounds;
    self.selectBtn.frame = CGRectMake(self.jp_w-3-27, 3, 27, 27);
    self.bottomView.frame = CGRectMake(0, self.jp_h-2*JP_KMARGIN, self.jp_w, 2*JP_KMARGIN);
    self.videoImage.frame = CGRectMake(JP_KMARGIN*0.5, self.bottomView.jp_h*0.5-15*0.5, 15, 15);
    self.videoTime.frame = CGRectMake(self.jp_w-40-JP_KMARGIN*0.5, 0, 40, self.jp_h);
}

- (void)clickSelectBtn{
    
    
    if ([self.delegate respondsToSelector:@selector(thumbImageSeletedChooseIndexPath:selectedBtn:)]) {
        [self.delegate thumbImageSeletedChooseIndexPath:self.photoModel.indexPath selectedBtn:self.selectBtn];
    }
}

@end
