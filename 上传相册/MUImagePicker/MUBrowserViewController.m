//
//  MUBrowserViewController.m
//  上传相册
//
//  Created by mutianyou1 on 15/12/31.
//  Copyright © 2015年 mutianyou1. All rights reserved.
//

#import "MUBrowserViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
#import "MuBigScrollView.h"
#import "MUAsset.h"
#define WIDTH   [UIScreen mainScreen].bounds.size.width
#define HEIGHT  [UIScreen mainScreen].bounds.size.height
#define BUTTON_WIDTH 28
#define LABEL_HEIGHT 20
#define kOffsetIndex 100
#define kPadding 20
@interface MUBrowserViewController ()<UIScrollViewDelegate>{
    NSMutableSet *_visibleAsset;
    NSMutableSet *_reuseAsset;
}
@property (nonatomic,strong)UIScrollView *photoScrollView;
@property (nonatomic,strong)UIButton *cancelButton;
@property (nonatomic,assign)NSInteger pageIndext;
@property (nonatomic,strong)NSMutableArray *selectedIndextArray;

@end

@implementation MUBrowserViewController
- (NSMutableArray *)selectedIndextArray{
    if (!_selectedIndextArray) {
        _selectedIndextArray = [NSMutableArray new];
    }
    return _selectedIndextArray;
}
- (instancetype)init{
    if (self = [super init]) {
        //如果有必要初始化在这里设置
       // [self setUpTopTollBar];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTopTollBar];
    //设置页面
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = [NSString stringWithFormat:@"(%lu/%lu)",(unsigned long)self.selectedAssetArray.count,(unsigned long)self.selectedAssetArray.count];
    
   //添加滚动预览视图
    [self setUpPhotoScrollView];
    self.photoScrollView.delegate = self;
    self.photoScrollView.pagingEnabled = YES;
    


}

- (void)setUpPhotoScrollView{
    
    self.photoScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(-kPadding, 0, WIDTH+2 *kPadding, HEIGHT)];
    self.photoScrollView.showsHorizontalScrollIndicator = NO;
    self.photoScrollView.showsVerticalScrollIndicator = NO;
    

    self.photoScrollView.contentSize = CGSizeMake(_selectedAssetArray.count * (WIDTH+ 2 *kPadding), 0);
    [self.view addSubview:self.photoScrollView];
    _visibleAsset = [NSMutableSet set];
    _reuseAsset = [NSMutableSet set];
//    for (MUAsset *asset in self.selectedAssetArray) {
//        ALAssetRepresentation *representation = [asset.asset defaultRepresentation];
//        NSInteger index = [self.selectedAssetArray indexOfObject:asset];
//        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH * index, 0, WIDTH, HEIGHT)];
//        imageView.image = [UIImage imageWithCGImage:[representation fullResolutionImage]];
//        [self.photoScrollView addSubview:imageView];
//    }
    
    
}

