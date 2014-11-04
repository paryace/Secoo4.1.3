//
//  AddressViewController.m
//  Secoo-iPhone
//
//  Created by Tan Lu on 9/15/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import "AddressViewController.h"
#import "AddressURLSession.h"
#import "AddressDataAccessor.h"
#import "AppDelegate.h"
#import "AddressEntity.h"
#import "LGTableViewCell.h"
#import "CheckButton.h"
#import "AddAddressViewController.h"


#define ADDRESS_CHECK_BUTTON        @"ADDRESS_CHECK_BUTTON"


@interface AddressViewController ()<LGTableViewCellDelegate, CheckButtonDelegate>
{
    int _selectIndex;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation AddressViewController

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
    self.navigationItem.title = @"收货地址";
    
    self.tableView.rowHeight = 80;
    [self.tableView registerClass:[LGTableViewCell class] forCellReuseIdentifier:@"AddressTableCell"];
    
    _selectIndex = -1;
    
    UIBarButtonItem *negativeSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpace.width = -10;
    UIBarButtonItem *backBar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fanhui"] style:UIBarButtonItemStyleBordered target:self action:@selector(backToPreviousViewController:)];
    self.navigationItem.leftBarButtonItems = @[negativeSpace, backBar];
    UIBarButtonItem *addBarButton = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStyleBordered target:self action:@selector(handleAddAddressInfoAction:)];
    self.navigationItem.rightBarButtonItem = addBarButton;
    
    AddressURLSession *addressSession = [[AddressURLSession alloc] init];
    [addressSession upDateAddress];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAddressUpdateNotification) name:AddressDataDidChangeNotification object:[AddressDataAccessor sharedInstance]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAddressSessionError:) name:@"UpdateAddressError" object:nil];
    
    //
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    backgroundView.backgroundColor = [UIColor colorWithRed:255/255.0 green:223/255.0 blue:224/255.0 alpha:1];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:backgroundView.bounds];
    headerLabel.backgroundColor = [UIColor colorWithRed:255/255.0 green:223/255.0 blue:224/255.0 alpha:1];
    headerLabel.textColor = [UIColor redColor];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.font = [UIFont systemFontOfSize:14];
    headerLabel.text = @"最多可设置5个地址";
    [headerLabel sizeToFit];
    headerLabel.center = CGPointMake(self.view.center.x, backgroundView.center.y);
    [backgroundView addSubview:headerLabel];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(headerLabel.frame.origin.x-25, 5, 20, 20)];
    imageView.image = _IMAGE_WITH_NAME(@"error");
    [backgroundView addSubview:imageView];
    
    self.tableView.tableHeaderView = backgroundView;
    
    
    [self setExtraCellLineHidden:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"Address"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"Address"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setExtraCellLineHidden:(UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (void)backToPreviousViewController:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    NSInteger num = [self.fetchedResultsController.sections count];
    return num;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    
    NSUInteger num = [sectionInfo numberOfObjects];
    if (num > 0) {
        self.backgroundView.alpha = 0;
    } else {
        self.backgroundView.alpha = 1;
    }
    return num;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LGTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddressTableCell" forIndexPath:indexPath];
    // Configure the cell...
    
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(LGTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    //cell.swipeDirection = SwipeDirectionBoth;
    //UIImage *image = [UIImage imageNamed:@"sns_icon_1.png"];
    //cell.lgImageView.image = image;
    cell.delegate = self;
    
    NSArray *addressArray = self.fetchedResultsController.fetchedObjects;
    AddressEntity *address = [addressArray objectAtIndex:indexPath.row];
    if (address.defaultAddress) {
        _selectIndex = indexPath.row;
    }
    [[cell.middleView viewWithTag:1000] removeFromSuperview];
    
    
    DeliverInfoView *deliverInfoView = [[DeliverInfoView alloc] initWithFrame:CGRectMake(10, 10, cell.middleView.frame.size.width-20, cell.middleView.frame.size.height) name:address.consigneeName phone:(address.mobileNum ? address.mobileNum : address.telephone) address:[NSString stringWithFormat:@"%@/%@", address.provinceCityDistrict, address.address] groupId:@"AddressViewController" info:address delegate:self];
    deliverInfoView.tag = 1000;
    deliverInfoView.checkButton.index = indexPath.row;
    [cell.middleView addSubview:deliverInfoView];
    
    if (address.defaultAddress) {
        deliverInfoView.checkButton.checked = YES;
    } else {
        deliverInfoView.checkButton.checked = NO;
    }
    
    /***************************************/
//    CheckButton *checkButton = [[CheckButton alloc] initWithDelegate:self groupId:nil];
//    checkButton.frame = CGRectMake(10, 10, 80, 20);
//    checkButton.tag = 1000;
//    checkButton.index = indexPath.row;
//    [checkButton setTitle:address.consigneeName forState:UIControlStateNormal];
//    [cell.middleView addSubview:checkButton];
//    
//    if (address.defaultAddress) {
//        checkButton.checked = YES;
//    }
//    else{
//        checkButton.checked = NO;
//    }
//    
//    cell.phoneLabel.text = address.mobileNum ? address.mobileNum : address.telephone;
//    cell.addressLabel.text = [NSString stringWithFormat:@"%@/%@", address.provinceCityDistrict, address.address];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self updateAddress:indexPath.row];
}

#pragma mark --
#pragma mark --LGTableCellDelegate--
- (void)pressCell:(LGTableViewCell *)cell atRightButtonAtIndex:(NSInteger)index
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSArray *array = self.fetchedResultsController.fetchedObjects;
    AddressEntity *addressEn = [array objectAtIndex:indexPath.row];
    [[[AddressURLSession alloc] init] deleteAddress:addressEn.addressId];
}

- (void)pressEditButtonAtCell:(LGTableViewCell *)cell
{//编辑按钮
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self updateAddress:indexPath.row];
}

