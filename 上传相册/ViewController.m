//
//  ViewController.m
//  上传相册
//
//  Created by mutianyou1 on 15/12/28.
//  Copyright © 2015年 mutianyou1. All rights reserved.
//

#import "ViewController.h"
#import "MUImagePickerNavi.h"
#import "MUAlbumListTableViewController.h"
#import "MUPhotoViewController.h"
#import "MUAsset.h"
#import "UIImage+WaterMaker.h"
#import <AssetsLibrary/AssetsLibrary.h>
#define SIZE self.view.bounds.size.width

@interface ViewController ()<UIScrollViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic,strong)NSMutableArray *photoMutableArray;
@property (nonatomic,strong)UIPageControl *pageControl;
@property (nonatomic,strong)UIImageView *placeHolderImage;
@property (nonatomic) NSInteger numberOfPages;

@end

@implementation ViewController
- (NSMutableArray *)selectedAssetMutableArray{
    if (!_selectedAssetMutableArray) {
        _selectedAssetMutableArray = [NSMutableArray new];
    }
    return _selectedAssetMutableArray;
}
- (instancetype)init{
    if (self = [super init]) {
    }
    return self;
}
- (NSMutableArray *)photoMutableArray{
    if (!_photoMutableArray) {
        _photoMutableArray = [NSMutableArray new];
    }
    return _photoMutableArray;
}
- (void)viewDidLoad {
    
    //添加删除按钮pagecontroller
    [self addDeleteButtonAndPageControl];
    

    //添加滚动图片视图
    [self addPhotosInScrollView];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    
    //获取单例传值
    MUAsset *asset = [MUAsset sharedAsset];
    self.selectedAssetMutableArray = asset.assetMutableArray;
    [self getPhotoFromAsset:self.selectedAssetMutableArray];
    
}
#pragma mark--asset
- (void)getPhotoFromAsset:(NSMutableArray*)assetArray{
    if (assetArray.count == 0) {
        return;
    }
    //删除占位图
    [self.placeHolderImage removeFromSuperview];
    
    CGRect rect = [UIScreen mainScreen].bounds;
    self.pageControl.numberOfPages = assetArray.count;
    self.scrollView.contentSize = CGSizeMake(SIZE * assetArray.count, 0);
    self.numberOfPages = assetArray.count;
    for (MUAsset *asset in assetArray) {
        ALAssetRepresentation *representation = [asset.asset defaultRepresentation];
        UIImageView *imageView = [UIImageView new];
        imageView.image = [[UIImage imageWithCGImage:[representation fullScreenImage]]waterMakerWithString:@"by Mutianyou1"];
        rect.origin.x = [assetArray indexOfObject:asset] * SIZE;
        imageView.frame = rect;
        [self.scrollView addSubview:imageView];
    }
    
}



- (void)addDeleteButtonAndPageControl{
    //占位图片
    self.placeHolderImage = [[UIImageView alloc]init];
    self.placeHolderImage.backgroundColor = [UIColor blueColor];
    self.placeHolderImage.tag = 100;
    //删除按钮
    UIButton *deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width / 2 - 40, self.scrollView.center.y - 15, 80, 30)];
    [deleteButton setTitle:@"删除照片" forState:UIControlStateNormal];
    //添加删除方法：
    [deleteButton addTarget:self action:@selector(deletePhoto) forControlEvents:UIControlEventTouchUpInside];
    [deleteButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [self.view addSubview: deleteButton];
    
    //pageControl
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(self.view.bounds.size.width / 2 - 10, deleteButton.frame.origin.y + 40, 20, 20)];
    self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    self.pageControl.pageIndicatorTintColor = [UIColor blackColor];
    [self.view addSubview:self.pageControl];

}

- (void)addPhotosInScrollView{
    CGRect rect = self.scrollView.bounds;
    if (self.numberOfPages == 0) {
        //占位图片的添加
        self.placeHolderImage.frame = rect;
       [self.scrollView addSubview:self.placeHolderImage];
       self.scrollView.contentSize = CGSizeMake(SIZE, 0);

    }else{
        //置空
        if (self.numberOfPages == 1) {
            [self.placeHolderImage removeFromSuperview];
        }
        self.scrollView.contentSize = CGSizeMake(SIZE * self.numberOfPages, 0);

            //每次添加最后一个图片到scrollView上
            UIImageView *lastImageView = [self.photoMutableArray lastObject];
            rect.origin.x = SIZE * (self.numberOfPages - 1);
            lastImageView.frame = rect;
           [self.scrollView addSubview:lastImageView];
           self.pageControl.numberOfPages = self.numberOfPages;
    }
}
- (void)deletePhoto{
    UIImageView *currentPage = [self.scrollView viewWithTag:self.pageControl.currentPage];
    //先判断是否当前只有一张图片
    if (self.scrollView.subviews.count <= 1) {
        [[self.scrollView.subviews lastObject] removeFromSuperview];
        [self.scrollView addSubview:self.placeHolderImage];
        self.pageControl.numberOfPages = 0;
        self.numberOfPages = 0;
    }else{
    
    //如果当前事第一张
    if (self.pageControl.currentPage == 0) {
        UIImageView *image = [self.scrollView.subviews firstObject];
        [image removeFromSuperview];
        [self resetPhotos];

        
     //当前图片在中间
    }else if (self.pageControl.currentPage < self.scrollView.subviews.count - 1){
        //判断当前图片是否存在
        if (currentPage) {
            [currentPage removeFromSuperview];
            [self resetPhotos];
        }else{
            UIImageView *imageNext = self.scrollView.subviews[self.pageControl.currentPage + 1];
            [imageNext removeFromSuperview];
            [self resetPhotos];
        }
    //当前图片在最后
    }else{
        UIImageView *imageLast = [self.scrollView.subviews lastObject];
        [imageLast removeFromSuperview];
        [self resetPhotos];
    
    }
    }
}
- (void)resetPhotos{
    CGRect rect = self.scrollView.bounds;
    self.pageControl.numberOfPages --;
    self.numberOfPages --;
    self.scrollView.contentSize = CGSizeMake(self.numberOfPages * SIZE, 0);
    for (int i = 0; i < self.scrollView.subviews.count; i ++) {
        rect.origin.x = i * SIZE;
        self.scrollView.subviews[i].frame = rect;
    }
}
- (IBAction)uploadFromLocal:(id)sender {
    UIImagePickerController *imagePicker = [UIImagePickerController new];
    //设置资源类型
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    [self presentViewController:imagePicker animated:YES completion:nil];
}
- (IBAction)takePhoto:(id)sender {
    MUImagePickerNavi *MUPickerNV = [MUImagePickerNavi new];
    [self presentViewController:MUPickerNV animated:YES completion:nil];
    
}
- (IBAction)takePhoteAgain:(id)sender {
}

#pragma mark--ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
  //获取偏移量 左为正
    CGPoint offset = scrollView.contentOffset;
    NSInteger index = round(offset.x / scrollView.frame.size.width);
    self.pageControl.currentPage = index;
    for (UIImageView *imageView in scrollView.subviews) {
        imageView.tag = index;
    }
}

#pragma mark--ImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    //清空数组
    [self.photoMutableArray removeAllObjects];
    self.numberOfPages ++;
    
    //将图片添加到数组中
    [self.photoMutableArray addObject:imageView];
    //将数组中的图片显示到scrollView上
    [self addPhotosInScrollView];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