- (void)setUpTopTollBar{
    
    //button for cancel
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelButton.frame = CGRectMake(0, 0, BUTTON_WIDTH, BUTTON_WIDTH);
    //设置背景图片 正常为高亮色
    [self.cancelButton setBackgroundImage:[UIImage imageNamed:@"check_button_normal"] forState:UIControlStateNormal];
    [self.cancelButton setBackgroundImage:[UIImage imageNamed:@"check_button_selected"] forState:UIControlStateSelected];

    [self.cancelButton addTarget:self action:@selector(clickCancelSelected:) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *cancelItem =[[UIBarButtonItem alloc]initWithCustomView:self.cancelButton];
    self.navigationItem.rightBarButtonItem = cancelItem;
    
    //button for back
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_btn_normal"] forState:UIControlStateNormal];
    backButton.frame = CGRectMake(0, 0, BUTTON_WIDTH, BUTTON_WIDTH);
    [backButton addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backItem;
    
    
}
- (void)clickCancelSelected:(UIButton*)button{
    MUAsset *asset = self.selectedAssetArray[self.pageIndext];
    asset.isSelected = !asset.isSelected;
    button.selected = asset.isSelected;
    if (!button.isSelected) {
        [self.selectedIndextArray addObject:asset];
        
    }else{
        [self.selectedIndextArray removeObject:asset];
    }

    

}
- (void)clickBack{
    
    NSMutableArray *resultMutableArray = [NSMutableArray arrayWithArray:self.selectedAssetArray];
    for (int i = 0; i < self.selectedIndextArray.count; i++) {
        MUAsset *asset = self.selectedIndextArray[i];
       [resultMutableArray removeObject:asset];
    }
    _backSelectedResults(resultMutableArray);
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark--ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
  //偏移量 左为正数
    CGPoint offset = scrollView.contentOffset;
    NSInteger indext = round(offset.x / scrollView.frame.size.width);
    
    //pageIndext
    self.pageIndext = indext;
    
    //button statude
    MUAsset *asset = self.selectedAssetArray[indext];
    self.cancelButton.selected = asset.isSelected;
    self.title = [NSString stringWithFormat:@"(%lu/%lu)",indext+1,(unsigned long)self.selectedAssetArray.count];
    [self showBigScrollView];

}
- (void)showBigScrollView{
    if (_selectedAssetArray.count == 1 && _visibleAsset.count == 1) {
        return;
    }
    if (_selectedAssetArray.count == 1) {
        [self addBigScrollViewWithIndex:0];
        return;
    }
    CGRect rect = _photoScrollView.bounds;
    int firstIndex = (int)floorf((CGRectGetMinX(rect)+2*kPadding)/CGRectGetWidth(rect));
    int lastIndex = (int)floorf((CGRectGetMaxX(rect)-2*kPadding)/CGRectGetWidth(rect));
    if (firstIndex < 0) {
        firstIndex = 0;
    }
    if (lastIndex >= _selectedAssetArray.count) {
        lastIndex --;
    }
    if (firstIndex >= _selectedAssetArray.count) {
        firstIndex --;
    }
   // NSLog(@"first%d---last%d",firstIndex,lastIndex);
    for (MuBigScrollView *scrollView in _visibleAsset) {
        NSInteger index = [scrollView tag] - kOffsetIndex;
        if (index > lastIndex || index < firstIndex) {
            scrollView.zoomScale = 1.0;
            [_reuseAsset addObject:scrollView];
            [scrollView removeFromSuperview];
        }
        
    }
    [_visibleAsset minusSet:_reuseAsset];
    while (_reuseAsset.count > 2) {
        [_reuseAsset removeObject:[_reuseAsset anyObject]];
    }
    for (NSInteger index = firstIndex; index <= lastIndex; index++) {
        if (![self isBingScrollViewOnScreen:index]) {
            [self addBigScrollViewWithIndex:index];
        }
    }
    
}
- (void)addBigScrollViewWithIndex:(NSInteger)index{
    CGRect rect = self.view.bounds;
    CGRect photoRect = rect;
    photoRect.origin.x = (rect.size.width + 2 *kPadding) * index + kPadding;
    MuBigScrollView *bigScrollView = [self dequeueReusebigScrollView];
    if (!bigScrollView) {
        bigScrollView = [[MuBigScrollView alloc]initWithFrame:photoRect];
    }
    bigScrollView.frame = photoRect;
    bigScrollView.tag = index + kOffsetIndex;
    bigScrollView.selectedAsset = _selectedAssetArray[index];
    [_visibleAsset addObject:bigScrollView];
    [_photoScrollView addSubview:bigScrollView];
    
    
}
- (MuBigScrollView*)dequeueReusebigScrollView{
    MuBigScrollView *scrlloView = [_reuseAsset anyObject];
    if (scrlloView) {
        [_reuseAsset removeObject:scrlloView];
    }
    return scrlloView;
}
- (BOOL)isBingScrollViewOnScreen:(NSInteger)index{
    for (MuBigScrollView *scrollView in _visibleAsset) {
        if (index == [scrollView tag] - kOffsetIndex) {
            return YES;
        }
    }
    return NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
