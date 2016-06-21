//
//  MUAlbumListTableViewCell.m
//  上传相册
//
//  Created by mutianyou1 on 15/12/31.
//  Copyright © 2015年 mutianyou1. All rights reserved.
//

#import "MUAlbumListTableViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AssetsLibrary/ALAssetsGroup.h>

@interface MUAlbumListTableViewCell ()
@property (nonatomic,strong)UIImageView *albumIcon;
@property (nonatomic,strong)UILabel *albumNameLabel;
@property (nonatomic,strong)UILabel *photosNumberLabel;
@end
@implementation MUAlbumListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"albumCell"]) {
        [self setUpDetail];
        //右箭头
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;

}
- (void)setUpDetail{
    self.albumIcon = [[UIImageView alloc]initWithFrame:CGRectMake(15, 2, 66, 66)];
    self.albumNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(83, 10, 120, 30)];
    self.photosNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(83, 32, 20, 30)];
    
    self.albumIcon.backgroundColor = [UIColor yellowColor];
    self.albumNameLabel.text = @"相机胶卷";
    self.photosNumberLabel.text = @"10";
    
    [self addSubview:self.albumIcon];
    [self addSubview:self.albumNameLabel];
    [self addSubview:self.photosNumberLabel];
}


//group 重写set方法
- (void)setAssetsGroup:(ALAssetsGroup *)assetsGroup{
    _assetsGroup = assetsGroup;
    _albumIcon.image = [UIImage imageWithCGImage:[assetsGroup posterImage]];
    _albumNameLabel.text = [assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    _photosNumberLabel.text = [NSString stringWithFormat:@"%ld",(long)[assetsGroup numberOfAssets]];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
