//
//  ViewController.m
//  GPUImageDemo
//
//  Created by NicoLin on 2017/11/30.
//  Copyright © 2017年 NicoLin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray * dataArray;
}

@property (nonatomic, strong) UITableView    *showTableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.showTableView];
    
    dataArray = [NSMutableArray arrayWithArray:@[
                                                 @"FilterDemoVC",
                                                 @"FilteringlivevideoVC",
                                                 @"Capturingfilteringstillphoto",
                                                 @"ProcessingstillimageVC",
                                                 @"WritingcustomfilterVC",
                                                 @"MutipleFilterVC",
                                                 ]];

    

}

- (UITableView*)showTableView {
    if (!_showTableView) {
        _showTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
        _showTableView.delegate = self;
        _showTableView.dataSource = self;
    }
    return _showTableView;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellid"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"cellid"];
    }
    cell.detailTextLabel.text = dataArray[indexPath.row];
    return cell;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Class idClass = NSClassFromString(dataArray[indexPath.row]);
    [self.navigationController pushViewController:[idClass new] animated:YES];
    
}



@end
