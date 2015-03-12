//
//  FindCouponsVC.m
//  LoyalAZ
//

#import "FindCouponsVC.h"
#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f



@interface FindCouponsVC () <UIScrollViewDelegate>
@property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;
@end

@implementation FindCouponsVC
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
    self.navigationController.navigationBarHidden = NO;
    self.title = @"Find Coupons";
    self.imageDownloadsInProgress = [NSMutableDictionary dictionary];    
    appObject = [Application applicationManager];
    
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [tableViewCoupons addSubview:refreshControl];
    
    
    if(appObject.cachedCoupons==YES)
    {
        return;
    }
    appObject.cachedCoupons = YES;

    
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyBest; // 100 m
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    [locationManager startUpdatingLocation];
    [self ShowActivityView];
}

//- (void) viewDidAppear:(BOOL)animated
//{
//    [self SetupArrays];
//    [tableViewCoupons reloadData];
//    [self HideActivityView];
//}


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


#pragma mark - Table view data source

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
    MCoupon *mcpn;
    
    if(searching)
    {
        mcpn = [copyListOfItems objectAtIndex:indexPath.row];
    }
    else
    {
        mcpn = [couponsInSection objectAtIndex:indexPath.row];
    }
    
    NSString *detailText = [[NSString alloc]initWithFormat:@"%@\n%@, %@\nDistance:%@ km",[mcpn.description stringByRemovingPercentEncoding],[mcpn.com_street stringByRemovingPercentEncoding],[mcpn.com_suburb stringByRemovingPercentEncoding], [mcpn.distance stringByRemovingPercentEncoding]];
    
