//
//  JPPhotoCollectionViewCell.h
//  单个照片
//
//  Copyright © dongjiangpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JPPhotoCollectionViewCellDelegate <NSObject>

- (void)thumbImageSeletedChooseIndexPath:(NSIndexPath *)indexPath selectedBtn:(UIButton *)selectedBtn;

@end

@class JPPhotoModel;
@interface JPPhotoCollectionViewCell : UICollectionViewCell

@property(nonatomic,strong)JPPhotoModel *photoModel;

/** delegate */
@property(nonatomic,weak) id<JPPhotoCollectionViewCellDelegate> delegate;


@end
