//
//  MUPhotoSelectCollectionViewCell.h
//  上传相册
//
//  Created by mutianyou1 on 15/12/31.
//  Copyright © 2015年 mutianyou1. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MUAsset;
@class MUPhotoSelectCollectionViewCell;

@protocol MUPhotoSelectCollectionViewCellDelegate <NSObject>
-(void)photoCollectionViewCell:(MUPhotoSelectCollectionViewCell*)cell clickCheckButton:(UIButton*)button;
@end
@interface MUPhotoSelectCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong)MUAsset *asset;
@property (nonatomic,weak) id<MUPhotoSelectCollectionViewCellDelegate>photoCellDelegate;
//按钮
@property (nonatomic,strong)UIButton *checkButton;
@end
