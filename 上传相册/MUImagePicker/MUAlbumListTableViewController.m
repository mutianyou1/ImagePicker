//
//  MUAlbumListTableViewController.m
//  上传相册
//
//  Created by mutianyou1 on 15/12/31.
//  Copyright © 2015年 mutianyou1. All rights reserved.
//

#import "MUAlbumListTableViewController.h"
#import "MUAlbumListTableViewCell.h"
//此控制器可以显示每张照片、预览、点选
//结构：vc + collectiontableview + vc
#import "MUPhotoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AssetsLibrary/ALAssetsGroup.h>

static NSString *reuseidentifier = @"albumCell";

@interface MUAlbumListTableViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)ALAssetsLibrary *assetsLibrary;
@property (nonatomic,strong)NSMutableArray *albumMutableArray;
@property (nonatomic,strong)NSMutableArray *photoMutableArray;
@end

@implementation MUAlbumListTableViewController


- (ALAssetsLibrary *)assetsLibrary{
    if (!_assetsLibrary) {
        _assetsLibrary = [ALAssetsLibrary new];
    }
    return _assetsLibrary;
}
- (NSMutableArray *)albumMutableArray{
    if (!_albumMutableArray) {
        _albumMutableArray = [NSMutableArray new];
    }
    return _albumMutableArray;
}
- (NSMutableArray *)photoMutableArray{
    if (!_photoMutableArray) {
        _photoMutableArray = [NSMutableArray new];
    }
    return _photoMutableArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"相簿";
   
    [self getAssetsGroupData];
    //设置代理、注册
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[MUAlbumListTableViewCell class] forCellReuseIdentifier:reuseidentifier];
    //防止同时分享时修改
    [ALAssetsLibrary disableSharedPhotoStreamsSupport];
    
    //设置高度
    self.tableView.rowHeight = 70;
    
    //添加左侧返回按钮
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(clickBack)];
    self.navigationItem.leftBarButtonItem = buttonItem;
}

- (void)clickBack{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark--getAssetsGroupData
- (void)getAssetsGroupData{
 
   
    __weak typeof(self) weakSelf = self;
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    NSBlockOperation *enumOperation = [NSBlockOperation blockOperationWithBlock:^{
        
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
        [weakSelf.albumMutableArray addObject:group];
        }
        [self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:YES];
        } failureBlock:^(NSError *error) {
            NSLog(@"can not found any album");
        }
         
         ];
    }];
    
    [mainQueue addOperation:enumOperation];
    
    
}
- (void)reloadTableView{
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.albumMutableArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ALAssetsGroup *group = self.albumMutableArray[indexPath.row];
    MUAlbumListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseidentifier forIndexPath:indexPath];
    
    
    if (!cell) {
        cell = [[MUAlbumListTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseidentifier];
    }
    cell.assetsGroup = group;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ALAssetsGroup *group = self.albumMutableArray[indexPath.row];
    MUPhotoViewController *photoViewVC = [MUPhotoViewController new];
    photoViewVC.group = group;
    
    [self.navigationController pushViewController:photoViewVC animated:YES];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
