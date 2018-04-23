//
//  JPPhotoGroupListController.m
//
//
//  Copyright © dongjiangpeng. All rights reserved.
//

#import "JPPhotoGroupListController.h"
#import "JPPhotoGroupModel.h"
#import "JPPhotoGroupCell.h"
#import "JPPhotoListController.h"
#import "JPPhotoKitManager.h"
#import "BaseConst.h"
#import "JPPhotoManager.h"

#define GroupCellID @"JPPhotoGroupCell"
@interface JPPhotoGroupListController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSMutableArray *groupDataArray;
@end

@implementation JPPhotoGroupListController
{
    UITableView *groupTableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"照片";
    
    UIButton *cancleBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 32, 32)];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    [cancleBtn.titleLabel setFont:JP_FONTSIZE(15)];
    [cancleBtn addTarget:self action:@selector(clickCancleBtn) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:cancleBtn];
    self.navigationItem.rightBarButtonItem = item;

    [self setTableView];
    

    //获取相册列表
    [[JPPhotoKitManager sharedPhotoKitManager] jp_GetPhotoGroupArrayWithBlock:^(NSArray *groupArray) {
        
        [self.groupDataArray addObjectsFromArray:groupArray];
        [groupTableView reloadData];
        // 遍历找出相机胶卷组 直接打开
        for (JPPhotoGroupModel *model in self.groupDataArray) {
            if ([model.groupName isEqualToString:@"相机胶卷"] || [model.groupName isEqualToString:@"Camera Roll"] ) {
                JPPhotoListController *photoListCtrl = [[JPPhotoListController alloc]init];
                photoListCtrl.groupModel = model;
                photoListCtrl.title = model.groupName;
                photoListCtrl.maxImageCount = self.maxImageCount;
                [self.navigationController pushViewController:photoListCtrl animated:NO];
            }
        }
    }];
}


- (void)clickCancleBtn{
    
    [[JPPhotoManager sharedPhotoManager] jp_CancelChoosePhoto];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (NSMutableArray *)groupDataArray{
    
    if (!_groupDataArray) {
        _groupDataArray = [NSMutableArray array];
    }
    return _groupDataArray;
}

- (void)setTableView{
    
    groupTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    groupTableView.delegate = self;
    groupTableView.dataSource = self;
    [groupTableView registerClass:[JPPhotoGroupCell class] forCellReuseIdentifier:GroupCellID];
    groupTableView.tableFooterView = [[UIView alloc]init];
    groupTableView.rowHeight = 80;
    [self.view addSubview:groupTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.groupDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JPPhotoGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:GroupCellID];
    cell.groupModel = [self.groupDataArray objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JPPhotoGroupModel *groupModel = [self.groupDataArray objectAtIndex:indexPath.row];
    JPPhotoListController *photoListCtrl = [[JPPhotoListController alloc]init];
    photoListCtrl.title = groupModel.groupName;
    photoListCtrl.groupModel = groupModel;
    photoListCtrl.maxImageCount = self.maxImageCount;
    [self.navigationController pushViewController:photoListCtrl animated:YES];
}


@end