#pragma mark --
#pragma mark -- callbacks --
- (void)handleAddressUpdateNotification
{
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"address fetch controller fetching error %@", error.description);
    }
    [self.tableView reloadData];
}

- (void)handleAddressSessionError:(NSNotification *)notification
{
    NSDictionary *dict = notification.userInfo;
    [MBProgressHUD showError:[dict objectForKey:@"errMsg"] toView:self.view];
}

#pragma mark - CheckButtonDelegate Method
- (void)didSelectedRadioButton:(CheckButton *)radio groupId:(NSString *)groupId
{
//    radio.checked = NO;
//    _selectIndex = radio.index;
//    NSArray *addressArray = self.fetchedResultsController.fetchedObjects;
//    AddressEntity *address = [addressArray objectAtIndex:_selectIndex];
//   [[[AddressURLSession alloc] init] setDefaultAddress:address.addressId];
}

- (void)didSelectOneAddressWithInfo:(id)info deliverInfoView:(DeliverInfoView *)deliverInfoView
{
    _selectIndex = deliverInfoView.checkButton.index;
    NSArray *addressArray = self.fetchedResultsController.fetchedObjects;
    AddressEntity *address = [addressArray objectAtIndex:_selectIndex];
    [[[AddressURLSession alloc] init] setDefaultAddress:address.addressId];
}

#pragma mark - 添加地址
- (void)handleAddAddressInfoAction:(UIBarButtonItem *)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddAddressViewController *addAddressVC = [storyboard instantiateViewControllerWithIdentifier:@"AddAddressViewController"];
    addAddressVC.opration = AddressOperationAdd;
    addAddressVC.title = @"添加地址";
    [self.navigationController pushViewController:addAddressVC animated:YES];
}

- (void)updateAddress:(NSInteger)index
{
    NSArray *array = self.fetchedResultsController.fetchedObjects;
    if (index < [array count]) {
        AddressEntity *addressEn = [array objectAtIndex:index];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AddAddressViewController *addAddressVC = [storyboard instantiateViewControllerWithIdentifier:@"AddAddressViewController"];
        addAddressVC.opration = AddressOperationUpdate;
        addAddressVC.addressId = addressEn.addressId;
        addAddressVC.name = addressEn.consigneeName;
        addAddressVC.mobileNumber = addressEn.mobileNum;
        addAddressVC.province = addressEn.provinceCityDistrict;
        addAddressVC.address = addressEn.address;
        addAddressVC.title = @"修改地址";
        [self.navigationController pushViewController:addAddressVC animated:YES];
    }
}

#pragma mark --
#pragma mark -- getter and setter --

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"AddressEntity"];
    [request setFetchBatchSize:20];
    NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
    [request setSortDescriptors:@[sorter]];
    
    NSFetchedResultsController *fetchController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    _fetchedResultsController = fetchController;
    
    NSError *error;
    if (![fetchController performFetch:&error]) {
        NSLog(@"fetch controller fetching error %@", error.description);
    }
    return _fetchedResultsController;
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext == nil) {
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        _managedObjectContext = delegate.managedObjectContext;
    }
    return _managedObjectContext;
}

@end
