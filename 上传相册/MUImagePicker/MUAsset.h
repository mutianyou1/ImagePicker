//
//  MUAsset.h
//  上传相册
//
//  Created by mutianyou1 on 15/12/31.
//  Copyright © 2015年 mutianyou1. All rights reserved.
//

#import <Foundation/Foundation.h>

//
@class ALAsset;
@interface MUAsset : NSObject
@property (nonatomic,strong) ALAsset *asset;
@property (nonatomic,assign)BOOL isSelected;
@property (nonatomic,strong)NSMutableArray *assetMutableArray;
- (instancetype)initWithAsset:(ALAsset*)asset;
+ (instancetype)assetWithAsset:(ALAsset*)asset;
+(MUAsset*)sharedAsset;
@end
