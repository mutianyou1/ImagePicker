//
//  MuBigScrollView.m
//  上传相册
//
//  Created by mutianyou1 on 16/6/5.
//  Copyright © 2016年 mutianyou1. All rights reserved.
//

#import "MuBigScrollView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "MUAsset.h"
@interface MuBigScrollView()<UIScrollViewDelegate>{
    UIImageView *_imageView;
}

@end
@implementation MuBigScrollView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.userInteractionEnabled = YES;
        _imageView = [[UIImageView alloc]initWithFrame:frame];
        [self addSubview:_imageView];
        
        self.delegate = self;
        UITapGestureRecognizer *tapOne = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickOringal)];
        tapOne.numberOfTapsRequired = 1;
        
        [self addGestureRecognizer:tapOne];
        self.maximumZoomScale = 3.0;
        self.minimumZoomScale = 1.0;
        
        
        
    }
    
    
    return self;
}
- (void)clickOringal{
    [self setZoomScale:1.0 animated:YES];
    [UIView animateWithDuration:0.5 animations:^{
        _imageView.frame = self.bounds;
    }];
}

- (void)setSelectedAsset:(MUAsset *)selectedAsset{
    if (selectedAsset) {
        _selectedAsset = selectedAsset;
        _imageView.image = [UIImage imageWithCGImage:[[_selectedAsset.asset defaultRepresentation] fullScreenImage]];
        _imageView.frame = self.bounds;
    }
   // self.contentSize = CGSizeMake(0, _imageView.frame.size.height);
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _imageView;
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width) ? (scrollView.bounds.size.width - scrollView.contentSize.width)*0.5:0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height) ? (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0;
    _imageView.center = CGPointMake(offsetX+scrollView.contentSize.width * 0.5, offsetY + scrollView.contentSize.height * 0.5);
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
