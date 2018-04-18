//
//  VictoriaAddressPickerView.m
//  Address
//
//  Created by 阳丞枫 on 2018/4/16.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//
// 背景frame
// 内容frame
// 内容头部
// 内容显示条
// 内容列表
// tag：btn tableview

#import "VictoriaAddressPickerView.h"
#import "VictoriaAddressModel.h"

@interface VictoriaAddressPickerView () <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *addressContentView;
@property (nonatomic, strong) UIScrollView *addressListScrollView;
@property (nonatomic, assign) CGFloat stateBtnHeight;
@property (nonatomic, assign) CGFloat cityBtnHeight;
@property (nonatomic, assign) CGFloat areaBtnHeight;

@end

@implementation VictoriaAddressPickerView

#pragma mark - 懒加载

- (UIView *)maskView {
    if(!_maskView) {
        UIView *maskView = [[UIView alloc] initWithFrame:self.bounds];
        maskView.backgroundColor = [UIColor blackColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHiddenGestureRecognizer)];
        [maskView addGestureRecognizer:tap];
        _maskView = maskView;
        [self addSubview:_maskView];
    }
    return _maskView;
}

- (UIView *)addressContentView {
    if(!_addressContentView) {
        UIView *addressContentView = [[UIView alloc]initWithFrame:CGRectMakes(0, 667, 375, 380)];
        addressContentView.backgroundColor = [UIColor whiteColor];
        _addressContentView = addressContentView;
        [self addSubview:_addressContentView];
    }
    return _addressContentView;
}

- (UIScrollView *)addressListScrollView {
    if(!_addressListScrollView) {
        UIScrollView *addressListScrollView = [[UIScrollView alloc]initWithFrame:CGRectMakes(0, 80, 375, 300)];
        addressListScrollView.contentSize = CGSizeMake(375 * kScreenWidthMultiple * 1, 300 * kScreenWidthMultiple);
        addressListScrollView.pagingEnabled = YES;
        addressListScrollView.showsVerticalScrollIndicator = NO;
        addressListScrollView.showsHorizontalScrollIndicator = NO;
        _addressListScrollView = addressListScrollView;
        [_addressContentView addSubview:_addressListScrollView];
    }
    return _addressListScrollView;
}

#pragma mark - set方法

- (void)setStateArray:(NSMutableArray *)stateArray {
    _stateArray = stateArray;
    UITableView *tableView = [_addressListScrollView viewWithTag:200];
    [tableView reloadData];
}

- (void)setCityArray:(NSMutableArray *)cityArray {
    _cityArray = cityArray;
    UITableView *tableView = [_addressListScrollView viewWithTag:201];
    [tableView reloadData];
    _addressListScrollView.contentSize = CGSizeMake(375 * kScreenWidthMultiple * 2, 300 * kScreenWidthMultiple);
    [UIView animateWithDuration:0.5 animations:^{
        _addressListScrollView.contentOffset = CGPointMake(375 * kScreenWidthMultiple, 0);
    }];
}

- (void)setRegionsArray:(NSMutableArray *)regionsArray {
    _regionsArray = regionsArray;
    UITableView *tableView = [_addressListScrollView viewWithTag:202];
    [tableView reloadData];
    _addressListScrollView.contentSize = CGSizeMake(375 * kScreenWidthMultiple * 3, 300 * kScreenWidthMultiple);
    [UIView animateWithDuration:0.5 animations:^{
        _addressListScrollView.contentOffset = CGPointMake(375 * 2 * kScreenWidthMultiple, 0);
    }];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _stateArray = [NSMutableArray array];
        _cityArray = [NSMutableArray array];
        _regionsArray = [NSMutableArray array];
        self.autoresizesSubviews = NO;
        [self creatAddressPickerView];
    }
    return self;
}

