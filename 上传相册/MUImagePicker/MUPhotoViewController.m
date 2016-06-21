//
//  MUPhotoViewController.m
//  上传相册
//
//  Created by mutianyou1 on 15/12/31.
//  Copyright © 2015年 mutianyou1. All rights reserved.
//

#import "MUPhotoViewController.h"
//用于显示每张照片
#import "MUPhotoSelectCollectionViewCell.h"
//用于预览每张照片
#import "MUBrowserViewController.h"
#import "ViewController.h"
#import "MUAsset.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#define HEIGHT  [UIScreen mainScreen].bounds.size.height
#define WIDTH   [UIScreen mainScreen].bounds.size.width
#define ITEM_MARGIN 2
#define ITEM_EDGE 10
#define LINE_ITEM_NUMBER 4
//平安橙色
#define BACKGROUNDCOLOR [[UIColor alloc]initWithRed:255 / 255.0 green:82 / 255.0 blue:31 / 255.0 alpha:0.5]
static NSString *collectionReuseidentifier = @"collectionCell";

@interface MUPhotoViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,MUPhotoSelectCollectionViewCellDelegate>

@property (nonatomic,strong)UIView *toolBarView;
@property (nonatomic,strong)UILabel *selectedLabel;
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)NSArray *assetArray;

//collectionview must  needed layout
@property (nonatomic,strong)UICollectionViewFlowLayout *flowLayout;
@end

@implementation MUPhotoViewController
//lazy loading
- (UICollectionViewFlowLayout *)flowLayout{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc]init];
        // itemwidth * number + margin * (number + 1) = width
        CGFloat itemWidth = (WIDTH - ITEM_MARGIN * (LINE_ITEM_NUMBER + 1) )/ LINE_ITEM_NUMBER;
        _flowLayout.itemSize = CGSizeMake(itemWidth, itemWidth);
        _flowLayout.minimumInteritemSpacing = ITEM_MARGIN;
        _flowLayout.minimumLineSpacing = ITEM_MARGIN;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
    }
    return _flowLayout;
}
- (NSArray *)assetArray{
    if (!_assetArray) {
        _assetArray = [NSArray new];
    }
    return _assetArray;
}
- (NSMutableArray *)selectedAssetMutableArray{
    if (!_selectedAssetMutableArray) {
        _selectedAssetMutableArray = [NSMutableArray new];
    }
    return _selectedAssetMutableArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"相机照片";
    [self setToolBarAndCollectionView];
    
    //注册collectionView
    [self.collectionView registerClass:[MUPhotoSelectCollectionViewCell class] forCellWithReuseIdentifier:collectionReuseidentifier];
    
    
}
#pragma mark--ToolBarAndClickToolBar
- (void)setToolBarAndCollectionView{
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0,WIDTH, HEIGHT - 40) collectionViewLayout:self.flowLayout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    
    
    //toolBarView
    self.toolBarView = [[UIView alloc]initWithFrame:CGRectMake(0,HEIGHT - 40 , WIDTH, 40)];
    self.toolBarView.backgroundColor = BACKGROUNDCOLOR;
    [self.view addSubview:self.toolBarView];
    
    //预览按钮
    UIButton *browserButton = [[UIButton alloc]initWithFrame:CGRectMake(20, HEIGHT - 30 , 60, 20)];
    [browserButton setTitle:@"预览" forState:UIControlStateNormal];
    [browserButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [browserButton addTarget:self action:@selector(clickBrowser) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:browserButton];
    
    //完成按钮
    UIButton *doneButton = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 80, HEIGHT - 30, 60, 20)];
    [doneButton setTitle:@"完成" forState:UIControlStateNormal];
    [doneButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [doneButton addTarget:self action:@selector(clickDone) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:doneButton];
    
    //选择张数label
    self.selectedLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH / 2 - 15, HEIGHT - 30, 60, 20)];
    self.selectedLabel.text = @"(0/4)";
    [self.view addSubview:self.selectedLabel];
}
- (void)updateSelectedLabelTextNumber{
    self.selectedLabel.text = [NSString stringWithFormat:@"(%lu/4)",(unsigned long)self.selectedAssetMutableArray.count];
}
- (void)clickBrowser{
    if (self.selectedAssetMutableArray.count < 1) {
        return;
    }else{
        MUBrowserViewController *browserViewController = [MUBrowserViewController new];
        __weak typeof(self) weakSelf = self;
        browserViewController.backSelectedResults = ^(NSMutableArray *backSelectedArray){
            weakSelf.selectedAssetMutableArray = [NSMutableArray arrayWithArray:backSelectedArray];
            [weakSelf.collectionView reloadData];
            [weakSelf updateSelectedLabelTextNumber];
        
        };
        browserViewController.selectedAssetArray = weakSelf.selectedAssetMutableArray;
        [self.navigationController pushViewController:browserViewController animated:YES];
    }
}
- (void)clickDone{
    UIStoryboard *mainStory = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *mainVC = [mainStory instantiateViewControllerWithIdentifier:@"MainVC"];
    
    MUAsset *asset = [MUAsset sharedAsset];
    asset.assetMutableArray = self.selectedAssetMutableArray.copy;
    [self presentViewController:(ViewController*)mainVC animated:YES completion:nil];
}
#pragma mark--collectionTableViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.assetArray.count;
  
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MUPhotoSelectCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionReuseidentifier forIndexPath:indexPath];
    cell.photoCellDelegate = self;
    cell.asset = self.assetArray[indexPath.row];
    cell.tag = indexPath.row;
    
    
    
    return cell;

}


#pragma mark--set data
- (void)setGroup:(ALAssetsGroup *)group{
    __block NSMutableArray *assetMutableArray = [NSMutableArray new];
    [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) {
            MUAsset *asset = [MUAsset assetWithAsset:result];
            [assetMutableArray insertObject:asset atIndex:0];
        }
    }];
    self.assetArray = assetMutableArray.copy;
  
}
#pragma mark--photoCollectionViewDelegate
- (void)photoCollectionViewCell:(MUPhotoSelectCollectionViewCell *)cell clickCheckButton:(UIButton *)button{
    
 
    
    if (self.selectedAssetMutableArray.count >= 4 && !button.selected) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"最多只能选4张" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }else{
        button.selected = !button.selected;
        cell.asset.isSelected = !cell.asset.isSelected;
        if (button.selected) {
            [self.selectedAssetMutableArray addObject:cell.asset];
        }else{
            [self.selectedAssetMutableArray removeObject:cell.asset];
        }
        [self updateSelectedLabelTextNumber];
    }
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
