//
//  PSMyShowViewController.m
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/2.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import "PSMyShowViewController.h"
#import "PSShowGradeStarView.h"
#import "PSTextViewWithPlaceholder.h"

static NSInteger selectedStar = 0;
static NSInteger totalStars = 5;
static NSString *myShowPostUrl = @"topic/public";
static NSString *placeholderStr = @"请输入有关商品或店铺的描述，不多于50字，也不要少于5个字，来畅所欲言，让更多朋友了解这样一件心水品吧！！！！！！！！O(∩_∩)O";

@interface PSMyShowViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, PSShowGradeStarViewDelegate, UITextViewDelegate, UITextFieldDelegate, PSTextViewWithPlaceholderDelegate>


@property (weak, nonatomic) IBOutlet PSTextViewWithPlaceholder *comment;
@property (weak, nonatomic) IBOutlet UIButton *choosePhoto;
@property (weak, nonatomic) IBOutlet UITextField *goodsTitle;
@property (weak, nonatomic) IBOutlet UIButton *isAnonymous;
@property (weak, nonatomic) IBOutlet PSShowGradeStarView *pickStarView;
@property (nonatomic, assign) NSInteger garde;
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
    
    [_pickStarView buildStarsWithSelectedStars:selectedStar totalStars:totalStars starSize:CGSizeMake(30, 30) optional:YES];
    _pickStarView.delegate = self;
    
    _comment.delegate = self;
    _comment.placeholderDelegate = self;
    _comment.font = [UIFont systemFontOfSize:12];
    _comment.placeholder = placeholderStr;
    _comment.placeholderColor = [UIColor lightGrayColor];
    
    
    _goodsTitle.delegate = self;
    _garde = totalStars+1;
    
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
    _pickerImage = image;
    [_imagePickerController dismissViewControllerAnimated:YES completion:^{
        [_choosePhoto setImage:image forState:UIControlStateNormal];
    }];
}

- (IBAction)uploadShow:(id)sender {
    
    if(_pickerImage==nil || !(_comment.text.length>0) || _garde<0 || _garde>totalStars) {
        [SVProgressHUD showErrorWithStatus:@"请检查是否已经或给予分数、图片或评论，方便大家更好地了解这个商品哦~"];
        return;
    }
    
    [PSNetoperation postPicUploadWithImage:_pickerImage success:^(id responseObject) {
        NSDictionary *dict = @{@"userId":@([PSUserManager shareManager].uid),
                               @"topicImage":responseObject[@"data"][@"url"],
                               @"width":responseObject[@"data"][@"width"],
                               @"height":responseObject[@"data"][@"height"],
                               @"content":_comment.text,
                               @"likeNum":@(_garde),
                               @"isAnonymous":@(_isAnonymous.isSelected),
                               @"shopName":_goodsTitle.text
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

- (void)touchView:(PSTextViewWithPlaceholder *)textView hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    textView.placeholder = @"";
}

- (void)finalGradeWithSelectedStarIdx:(NSInteger)starsIdx {
    _garde = starsIdx+1;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@""]) {
        self.comment.placeholder = placeholderStr;
    }
    if ([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

@end