- (void)creatAddressPickerView {
    self.maskView.alpha = 0;
    self.addressContentView.userInteractionEnabled = YES;
    self.addressListScrollView.delegate = self;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMakes(0, 0, 375-50, 50)];
    titleLabel.text = @"配送至";
    titleLabel.textColor = kColorRGBA(0, 0, 34, 1);
    titleLabel.font = kPandoraSecret_HTFont(34);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [_addressContentView addSubview:titleLabel];
    
    UIButton *removeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    removeBtn.frame = CGRectMakes(375-50, 0, 50, 50);
    [removeBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"delete" ofType:@"png"]] forState:UIControlStateNormal];
    [removeBtn addTarget:self action:@selector(hiddenVictoriaAddressPickerView) forControlEvents:UIControlEventTouchUpInside];
    [_addressContentView addSubview:removeBtn];
    
    for (int i=0; i < 3; i++) {
        UIButton *areaBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        areaBtn.frame = CGRectMakes(100 * i, 50, 100, 30);
        [areaBtn setTitleColor:kColorRGBA(34, 34, 34, 1) forState:UIControlStateNormal];
        areaBtn.tag = 100 + i;
        [areaBtn setTitle:@"" forState:UIControlStateNormal];
        [areaBtn addTarget:self action:@selector(areaBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        areaBtn.userInteractionEnabled = NO;
        [_addressContentView addSubview:areaBtn];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMakes(100 * i + 10, 78, 60, 2)];
        lineView.backgroundColor = kColorRGBA(204, 54, 60, 1);
        [_addressContentView addSubview:lineView];
        lineView.tag = 300 + i;
        lineView.hidden = YES;
        if (i == 0) {
            areaBtn.userInteractionEnabled = YES;
            [areaBtn setTitle:@"请选择" forState:UIControlStateNormal];
            [areaBtn setTitleColor:kColorRGBA(204, 54, 60, 1) forState:UIControlStateNormal];
            lineView.hidden = NO;
        }
    }

    for (int i=0; i<3; i++) {
        UITableView *addressTableView = [[UITableView alloc] initWithFrame:CGRectMakes(375 * i, 0, 375, 300) style:UITableViewStylePlain];
        addressTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        addressTableView.delegate = self;
        addressTableView.dataSource = self;
        addressTableView.tag = 200 + i;
        [_addressListScrollView addSubview:addressTableView];
    }
}

- (void)areaBtnAction:(UIButton *)btn {
    for (UIView *view in _addressContentView.subviews) {
        if (view.tag >= 300) {
            view.hidden = YES;
        }
    }
    UIView *lineView = [_addressContentView viewWithTag:300 + btn.tag - 100];
    lineView.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
        _addressListScrollView.contentOffset = CGPointMake(375 * kScreenWidthMultiple * (btn.tag - 100), 0);
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (tableView.tag - 200) {
        case 0:
            return _stateArray.count;
            break;
        case 1:
            return _cityArray.count;
            break;
        case 2:
            return _regionsArray.count;
            break;
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44 * kScreenWidthMultiple;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"area_cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"area_cell"];
    }
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = kColorRGBA(255, 238, 238, 1);
    cell.textLabel.highlightedTextColor = kColorRGBA(204, 54, 60, 1);
    cell.textLabel.font = kPandoraSecret_HTFont(28);
    cell.textLabel.textColor = kColorRGBA(102, 102, 102, 1);
    VictoriaAddressModel *addressAreaModel;
    switch (tableView.tag - 200) {
        case 0:
            addressAreaModel = _stateArray[indexPath.row];
            break;
        case 1:
            addressAreaModel = _cityArray[indexPath.row];
            break;
        case 2:
            addressAreaModel = _regionsArray[indexPath.row];
            break;
        default:
            break;
    }
    cell.textLabel.text = addressAreaModel.victoria_name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIButton *stateBtn = [_addressContentView viewWithTag:100];
    UIButton *cityBtn = [_addressContentView viewWithTag:101];
    UIButton *areaBtn = [_addressContentView viewWithTag:102];
    
    for (UIView *view in _addressContentView.subviews) {
        if (view.tag >= 300) {
            view.hidden = YES;
        }
    }
    
    UIView *lineView1 = [_addressContentView viewWithTag:300];
    UIView *lineView2 = [_addressContentView viewWithTag:301];
    UIView *lineView3 = [_addressContentView viewWithTag:302];
    VictoriaAddressTableViewType tableViewType = (VictoriaAddressTableViewType)(tableView.tag - 200);
    switch (tableViewType) {
        case VictoriaAddressTableViewTypeState: {
            VictoriaAddressModel *addressAreaModel = _stateArray[indexPath.row];
            _stateBtnHeight = [VictoriaAddressPickerView getLabelWidth:addressAreaModel.victoria_name font:30 height:30] + 20;
            [stateBtn setTitle:addressAreaModel.victoria_name forState:UIControlStateNormal];
            [stateBtn setTitleColor:kColorRGBA(34, 34, 34, 1) forState:UIControlStateNormal];
            stateBtn.frame = CGRectMakes(0, 50, _stateBtnHeight, 30);
            cityBtn.frame = CGRectMakes(_stateBtnHeight, 50, 80, 30);
            stateBtn.userInteractionEnabled = YES;
            cityBtn.userInteractionEnabled = YES;
            areaBtn.userInteractionEnabled = NO;
            [cityBtn setTitle:@"请选择" forState:UIControlStateNormal];
            [cityBtn setTitleColor:kColorRGBA(204, 54, 60, 1) forState:UIControlStateNormal];
            [areaBtn setTitle:@"" forState:UIControlStateNormal];
            
            lineView2.hidden = NO;
            lineView1.frame = CGRectMakes(10, 78, _stateBtnHeight - 20, 2);
            lineView2.frame = CGRectMakes(_stateBtnHeight + 10, 78, 80 - 20, 2);
            if ([self.delegate respondsToSelector:@selector(selectedLevelIndex:withSelectedAddressParentId:andSelectedAddressId:)]) {
                [self.delegate selectedLevelIndex:tableViewType withSelectedAddressParentId:addressAreaModel.victoria_parentid andSelectedAddressId:addressAreaModel.victoria_id];
            }
            break;
        }
        case VictoriaAddressTableViewTypeCity: {
            VictoriaAddressModel *addressAreaModel = _cityArray[indexPath.row];
            _cityBtnHeight = [VictoriaAddressPickerView getLabelWidth:addressAreaModel.victoria_name font:30 height:30] + 20;
            [cityBtn setTitle:addressAreaModel.victoria_name forState:UIControlStateNormal];
            [cityBtn setTitleColor:kColorRGBA(34, 34, 34, 1) forState:UIControlStateNormal];
            [areaBtn setTitle:@"请选择" forState:UIControlStateNormal];
            [areaBtn setTitleColor:kColorRGBA(204, 54, 60, 1) forState:UIControlStateNormal];
            lineView3.hidden = NO;
            lineView2.frame = CGRectMakes(_stateBtnHeight + 10, 78, _cityBtnHeight - 20, 2);
            lineView3.frame = CGRectMakes(_stateBtnHeight + _cityBtnHeight + 10, 78, 80 - 20, 2);
            areaBtn.userInteractionEnabled = YES;
            cityBtn.frame = CGRectMakes(_stateBtnHeight, 50, _cityBtnHeight, 30);
            areaBtn.frame = CGRectMakes(_stateBtnHeight + _cityBtnHeight, 50, 80, 30);
            
            if ([self.delegate respondsToSelector:@selector(selectedLevelIndex:withSelectedAddressParentId:andSelectedAddressId:)]) {
                [self.delegate selectedLevelIndex:tableViewType withSelectedAddressParentId:addressAreaModel.victoria_parentid andSelectedAddressId:addressAreaModel.victoria_id];
            }
            break;
        }
        case VictoriaAddressTableViewTypeArea: {
            VictoriaAddressModel *addressAreaModel = _regionsArray[indexPath.row];
            _areaBtnHeight = [VictoriaAddressPickerView getLabelWidth:addressAreaModel.victoria_name font:30 height:30] + 20;
            [areaBtn setTitle:addressAreaModel.victoria_name forState:UIControlStateNormal];
            [areaBtn setTitleColor:kColorRGBA(34, 34, 34, 1) forState:UIControlStateNormal];
            lineView3.hidden = NO;
            if (_stateBtnHeight + _cityBtnHeight + _areaBtnHeight > 375) {
                _areaBtnHeight = 375 - (_stateBtnHeight + _cityBtnHeight);
            }
            lineView3.frame = CGRectMakes(_stateBtnHeight + _cityBtnHeight + 10, 78, _areaBtnHeight - 20, 2);
            areaBtn.frame = CGRectMakes(_stateBtnHeight + _cityBtnHeight, 50, _areaBtnHeight, 30);
            [self hiddenVictoriaAddressPickerView];
            break;
        }
        default:
            break;
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    for (UIView *view in _addressContentView.subviews) {
        if (view.tag >= 300) {
            view.hidden = YES;
        }
    }
    if (scrollView == _addressListScrollView) {
        UIView *lineView = [_addressContentView viewWithTag:300 + scrollView.contentOffset.x / (375 * kScreenWidthMultiple)];
        lineView.hidden = NO;
    }
}
#pragma mark - areaViewShowOrHidden
- (void)showVictoriaAddressPickerView {
    self.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        _maskView.alpha = 0.6;
        _addressContentView.frame = CGRectMakes(0, 667 - 380, 375, 380);
    }];
}

