//
//  JPPhotoGroupCell.m
//
//
//  Copyright © dongjiangpeng. All rights reserved.
//

#import "JPPhotoGroupCell.h"
#import "JPPhotoGroupModel.h"
#import "UIView+JP_Frame.h"
#import "BaseConst.h"

@interface JPPhotoGroupCell ()

/** 缩略图 */
@property(nonatomic,strong)UIImageView *thumbImage;
/** 相册组名 */
@property(nonatomic,strong)UILabel *groupName;
/** 相册总数 */
@property(nonatomic,strong)UILabel *imageCount;

@end

@implementation JPPhotoGroupCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.thumbImage];
        [self.contentView addSubview:self.groupName];
        [self.contentView addSubview:self.imageCount];
    }
    return self;
}

- (UIImageView *)thumbImage{
    
    if (!_thumbImage) {
        _thumbImage = [[UIImageView alloc]init];
        [_thumbImage setContentScaleFactor:[[UIScreen mainScreen] scale]];
        _thumbImage.contentMode =  UIViewContentModeScaleAspectFill;
        _thumbImage.clipsToBounds  = YES;
    }
    return _thumbImage;
}

- (UILabel *)groupName{
    
    if (!_groupName) {
        _groupName = [[UILabel alloc]init];
        _groupName.textColor = [UIColor blackColor];
        _groupName.font = JP_FONTSIZE(15);
    }
    return _groupName;
}

- (UILabel *)imageCount{
    
    if (!_imageCount) {
        _imageCount = [[UILabel alloc]init];
        _imageCount.textColor = [UIColor grayColor];
        _imageCount.font = JP_FONTSIZE(15);
    }
    return _imageCount;
}



- (void)setGroupModel:(JPPhotoGroupModel *)groupModel{
    
    _groupModel = groupModel;
    
    self.thumbImage.image = groupModel.thumbImage;
    self.groupName.text = groupModel.groupName;
    self.imageCount.text = [NSString stringWithFormat:@"(%zd)",groupModel.assetsCount];
    
    self.thumbImage.frame = CGRectMake(0, 0, 80, 80);
    
    self.groupName.frame = CGRectMake(CGRectGetMaxX(self.thumbImage.frame)+JP_KMARGIN, 0, [self.groupName.text sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]}].width+JP_KMARGIN*0.5, self.thumbImage.jp_h);
    
    self.imageCount.frame = CGRectMake(CGRectGetMaxX(self.groupName.frame)+JP_KMARGIN, 0, [self.imageCount.text sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]}].width+JP_KMARGIN, self.thumbImage.jp_h);
}

@end
