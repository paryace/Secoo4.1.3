//
//  AddAddressViewController.m
//  Secoo-iPhone
//
//  Created by Tan Lu on 9/28/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import "AddAddressViewController.h"
#import "AddressURLSession.h"
#import "MBProgressHUD+Add.h"

typedef enum : NSUInteger {
    PickerViewStateProvince,
    PikcerViewStateCity,
    PickerViewStateDistrict,
} PickerViewState;

@interface AddAddressViewController ()<UIPickerViewDataSource, UIPickerViewDelegate>
{
    PickerViewState _pickerViewState;
    NSInteger _count;
    BOOL _didAppear;
    BOOL _isTapped;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberField;
@property (weak, nonatomic) IBOutlet UILabel *provinceLabel;
@property (weak, nonatomic) IBOutlet UITextField *detailAddressField;
@property (weak, nonatomic) IBOutlet UIButton *addNewAddressButton;

@property (weak, nonatomic) UIPickerView *pickerView;
@property (weak, nonatomic) UIView *pickBackView;

@property (strong, nonatomic) NSArray *provinceArray;
@property (strong, nonatomic) NSDictionary *cityDictionary;
@property (strong, nonatomic) NSDictionary *districtDictionary;
@property (strong, nonatomic) NSString *selectedProvince;
@property (strong, nonatomic) NSString *selectedCity;
@property (strong, nonatomic) NSString *selectedDistrict;

- (IBAction)addNewAddress:(id)sender;
@end

@implementation AddAddressViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _isTapped = NO;
    _count = 0;
    UIBarButtonItem *negativeSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpace.width = -10;
    UIBarButtonItem *backBar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fanhui"] style:UIBarButtonItemStyleBordered target:self action:@selector(backToPreviousViewController:)];
    self.navigationItem.leftBarButtonItems = @[negativeSpace, backBar];
    
    self.provinceLabel.userInteractionEnabled = YES;
    self.provinceLabel.layer.borderWidth = 0.5;
    self.provinceLabel.layer.borderColor = [UIColor colorWithRed:185/255.0 green:186/255.0 blue:194/255.0 alpha:1].CGColor;
    self.provinceLabel.layer.cornerRadius = 3;
    self.addNewAddressButton.layer.cornerRadius = 3;
    