//    mcpn.name = @"Hello world this is the longer string to test the auto word wrapping functionality in the cell. Please test and let me know if this is working fine now.";
    
    cell.labelName.text = [mcpn.name stringByRemovingPercentEncoding];
    cell.labelName.numberOfLines = 0;
    UIFont *fontTitle = [UIFont fontWithName:@"OpenSans-ExtraBold" size:14.0f];
    [cell.labelName setFont:fontTitle];
    
    
    CGRect nameRect = cell.labelName.bounds;
    
    CGSize constraint = CGSizeMake(213, 20000.0f);
    CGSize size = [[mcpn.name stringByRemovingPercentEncoding] sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat height = size.height;
    
    nameRect.size.height = height;
    
    [cell.labelName sizeToFit];
    
    
    nameRect = cell.labelName.frame;
    
//    UIFont *fontDescription = [UIFont fontWithName:@"open-sans.light" size:12.0f];
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
    
    

//    cell.textLabel.text = [mcpn.name stringByRemovingPercentEncoding];
//    cell.textLabel.adjustsFontSizeToFitWidth=YES;

////    detailText = [detailText stringByRemovingPercentEncoding];
//    cell.detailTextLabel.text=detailText;
//    cell.detailTextLabel.numberOfLines = 0;
    [detailText release];
    if (!mcpn.icon)
    {
        if (tableViewCoupons.dragging == NO && tableViewCoupons.decelerating == NO)
        {
            [self startIconDownload:mcpn forIndexPath:indexPath];
        }
        // if a download is deferred or in progress, return a placeholder image
        cell.imageViewLogo.image = [UIImage imageNamed:@"placeholder_logo.png"];
    }
    else
    {
        cell.imageViewLogo.image = mcpn.icon;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *couponsInSection = [sectionsArray objectAtIndex:indexPath.section];
    MCoupon *mcpn;
    
    if(searching)
    {
        mcpn = [copyListOfItems objectAtIndex:indexPath.row];
    }
    else
    {
        mcpn = [couponsInSection objectAtIndex:indexPath.row];
    }
    
    if([mcpn.c isEqualToString:@""]==NO)
    {
        cell.backgroundColor = [Helper colorFromHexString:mcpn.c];
    }
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSArray *couponsInSection = [sectionsArray objectAtIndex:indexPath.section];
    MCoupon *mcpn;
    
    if(searching)
    {
        mcpn = [copyListOfItems objectAtIndex:indexPath.row];
    }
    else
    {
        mcpn = [couponsInSection objectAtIndex:indexPath.row];
    }
    NSString *detailText = [[NSString alloc]initWithFormat:@"%@\n%@, %@\nDistance:%@ km",[mcpn.description stringByRemovingPercentEncoding],mcpn.com_street,mcpn.com_suburb, mcpn.distance];
    
//    CGSize constraint = CGSizeMake(213, 20000.0f);
    
    CGFloat height;
//    // get the height of program name label
//    
//    CGSize size = [[mcpn.name stringByRemovingPercentEncoding] sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
//    CGFloat height = size.height;
//    
//    // get the height of descrition label
//    size = [detailText sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
//    
//    // add the new height in previous height + 5 px gap.
//    height += size.height+5;
//    
//    // get the height between calculated height and minimum height of 85
//    height = MAX(height,85);
    
    UILabel *labelTemp = [[UILabel alloc]init];
    CGRect tempRect =  CGRectMake(0, 0, 213, 10);
    labelTemp.numberOfLines=0;
    UIFont *fontTitle = [UIFont fontWithName:@"OpenSans-ExtraBold" size:14.0f];
    [labelTemp setFont:fontTitle];
    [labelTemp setFrame:tempRect];
    labelTemp.text = [mcpn.name stringByRemovingPercentEncoding];
    [labelTemp sizeToFit];
    
    height = labelTemp.frame.size.height;
    
//    UIFont *fontDescription = [UIFont fontWithName:@"open-sans.light" size:12.0f];
    NSLog(@"Before===%f",labelTemp.frame.size.height);
    [labelTemp setFont:[UIFont systemFontOfSize:14]];
    labelTemp.text = detailText;
    [labelTemp setFrame:tempRect];
    [labelTemp sizeToFit];
    NSLog(@"After===%f",labelTemp.frame.size.height);
    height +=labelTemp.frame.size.height+5;
    
    
    return height;//+ (CELL_CONTENT_MARGIN * 1) ;}

}

// -------------------------------------------------------------------------------
//	startIconDownload:forIndexPath:
// -------------------------------------------------------------------------------
- (void)startIconDownload:(MCoupon *)mcpn forIndexPath:(NSIndexPath *)indexPath
{
    CouponIconDownloader *iconDownloader = [self.imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader == nil)
    {
        iconDownloader = [[CouponIconDownloader alloc] init];
        iconDownloader.cpnRecord = mcpn;
        [iconDownloader setCompletionHandler:^{
            
            UITableViewCell *cell = [tableViewCoupons cellForRowAtIndexPath:indexPath];
            
            // Display the newly loaded image
            cell.imageView.image = mcpn.icon;
            
            // Remove the IconDownloader from the in progress list.
            // This will result in it being deallocated.
            [self.imageDownloadsInProgress removeObjectForKey:indexPath];
            
        }];
        [self.imageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
        [iconDownloader startDownload];
    }
}

- (void)loadImagesForOnscreenRows
{
    if ([appObject.moreCoupons.MCoupons count] > 0)
    {
        NSArray *visiblePaths = [tableViewCoupons indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            MCoupon *mcpn;
            
            if(searching)
            {
                mcpn = [copyListOfItems objectAtIndex:indexPath.row];
            }
            else
            {
                mcpn = [appObject.moreCoupons.MCoupons objectAtIndex:indexPath.row];
            }
            
            
            if (!mcpn.icon)
                // Avoid the app icon download if the app already has an icon
            {
                [self startIconDownload:mcpn forIndexPath:indexPath];
            }
        }
    }
}

#pragma mark - UIScrollViewDelegate

// -------------------------------------------------------------------------------
//	scrollViewDidEndDragging:willDecelerate:
//  Load images for all onscreen rows when scrolling is finished.
// -------------------------------------------------------------------------------
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
	{
        [self loadImagesForOnscreenRows];
    }
}

// -------------------------------------------------------------------------------
//	scrollViewDidEndDecelerating:
// -------------------------------------------------------------------------------
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}



