//
//  CouponsVC.m
//  LoyalAZ
//

#import "CouponsVC.h"
#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f


@interface CouponsVC ()

@end

@implementation CouponsVC
@synthesize collation;
@synthesize sectionsArray;


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
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        self.edgesForExtendedLayout=UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars=NO;
        self.automaticallyAdjustsScrollViewInsets=NO;
        
    }

    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.title = @"My Coupons";
    self.trackedViewName = @"My Coupons";
    
//    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
//                                               initWithBarButtonSystemItem:UIBarButtonSystemItemCamera
//                                               target:self action:@selector(UpdateCouponQRImage)] autorelease];
    [self SetupArrays];
    [tableViewCoupons reloadData];
    [self HideActivityView];
}

-(void) SetupArrays
{
    appObject = [Application applicationManager];
    
    //NSLog(@"Total programs = %d",appObject.loyalaz.programs.count);
    listOfItems = [[NSMutableArray alloc]init];
    
    Coupon *tempCoupon = nil;
    for(int i=0;i<appObject.loyalaz.coupons.count;i++)
    {
        tempCoupon = [appObject.loyalaz.coupons objectAtIndex:i];
        [listOfItems addObject:tempCoupon];
    }
    
    
	self.collation = [UILocalizedIndexedCollation currentCollation];
	
	NSInteger index, sectionTitlesCount = [[collation sectionTitles] count];
	
	NSMutableArray *newSectionsArray = [[NSMutableArray alloc] initWithCapacity:sectionTitlesCount];
	
	// Set up the sections array: elements are mutable arrays that will contain the time zones for that section.
	for (index = 0; index < sectionTitlesCount; index++) {
		NSMutableArray *array = [[NSMutableArray alloc] init];
		[newSectionsArray addObject:array];
		[array release];
	}
    
	for (Coupon *cpn in appObject.loyalaz.coupons) {
		
		// Ask the collation which section number the time zone belongs in, based on its locale name.
		NSInteger sectionNumber = [collation sectionForObject:cpn collationStringSelector:@selector(name)];
        
		
		// Get the array for the section.
		NSMutableArray *sectionCoupons = [newSectionsArray objectAtIndex:sectionNumber];
		
		//  Add the time zone to the section.
		[sectionCoupons addObject:cpn];
	}
    
    
	// Now that all the data's in place, each section array needs to be sorted.
	for (index = 0; index < sectionTitlesCount; index++) {
		
		NSMutableArray *couponsArrayForSection = [newSectionsArray objectAtIndex:index];
		
		// If the table view or its contents were editable, you would make a mutable copy here.
		NSArray *sortedCouponsArrayForSection = [collation sortedArrayFromArray:couponsArrayForSection collationStringSelector:@selector(name)];
		
		// Replace the existing array with the sorted array.
		[newSectionsArray replaceObjectAtIndex:index withObject:sortedCouponsArrayForSection];
	}
	
	self.sectionsArray = newSectionsArray;
	[newSectionsArray release];
    
    
    copyListOfItems = [[NSMutableArray alloc] init];
    searching = NO;
    letUserSelectRow = YES;
}

- (void) searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar {
    
    searching = YES;
    letUserSelectRow = NO;
    tableViewCoupons.scrollEnabled = NO;
    
    //Add the done button.
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
                                               initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                               target:self action:@selector(doneSearching_Clicked:)] autorelease];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText {
    
    //Remove all objects first.
    [copyListOfItems removeAllObjects];
    
    if([searchText length] > 0) {
        
        searching = YES;
        letUserSelectRow = YES;
        tableViewCoupons.scrollEnabled = YES;
        [self searchTableView];
    }
    else {
        
        searching = NO;
        letUserSelectRow = NO;
        tableViewCoupons.scrollEnabled = NO;
    }
    
    [tableViewCoupons reloadData];
}


- (void) searchBarSearchButtonClicked:(UISearchBar *)theSearchBar {
    
    [self searchTableView];
}