    if (self.opration == AddressOperationUpdate) {
        //TODO
        self.nameField.text = self.name;
        self.phoneNumberField.text = self.mobileNumber;
        self.detailAddressField.text = self.address;
        self.provinceLabel.text = self.province;
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.provinceLabel addGestureRecognizer:tap];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upDateAddressSuccessed) name:@"UpdateAddressSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidAppear:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidDisappear:)
                                                 name:UIKeyboardWillHideNotification
                                               object:self.view.window];
    [self getAllTheAddress];
    _didAppear = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"AddAddress"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"AddAddress"];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if (self.scrollView.contentSize.height < 100) {
        self.scrollView.contentSize = self.view.frame.size;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backToPreviousViewController:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)getAllTheAddress
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"txt"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSString *areaStr = [NSString stringWithUTF8String:[data bytes]];
    NSArray *array = [areaStr componentsSeparatedByString:@";"];
    
    NSData *pdata = [[array objectAtIndex:0] dataUsingEncoding:NSUTF8StringEncoding];
    if (pdata == nil) {
        if (_count == 3) {
            return;
        }
        _count ++;
        [self getAllTheAddress];
        return;
    }
    _provinceArray = [NSJSONSerialization JSONObjectWithData:pdata options:NSJSONReadingMutableContainers error:nil];
    _cityDictionary = [NSJSONSerialization JSONObjectWithData:[[array objectAtIndex:1] dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    _districtDictionary = [NSJSONSerialization JSONObjectWithData:[[array objectAtIndex:2] dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
}

#pragma mark --
#pragma mark -- callbacks --
- (void)handleTap:(UITapGestureRecognizer *)tap
{
    [self dismissKeyboard];
    [self setPikcerView];
}

- (void)cancelPickerView
{
    CGFloat y = self.view.frame.size.height;
    CGRect frame = self.pickBackView.frame;
    frame.origin.y = y;
    [UIView animateWithDuration:0.2 animations:^{
        self.pickBackView.frame = frame;
    } completion:^(BOOL finished) {
        [self.pickBackView removeFromSuperview];
    }];
}

- (void)doneWithPickerView
{
    NSInteger firstIndex = [self.pickerView selectedRowInComponent:0];
    NSInteger secondeIndex = [self.pickerView selectedRowInComponent:1];
    NSInteger thirdIndex = [self.pickerView selectedRowInComponent:2];
    [self cancelPickerView];
    
    self.selectedProvince = [self.provinceArray objectAtIndex:firstIndex];
    if (secondeIndex < [[self.cityDictionary objectForKey:self.selectedProvince]  count]) {
        self.selectedCity = [[self.cityDictionary objectForKey:self.selectedProvince] objectAtIndex:secondeIndex];
    }
    else{
        return;
    }
    if (thirdIndex < [[self.districtDictionary objectForKey:self.selectedCity] count]) {
         self.selectedDistrict = [[self.districtDictionary objectForKey:self.selectedCity] objectAtIndex:thirdIndex];
    }
    else{
        return;
    }
    self.provinceLabel.text = [NSString stringWithFormat:@" %@/%@/%@", self.selectedProvince, self.selectedCity, self.selectedDistrict];
    self.provinceLabel.textColor = [UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1];
}

- (void)setPikcerView
{
    if (self.pickerView == nil) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 144)];
        [self.view addSubview:view];
        self.pickBackView = view;
        view.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
        UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, 100)];
        pickerView.delegate = self;
        pickerView.dataSource = self;
        pickerView.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
        [view addSubview:pickerView];
        self.pickerView = pickerView;
        
        UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        cancel.frame = CGRectMake(0, 0, 80, 44);
        cancel.backgroundColor = [UIColor clearColor];
        [cancel setTitleColor:MAIN_YELLOW_COLOR forState:UIControlStateNormal];
        [cancel addTarget:self action:@selector(cancelPickerView) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:cancel];
        [cancel setTitle:@"取消" forState:UIControlStateNormal];
        
        UIButton *done = [UIButton buttonWithType:UIButtonTypeCustom];
        done.frame = CGRectMake(view.frame.size.width - 80, 0, 80, 44);
        done.backgroundColor = [UIColor clearColor];
        [done setTitleColor:MAIN_YELLOW_COLOR forState:UIControlStateNormal];
        [done addTarget:self action:@selector(doneWithPickerView) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:done];
        [done setTitle:@"确定" forState:UIControlStateNormal];
        
        CGRect frame = CGRectMake(0, self.view.frame.size.height - 100 - 106, self.view.frame.size.width, 144);
        [UIView animateWithDuration:0.2 animations:^{
            view.frame = frame;
        } completion:^(BOOL finished) {
            
        }];
    }
}

#pragma mark --
#pragma mark -- pickerview delegate and data source --
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 44;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return self.view.frame.size.width / 3.0 - 5;
}

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view
{
    //NSLog(@"get view");
    UILabel *label;
    if ([view isKindOfClass:[UILabel class]]) {
        label = (UILabel *)view;
    }
    else{
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame) / 3.0 - 5, 44)];
    }
    label.font = [UIFont systemFontOfSize:20];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.adjustsFontSizeToFitWidth = YES;
    
    NSString *title = @"";
    if (component == 0) {
        title = self.provinceArray[row];
    }
    else if (component == 1){
        NSString *str = [self.provinceArray objectAtIndex:[self.pickerView selectedRowInComponent:0]];
        if (row < [[self.cityDictionary objectForKey:str] count] ) {
            title = [[self.cityDictionary objectForKey:str] objectAtIndex:row];
        }
        else{
            title = @"";
        }
    }
    else{
        NSString *str = [self.provinceArray objectAtIndex:[self.pickerView selectedRowInComponent:0]];
        NSArray *array = [self.cityDictionary objectForKey:str];
        if ([self.pickerView selectedRowInComponent:1] < [array count]) {
            NSString *city = [array objectAtIndex:[self.pickerView selectedRowInComponent:1]];
            if (row < [[self.districtDictionary objectForKey:city] count] ) {
                title = [[self.districtDictionary objectForKey:city] objectAtIndex:row];
            }
            else{
                title = @"";
            }
        }
        else{
            title = @"";
        }
    }
    label.text = title;
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];
    }
    else if (component == 1){
        [pickerView reloadComponent:2];
    }
}