#pragma mark - Table view delegate

- (void) tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *couponsInSection = [sectionsArray objectAtIndex:indexPath.section];
    
    MCoupon *coupon;// = [appObject.moreCoupons.MCoupons objectAtIndex:indexPath.row];
    coupon = [couponsInSection objectAtIndex:indexPath.row];

    CouponDetailsVC *moreCouponDetailsVC = [[CouponDetailsVC alloc]initWithNibNameAndCoupon:@"CouponDetailsVC" bundle:nil withCoupon:coupon];
    [self.navigationController pushViewController:moreCouponDetailsVC animated:YES];
    [moreCouponDetailsVC release];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *couponsInSection = [sectionsArray objectAtIndex:indexPath.section];
    
    MCoupon *coupon;// = [appObject.moreCoupons.MCoupons objectAtIndex:indexPath.row];
    coupon = [couponsInSection objectAtIndex:indexPath.row];
    
    CouponDetailsVC *moreCouponDetailsVC = [[CouponDetailsVC alloc]initWithNibNameAndCoupon:@"CouponDetailsVC" bundle:nil withCoupon:coupon];
    [self.navigationController pushViewController:moreCouponDetailsVC animated:YES];
    [moreCouponDetailsVC release];
}

// Override to support conditional editing of the table view.
- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return(YES);
}

//tableView:commitEditingStyle:forRowAtIndexPath:
//tableView:canEditRowAtIndexPath:
//tableView:editingStyleForRowAtIndexPath:

- (void)BusinessLayerDidFinish:(BOOL)result
{
    [self HideActivityView];
    if(result==YES)
    {
        //NSLog(@"Find programs returned.");
        listOfItems = [[NSMutableArray alloc]init];
        annArray = [[NSMutableArray alloc]init];
        MCoupon *tempCoupn = nil;
        MCoupon *pushCoupon = nil;
        for(int i=0;i<appObject.moreCoupons.MCoupons.count;i++)
        {
            tempCoupn = [appObject.moreCoupons.MCoupons objectAtIndex:i];
            [listOfItems addObject:tempCoupn];
            
            if(appObject.fromNotification==YES)
            {
                
                if([tempCoupn.id isEqualToString:appObject.cpnId]) {
                    pushCoupon = tempCoupn;
                }
            }

        }
        [self SetupMapAnnotations];
        
        copyListOfItems = [[NSMutableArray alloc] init];
        searching = NO;
        letUserSelectRow = YES;
        [self SetupArrays];
        [tableViewCoupons reloadData];
        // Fetched results are found in appObject.morePrograms.
        
        if(pushCoupon!=nil) {
            CouponDetailsVC *moreCouponDetailsVC = [[CouponDetailsVC alloc]initWithNibNameAndCoupon:@"CouponDetailsVC" bundle:nil withCoupon:pushCoupon];
            [self.navigationController pushViewController:moreCouponDetailsVC animated:YES];
            [moreCouponDetailsVC release];
        }
        
    }
}


- (void)BusinessLayerErrorOccurred:(NSError *)err
{
    [self HideActivityView];
    //NSLog(@"FindPrograms: Error occurred, can't move further.");
}

