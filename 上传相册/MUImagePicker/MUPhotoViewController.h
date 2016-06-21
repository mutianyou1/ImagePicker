//
//  MUPhotoViewController.h
//  上传相册
//
//  Created by mutianyou1 on 15/12/31.
//  Copyright © 2015年 mutianyou1. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ALAssetsGroup;

@interface MUPhotoViewController : UIViewController
@property (nonatomic,strong) ALAssetsGroup *group;
@property (nonatomic,strong)NSMutableArray *selectedAssetMutableArray;
@end
