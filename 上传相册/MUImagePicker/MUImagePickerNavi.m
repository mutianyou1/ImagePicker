//
//  MUImagePickerNavi.m
//  上传相册
//
//  Created by mutianyou1 on 15/12/30.
//  Copyright © 2015年 mutianyou1. All rights reserved.
//

#import "MUImagePickerNavi.h"
#import "MUAlbumListTableViewController.h"
@interface MUImagePickerNavi ()
@end

@implementation MUImagePickerNavi

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (instancetype)init{
    MUAlbumListTableViewController *listTableVC = [MUAlbumListTableViewController new];
    return [super initWithRootViewController:listTableVC];
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