- (void)tapHiddenGestureRecognizer {
    [self hiddenVictoriaAddressPickerView];
}

- (void)hiddenVictoriaAddressPickerView {
    UIButton *stateBtn = [_addressContentView viewWithTag:100];
    UIButton *cityBtn = [_addressContentView viewWithTag:101];
    UIButton *areaBtn = [_addressContentView viewWithTag:102];
    
    [UIView animateWithDuration:0.25 animations:^{
        _maskView.alpha = 0;
        _addressContentView.frame = CGRectMakes(0, 667, 375, 380);
    }completion:^(BOOL finished) {
        self.hidden = YES;
        if ([self.delegate respondsToSelector:@selector(setSelectedState:city:andArea:)]) {
            [self.delegate setSelectedState:stateBtn.titleLabel.text?:@"" city:cityBtn.titleLabel.text?:@"" andArea:areaBtn.titleLabel.text?:@""];
        }
    }];
}

+ (CGFloat)getLabelWidth:(NSString *)textStr font:(CGFloat)fontSize height:(CGFloat)labelHeight {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 5 * kScreenWidthMultiple; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    NSDictionary *attribute = @{NSFontAttributeName: kPandoraSecret_HTFont(fontSize),NSParagraphStyleAttributeName:paraStyle};
    CGSize size = [textStr boundingRectWithSize:CGSizeMake(1000, labelHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
    return size.width;
}

@end
