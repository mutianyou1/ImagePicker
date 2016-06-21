//
//  MUPhotoSelectCollectionViewCell.m
//  上传相册
//
//  Created by mutianyou1 on 15/12/31.
//  Copyright © 2015年 mutianyou1. All rights reserved.
//

#import "MUPhotoSelectCollectionViewCell.h"
#import "MUAsset.h"
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import <AssetsLibrary/ALAsset.h>

#define CHECKBUTTON_WIDTH 28
@interface MUPhotoSelectCollectionViewCell()
//缩略图
@property (nonatomic,strong)UIImageView *thumbImageView;

@end
@implementation MUPhotoSelectCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUpSubViews];
        [self setUpSubViewsLayout];
        self.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:1.0];
    }
    return self;
}
- (void)setUpSubViewsLayout{
    _thumbImageView.frame = self.bounds;
    
    _checkButton.frame = CGRectMake(self.bounds.size.width - CHECKBUTTON_WIDTH, 0, CHECKBUTTON_WIDTH, CHECKBUTTON_WIDTH);
}
- (void)setUpSubViews{
    //缩略图
    self.thumbImageView = [[UIImageView alloc]init];
    [self.contentView addSubview:self.thumbImageView];
    //按钮
    self.checkButton = [[UIButton alloc]init];
    [self.checkButton setAdjustsImageWhenHighlighted:NO];
    [self.checkButton setBackgroundImage:[UIImage imageNamed:@"check_button_normal"] forState:UIControlStateNormal];
    [self.checkButton setBackgroundImage:[UIImage imageNamed:@"check_button_selected"] forState:UIControlStateSelected];
    [self.checkButton addTarget:self action:@selector(changeCheckButtonStatus:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.checkButton];

}

- (void)changeCheckButtonStatus:(UIButton*)button{
    if (self.photoCellDelegate && [self.photoCellDelegate respondsToSelector:@selector(photoCollectionViewCell:clickCheckButton:)]) {
        [self.photoCellDelegate photoCollectionViewCell:self clickCheckButton:button];
    }
}
- (void)setAsset:(MUAsset *)asset{
    _asset = asset;
    _thumbImageView.image = [UIImage imageWithCGImage:[asset.asset thumbnail]];
    _checkButton.selected = asset.isSelected;
}
@end