-(void) SetupArrays
{
    appObject = [Application applicationManager];
    
    //NSLog(@"Total programs = %d",appObject.loyalaz.programs.count);
    listOfItems = [[NSMutableArray alloc]init];
    
    MCoupon *tempCoupon = nil;
    for(int i=0;i<appObject.moreCoupons.MCoupons.count;i++)
    {
        tempCoupon = [appObject.moreCoupons.MCoupons objectAtIndex:i];
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
    
	for (MCoupon *cpn in appObject.moreCoupons.MCoupons) {
		
		// Ask the collation which section number the time zone belongs in, based on its locale name.
		NSInteger sectionNumber = [collation sectionForObject:cpn collationStringSelector:@selector(name)];
        
		
		// Get the array for the section.
		NSMutableArray *sectionCoupons = [newSectionsArray objectAtIndex:sectionNumber];
		
		//  Add the time zone to the section.
		[sectionCoupons addObject:cpn];
	}
    
    
	// Now that all the data's in place, each section array needs to be sorted.
	for (index = 0; index < sectionTitlesCount; index++) {
		
		NSMutableArray *programsArrayForSection = [newSectionsArray objectAtIndex:index];
		
		// If the table view or its contents were editable, you would make a mutable copy here.
		NSArray *sortedProgramsArrayForSection = [collation sortedArrayFromArray:programsArrayForSection collationStringSelector:@selector(name)];
		
		// Replace the existing array with the sorted array.
		[newSectionsArray replaceObjectAtIndex:index withObject:sortedProgramsArrayForSection];
	}
	
	self.sectionsArray = newSectionsArray;
	[newSectionsArray release];
    
    
    copyListOfItems = [[NSMutableArray alloc] init];
    searching = NO;
    letUserSelectRow = YES;
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
    for (MCoupon *tmpCoupon in listOfItems)
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
    
    [self SetupMapAnnotations];
    
    if(mapView.isHidden==NO)
    {
        [self ShowMapView];
    }

    
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    [refreshControl endRefreshing];
    searchedOnce=NO;
    [self ShowActivityView];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyBest; // 100 m
    [locationManager startUpdatingLocation];
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    self.trackedViewName = @"Find Coupons";
}


#pragma mark Location Functions

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    CLLocation *newLocation = [locations lastObject];
    CLLocationCoordinate2D coord;
    coord = newLocation.coordinate;
    
    
    BusinessLayer *businessObject = [[BusinessLayer alloc]init];
    businessObject.delegate = self;
    
    NSString *latValue,*lngValue;
    
    latValue = [[NSString alloc]initWithFormat:@"%f", coord.latitude];
    lngValue = [[NSString alloc]initWithFormat:@"%f", coord.longitude];
    
    MKCoordinateRegion region = { {0.0, 0.0 }, { 0.0, 0.0 } };
    region.center = coord;
    region.span.longitudeDelta = 0.05f;
    region.span.latitudeDelta = 0.05f;
    
    mapView.region = region;
    
    if(searchedOnce)
        return;
    
    searchedOnce = YES;
    
    
    
    //    [businessObject FindCoupons:@"30.693361" lngValue:@"76.698769" userId:appObject.loyalaz.user.uid];
    [businessObject FindCoupons:latValue lngValue:lngValue userId:appObject.loyalaz.user.uid];
    [latValue release];
    [lngValue release];
}





#pragma mark MapView Delegates

- (void)mapView:(MKMapView *)mapView1 didUpdateUserLocation:(MKUserLocation *)userLocation {
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.05;
    span.longitudeDelta = 0.05;
    CLLocationCoordinate2D location;
    location.latitude = userLocation.coordinate.latitude;
    location.longitude = userLocation.coordinate.longitude;
    region.span = span;
    region.center = location;
    [mapView setRegion:region animated:YES];
    //    NSLog(@"Map view did update user location");
}