- (void) searchTableView {
    
    NSString *searchText = searchBar.text;
    NSMutableArray *searchArray = [[NSMutableArray alloc] init];
    
    NSString *tempName;
    for (Coupon *tmpCoupon in listOfItems)
    {
        tempName = tmpCoupon.name;
        NSRange titleResultsRange = [tempName rangeOfString:searchText options:NSCaseInsensitiveSearch];
        
        if (titleResultsRange.length > 0)
            [copyListOfItems addObject:tmpCoupon];
    }
    
    [searchArray release];
    searchArray = nil;
}

- (void) doneSearching_Clicked:(id)sender {
    
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    letUserSelectRow = YES;
    searching = NO;
    self.navigationItem.rightBarButtonItem = nil;
    tableViewCoupons.scrollEnabled = YES;
    [tableViewCoupons reloadData];
    
}


#pragma mark - Table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	// The number of sections is the same as the number of titles in the collation.
    if (searching)
        return 1;
    else
        return [[collation sectionTitles] count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //NSLog(@"Rows in Sections");
    
	// The number of time zones in the section is the count of the array associated with the section in the sections array.
	NSArray *couponsInSection = [sectionsArray objectAtIndex:section];
    
    if (searching)
        return copyListOfItems.count;
    else
        return [couponsInSection count];
}


- (NSIndexPath *)tableView :(UITableView *)theTableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(letUserSelectRow)
        return indexPath;
    else
        return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    //return [[collation sectionTitles] objectAtIndex:section];
    return @"";
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [collation sectionIndexTitles];
}


- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [collation sectionForSectionIndexTitleAtIndex:index];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if(cell==nil)
//    {
//        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
//    }
    CouponCell *cell = (CouponCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil)
    {
        //        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        //        cell = [[[ProgramCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CouponCell" owner:nil options:nil];
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    NSArray *couponsInSection = [sectionsArray objectAtIndex:indexPath.section];
    Coupon *cpn;
    
    if(searching)
    {
        cpn = [copyListOfItems objectAtIndex:indexPath.row];
    }
    else
    {
        cpn = [couponsInSection objectAtIndex:indexPath.row];
    }
    NSString *detailText = [[NSString alloc]initWithFormat:@"%@\n%@, %@\nDistance:%@ km",[cpn.description stringByRemovingPercentEncoding],[cpn.com_street stringByRemovingPercentEncoding],[cpn.com_suburb stringByRemovingPercentEncoding], [cpn.distance stringByRemovingPercentEncoding]];
    
    cell.labelName.text = [cpn.name stringByRemovingPercentEncoding];
    cell.labelName.numberOfLines = 0;
    UIFont *fontTitle = [UIFont fontWithName:@"OpenSans-ExtraBold" size:14.0f];
    [cell.labelName setFont:fontTitle];
    
    
    CGRect nameRect = cell.textLabel.bounds;
    NSLog(@"Old Height=%f",nameRect.size.height);
    
    CGSize constraint = CGSizeMake(213, 20000.0f);
    CGSize size = [[cpn.name stringByRemovingPercentEncoding] sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat height = size.height;
    
    nameRect.size.height = height;
    
    [cell.labelName sizeToFit];
    
    
    nameRect = cell.labelName.frame;
    NSLog(@"New Height=%f",nameRect.size.height);
    NSLog(@"HDFHDHDHDFH");
    
    UIFont *fontDescription = [UIFont fontWithName:@"open-sans.light" size:12.0f];
    [cell.labelDescription setFont:[UIFont systemFontOfSize:14]];
    cell.labelDescription.text = detailText;
    cell.labelDescription.numberOfLines = 0;
    
    
    size = [detailText sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    
    CGRect newRect = nameRect;
    newRect.size.height = size.height;
    newRect.size.width = 213;
    newRect.origin.y = nameRect.origin.y+nameRect.size.height;
    cell.labelDescription.frame=newRect;
    cell.labelDescription.adjustsFontSizeToFitWidth=NO;
    [cell.labelDescription sizeToFit];
    

    
    [detailText release];
    cell.imageViewLogo.image = [UIImage imageWithContentsOfFile:[Helper GetStoragePath:cpn.pic_logo]];
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *couponsInSection = [sectionsArray objectAtIndex:indexPath.section];
    Coupon *cpn;
    
    if(searching)
    {
        cpn = [copyListOfItems objectAtIndex:indexPath.row];
    }
    else
    {
        cpn = [couponsInSection objectAtIndex:indexPath.row];
    }
    
    if([cpn.c isEqualToString:@""]==NO)
    {
        cell.backgroundColor = [Helper colorFromHexString:cpn.c];
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSArray *couponsInSection = [sectionsArray objectAtIndex:indexPath.section];
    Coupon *cpn;
    
    if(searching)
    {
        cpn = [copyListOfItems objectAtIndex:indexPath.row];
    }
    else
    {
        cpn = [couponsInSection objectAtIndex:indexPath.row];
    }
    
    

    NSString *detailText = [[NSString alloc]initWithFormat:@"%@\n%@, %@\nDistance:%@ km",[cpn.description stringByRemovingPercentEncoding],cpn.com_street,cpn.com_suburb, cpn.distance];
    CGSize constraint = CGSizeMake(213, 20000.0f);
    
    
    // get the height of program name label
    
    CGSize size = [[cpn.name stringByRemovingPercentEncoding] sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat height = size.height;
    
    // get the height of descrition label
    size = [detailText sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    
    // add the new height in previous height + 5 px gap.
    height += size.height+5;
    
    // get the height between calculated height and minimum height of 85
    height = MAX(height,85);
    
    UILabel *labelTemp = [[UILabel alloc]init];
    CGRect tempRect =  CGRectMake(0, 0, 213, 10);
    labelTemp.numberOfLines=0;
    UIFont *fontTitle = [UIFont fontWithName:@"OpenSans-ExtraBold" size:14.0f];
    [labelTemp setFont:fontTitle];
    [labelTemp setFrame:tempRect];
    labelTemp.text = [cpn.name stringByRemovingPercentEncoding];
    [labelTemp sizeToFit];
    
    height = labelTemp.frame.size.height;
    
    UIFont *fontDescription = [UIFont fontWithName:@"open-sans.light" size:12.0f];
    [labelTemp setFont:[UIFont systemFontOfSize:14]];
    [labelTemp setFrame:tempRect];
    labelTemp.text = detailText;
    [labelTemp sizeToFit];
    height +=labelTemp.frame.size.height+5;
    
    
    return height;//+ (CELL_CONTENT_MARGIN * 1) ;
}


- (void) tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Coupon *cpn;
    
    NSArray *couponsInSection = [sectionsArray objectAtIndex:indexPath.section];
    cpn = [couponsInSection objectAtIndex:indexPath.row];
    
    CouponDetailsVC *couponDetailsVC = [[CouponDetailsVC alloc]initWithNibNameAndMyCoupon:@"CouponDetailsVC" bundle:nil withCoupon:cpn];
    [self.navigationController pushViewController:couponDetailsVC animated:YES];
    [couponDetailsVC release];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Coupon *cpn;
    NSArray *couponsInSection = [sectionsArray objectAtIndex:indexPath.section];
    cpn = [couponsInSection objectAtIndex:indexPath.row];

    CouponDetailsVC *couponDetailsVC = [[CouponDetailsVC alloc]initWithNibNameAndMyCoupon:@"CouponDetailsVC" bundle:nil withCoupon:cpn];
    [self.navigationController pushViewController:couponDetailsVC animated:YES];
    [couponDetailsVC release];
    
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView beginUpdates];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Do whatever data deletion you need to do...
        // Delete the row from the data source
        NSArray *couponsInSection = [sectionsArray objectAtIndex:indexPath.section];
        
        MCoupon *coupon;// = [appObject.moreCoupons.MCoupons objectAtIndex:indexPath.row];
        coupon = [couponsInSection objectAtIndex:indexPath.row];
        
        if([Helper IsInternetAvailable])
        {
            BusinessLayer *businessObject = [[BusinessLayer alloc]init];
            [businessObject RemoveUserCoupon:appObject.loyalaz.user.uid CouponId:coupon.id];
        }
        
        [appObject.loyalaz.coupons removeObject:coupon];
        [self SetupArrays];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationTop];
    }
    [tableView endUpdates];
}


-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Delete";
}

@end
