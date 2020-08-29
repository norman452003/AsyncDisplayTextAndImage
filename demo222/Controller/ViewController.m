//
//  ViewController.m
//  demo222
//
//  Created by suning on 16/3/9.
//  Copyright © 2016年 suning. All rights reserved.
//

#import "ViewController.h"
#import <CoreText/CoreText.h>
#import "WebViewController.h"
#import "TapImageView.h"
#import "DefineConstant.h"
#import "DemoCell.h"
#import "TextLayout.h"
#import "FPSLabel.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.allowsSelection = NO;
    
    FPSLabel *label = [[FPSLabel alloc] initWithFrame:CGRectMake(0, kScreenHeight - 100, 0, 0)];
    [label sizeToFit];
    [self.view addSubview:label];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSArray *contentArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
    
    NSMutableArray *mArray = @[].mutableCopy;
    for (int i = 0 ; i < 5; i++) {
        [mArray addObjectsFromArray:contentArray];
    }
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        for (NSDictionary *dict in mArray) {
            dispatch_group_enter(group);
            TextLayout *layout = [[TextLayout alloc] init];
            [layout paraseWithDict:dict restrictWidth:kScreenWidth - 40 complete:^{
                dispatch_group_leave(group);
            }];
            [self.dataArray addObject:layout];
        }
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *reuseID = @"reuser";
    DemoCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (cell == nil) {
        cell = [[DemoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    cell.layout = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    TextLayout *layout = self.dataArray[indexPath.row];
    return layout.height + 80 + layout.imageHeight + 10;
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    }
    return _tableView;
}



- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = @[].mutableCopy;
    }
    return _dataArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