//data source
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return [self.provinceArray count];
    }
    else if (component == 1){
        
        NSString *str = [self.provinceArray objectAtIndex:[self.pickerView selectedRowInComponent:0]];
        return [[self.cityDictionary objectForKey:str] count];
    }
    else{
        NSString *str = [self.provinceArray objectAtIndex:[self.pickerView selectedRowInComponent:0]];
        NSArray *array = [self.cityDictionary objectForKey:str];
        NSInteger index = [self.pickerView selectedRowInComponent:1];
        if ([array count] > index) {
            NSString *city = [array objectAtIndex:index];
            return [[self.districtDictionary objectForKey:city] count];
        }
        else{
            return 1;
        }
    }
    return 0;
}


#pragma mark --
#pragma mark -- callbacks--

- (void)keyboardDidAppear:(NSNotification *)notification
{
    if (!_didAppear) {
        CGRect rect = [[notification.userInfo objectForKey:@"UIKeyboardBoundsUserInfoKey"] CGRectValue];
        CGSize contentSize = self.scrollView.contentSize;
        self.scrollView.contentSize = CGSizeMake(contentSize.width, contentSize.height + rect.size.height / 4);
        _didAppear = YES;
    }
    [self cancelPickerView];
}

- (void)keyboardDidDisappear:(NSNotification *)notification
{
    if (_didAppear) {
        _didAppear = NO;
        CGRect rect = [[notification.userInfo objectForKey:@"UIKeyboardBoundsUserInfoKey"] CGRectValue];
        CGSize contentSize = self.scrollView.contentSize;
        self.scrollView.contentSize = CGSizeMake(contentSize.width, contentSize.height - rect.size.height / 4);
    }
}

- (void)dismissKeyboard
{
    [self.nameField resignFirstResponder];
    [self.phoneNumberField resignFirstResponder];
    [self.detailAddressField resignFirstResponder];
}

- (void)upDateAddressSuccessed
{
    [MBProgressHUD showSuccess:@"更新地址成功" toView:self.view];
    [self performSelector:@selector(goBack) withObject:nil afterDelay:1.0];
}

#pragma mark --
#pragma mark -- UITextFieldDelegate --

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)addNewAddress:(id)sender
{
    if (_isTapped) {
        return;
    }
    NSLog(@"%s", __FUNCTION__);
    
    _isTapped = YES;
    AddressURLSession *addressSession = [[AddressURLSession alloc] init];
    __weak typeof(AddAddressViewController*) weakSelf = self;
    if (self.opration == AddressOperationAdd) {
        //
        [addressSession addAddress:self.phoneNumberField.text name:self.nameField.text districtName:self.provinceLabel.text detailAddress:self.detailAddressField.text completion:^(NSInteger recode, NSString *message) {
            
            _isTapped = NO;
            
            typeof(AddAddressViewController*)strongSelf = weakSelf;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (recode == 0) {
                    [MBProgressHUD showSuccess:message toView:strongSelf.view];
                    [strongSelf performSelector:@selector(goBack) withObject:nil afterDelay:1.0];
                }
                else if (recode == 500){
                    [MBProgressHUD showError:@"亲，地址不能超过十个哦。" toView:strongSelf.view];
                }
                else{
                    [MBProgressHUD showError:message toView:strongSelf.view];
                }
            });
        }];
    }
    else if (self.opration == AddressOperationUpdate){
        [addressSession upDateAddressForId:self.addressId name:self.nameField.text province:self.provinceLabel.text address:self.detailAddressField.text mobile:self.phoneNumberField.text];
        }
}

- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
