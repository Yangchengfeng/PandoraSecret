//
//  PSMyShowViewController.m
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/2.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import "PSMyShowViewController.h"

static NSString *myShowPostUrl = @"topic/public";

@interface PSMyShowViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *comment;
@property (weak, nonatomic) IBOutlet UIButton *choosePhoto;
@property (weak, nonatomic) IBOutlet UITextField *goodsTitle;
@property (weak, nonatomic) IBOutlet UIButton *isAnonymous;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) UIImage *pickerImage;

@end

@implementation PSMyShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    _imagePickerController.allowsEditing = YES;
    
    [_isAnonymous setImage:[UIImage imageNamed:@"choose_none_line"] forState:UIControlStateNormal];
    [_isAnonymous setImage:[UIImage imageNamed:@"choose"] forState:UIControlStateSelected];
}

- (IBAction)searchPhoto:(id)sender {
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:_imagePickerController animated:YES completion:nil];
}

- (IBAction)anonymousClick:(UIButton *)sender {
    if(sender.isSelected) {
        [sender setSelected:NO];
    } else {
        [sender setSelected:YES];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    NSLog(@"选择完毕----image:%@-----info:%@", image, editingInfo);
    _pickerImage = image;
    [_imagePickerController dismissViewControllerAnimated:YES completion:^{
        [_choosePhoto setImage:image forState:UIControlStateNormal];
    }];
}

- (IBAction)uploadShow:(id)sender {
    [PSNetoperation postPicUploadWithImage:_pickerImage success:^(id responseObject) {
        NSDictionary *dict = @{@"userId":@([PSUserManager shareManager].uid),
                               @"topicImage":responseObject[@"data"][@"url"],
                               @"width":responseObject[@"data"][@"width"],
                               @"height":responseObject[@"data"][@"height"],
                               @"content":_comment.text,
                               @"isAnonymous":@(_isAnonymous.isSelected),
                               };
        [PSNetoperation postRequestWithConcretePartOfURL:myShowPostUrl parameter:dict success:^(id responseObject) {
            [SVProgressHUD showSuccessWithStatus:@"图片上传成功"];
            // 页面跳转
        } failure:^(id failure) {
            [SVProgressHUD showErrorWithStatus:@"图片上传失败"];
        } andError:^(NSError *error) {
            
        }];
    } failure:^(id failure) {
        [SVProgressHUD showErrorWithStatus:@"图片上传失败"];
    } andError:^(NSError *error) {
        
    }];
}

@end