-(MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:
(id <MKAnnotation>)annotation {
	MKPinAnnotationView *pinView = nil;
	if(annotation != mapView.userLocation)
	{
		static NSString *defaultPinID = @"com.loyalaz";
		pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
		if ( pinView == nil ) pinView = [[[MKPinAnnotationView alloc]
										  initWithAnnotation:annotation reuseIdentifier:defaultPinID] autorelease];
        
        
        //		pinView.pinColor = MKPinAnnotationColorRed;
        pinView.image = [UIImage imageNamed:@"pointer.png"];
		pinView.canShowCallout = YES;
		pinView.animatesDrop = NO;
        
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [rightButton addTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
        pinView.rightCalloutAccessoryView = rightButton;
        
    }
	else {
		[mapView.userLocation setTitle:@"I am here"];
        [pinView setHidden:YES];
	}
	return pinView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    // here we illustrate how to detect which annotation type was clicked on for its callout
    DisplayMap *ann = [view annotation];
    MCoupon *coupon = [listOfItems objectAtIndex: ann.indexNumber];

    
    CouponDetailsVC *moreCouponDetailsVC = [[CouponDetailsVC alloc]initWithNibNameAndCoupon:@"CouponDetailsVC" bundle:nil withCoupon:coupon];
    [self.navigationController pushViewController:moreCouponDetailsVC animated:YES];
    [moreCouponDetailsVC release];
}

#pragma mark Custom Functions

-(void) viewTypeChanged:(id)sender
{
    UISegmentedControl *segmentedControl = (UISegmentedControl*) sender;
    switch ([segmentedControl selectedSegmentIndex]) {
        case 0:
            // Show list view
            //            NSLog(@"LIST VIEW");
            [tableViewCoupons setHidden:NO];
            [mapView setHidden:YES];
            break;
        case 1:
            // Show map view
            //            NSLog(@"MAP VIEW");
            [mapView setHidden:NO];
            [tableViewCoupons setHidden:YES];
            [self ShowMapView];
            break;
    }
}


-(void)ShowMapView
{
    if(annArray!=nil)
    {
        [mapView removeAnnotations:annArray];
    }
    
    [self SetupMapAnnotations];
    [mapView setMapType:MKMapTypeStandard];
	[mapView setZoomEnabled:YES];
	[mapView setScrollEnabled:YES];
	[mapView setDelegate:self];
    //    mapView.showsUserLocation=YES;
    
    [mapView addAnnotations:annArray];
    
    NSLog(@"ANN count=%i",annArray.count);
}

-(void)SetupMapAnnotations
{
    
    MCoupon *tempCoupon = nil;
    annArray = [[NSMutableArray alloc]init];
    
    if(searching==NO)
    {
        for(int i=0;i<appObject.moreCoupons.MCoupons.count;i++)
        {
            tempCoupon = [appObject.moreCoupons.MCoupons objectAtIndex:i];
            
            // new coded added here
            MKCoordinateRegion region = { {0.0, 0.0 }, { 0.0, 0.0 } };
            region.center.latitude =  [tempCoupon.lat doubleValue] ;
            region.center.longitude = [tempCoupon.lng doubleValue];
            region.span.longitudeDelta = 0.01f;
            region.span.latitudeDelta = 0.01f;
            
            DisplayMap *ann = [[DisplayMap alloc] init];
            ann.title = [tempCoupon.name stringByRemovingPercentEncoding];
            ann.subtitle = [tempCoupon.description stringByRemovingPercentEncoding];
            ann.coordinate = region.center;
            ann.indexNumber = i;
            [annArray addObject:ann];
        }
        
    }
    else
    {
        for(int i=0;i<copyListOfItems.count;i++)
        {
            tempCoupon = [copyListOfItems objectAtIndex:i];
            
            // new coded added here
            MKCoordinateRegion region = { {0.0, 0.0 }, { 0.0, 0.0 } };
            region.center.latitude =  [tempCoupon.lat doubleValue] ;
            region.center.longitude = [tempCoupon.lng doubleValue];
            region.span.longitudeDelta = 0.01f;
            region.span.latitudeDelta = 0.01f;
            
            DisplayMap *ann = [[DisplayMap alloc] init];
            ann.title = [tempCoupon.name stringByRemovingPercentEncoding];
            ann.subtitle = [tempCoupon.description stringByRemovingPercentEncoding];
            ann.coordinate = region.center;
            ann.indexNumber = i;
            [annArray addObject:ann];
            //
        }
        
    }
    
}



@end