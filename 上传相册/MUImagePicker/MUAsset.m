//
//  MUAsset.m
//  上传相册
//
//  Created by mutianyou1 on 15/12/31.
//  Copyright © 2015年 mutianyou1. All rights reserved.
//

#import "MUAsset.h"

@implementation MUAsset
- (instancetype)initWithAsset:(ALAsset *)asset{
    if (self = [super init]) {
        _asset = asset;
        _isSelected = NO;
    }
    return self;
}
+(instancetype)assetWithAsset:(ALAsset *)asset{
    return [[self alloc]initWithAsset:asset];
}
+ (MUAsset *)sharedAsset{
    static MUAsset *sharedMUAsset = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        sharedMUAsset = [[self alloc]init];
    });
    return sharedMUAsset;
}
- (instancetype)init{
    if (self = [super init]) {
        self.assetMutableArray = [NSMutableArray new];
    }
    return self;
}


@end
