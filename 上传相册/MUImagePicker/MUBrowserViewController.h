//
//  MUBrowserViewController.h
//  上传相册
//
//  Created by mutianyou1 on 15/12/31.
//  Copyright © 2015年 mutianyou1. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^backSelectedResults)(NSMutableArray *selected);
@class MUAsset;
@interface MUBrowserViewController : UIViewController
@property (nonatomic,strong)MUAsset *asset;
@property (nonatomic,strong)NSMutableArray *selectedAssetArray;
@property (nonatomic,copy) backSelectedResults backSelectedResults;
@end
