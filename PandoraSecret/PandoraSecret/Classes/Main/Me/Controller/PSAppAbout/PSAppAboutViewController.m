//
//  PSAppAboutViewController.m
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/14.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import "PSAppAboutViewController.h"

@interface PSAppAboutViewController ()

@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation PSAppAboutViewController

- (instancetype)init {
    self = [super initWithStyle:UITableViewStyleGrouped];
    return self;
}

- (NSMutableArray *)dataArr {
    if(_dataArr == nil) {
        _dataArr = [NSMutableArray array];
        
        NSArray *arr = @[@"去评分", @"参与公测", @"客服电话"];
        
        [_dataArr addObjectsFromArray:arr];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.showsVerticalScrollIndicator = NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.textLabel.text = [NSString stringWithFormat:@"%@", _dataArr[indexPath.row]];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if([cell.textLabel.text isEqualToString:@"客服电话"]) {
            UILabel *phoneNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/5.0*3-30, 0, 140, 50)];
            phoneNumLabel.text = @"8618826139764";
            phoneNumLabel.font = [UIFont systemFontOfSize:15];
            phoneNumLabel.textColor = [UIColor lightGrayColor];
            phoneNumLabel.backgroundColor = [UIColor clearColor];
            [cell addSubview:phoneNumLabel];
        }
        
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 300;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    [imageView setImage:[UIImage imageNamed:@"logo"]];
    [view addSubview:imageView];
    UILabel *versionlabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/2.0-60, CGRectGetMaxY(imageView.frame), 120, 20)];
    versionlabel.font = [UIFont systemFontOfSize:14];
    versionlabel.textAlignment = NSTextAlignmentCenter;
    versionlabel.textColor = [UIColor lightGrayColor];
    NSString *versionText = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *buildVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    versionlabel.text = [NSString stringWithFormat:@"版本：%@ build %@", versionText, buildVersion];
    [view addSubview:versionlabel];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row == 2) {
        [self makeACall];
    } else {
        [SVProgressHUD showErrorWithStatus:@"该功能暂未开放"];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)makeACall{
    NSString *number = @"8618826139764";
    NSString *num = [[NSString alloc] initWithFormat:@"tel://%@",number];
    UIWebView * callWebview = [[UIWebView alloc]init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:num]]];
    [[UIApplication sharedApplication].keyWindow addSubview:callWebview];
}

@end
