//
//  FindProgramsVC.m
//  LoyalAZ
//

#import "FindProgramsVC.h"

#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f


@interface FindProgramsVC () <UIScrollViewDelegate,UIAlertViewDelegate>
@property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;
@end

@implementation FindProgramsVC



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
    
    //    [viewType addTarget:self
    //                 action:@selector(viewTypeChanged:)
    //       forControlEvents:UIControlEventValueChanged];
    
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = NO;
    self.title = @"Find Programs";
    appObject = [Application applicationManager];
    self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
    //    appObject.morePrograms = [[MorePrograms alloc]init];
    //    MProgram *mprogram = [[MProgram alloc]init];
    //    mprogram.pid=@"111";
    //    mprogram.name=@"Prog 111";
    //    [appObject.morePrograms.MPrograms addObject:mprogram];
    //
    //    mprogram = [[MProgram alloc]init];
    //    mprogram.pid=@"222";
    //    mprogram.name=@"Prog";
    //    [appObject.morePrograms.MPrograms addObject:mprogram];
    //
    //    NSString *xml = [XMLParser ObjectToXml:appObject.morePrograms];
    //
    //    NSLog(@"XML===%@",xml);
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [tableViewPrograms addSubview:refreshControl];
    
    
//    if(appObject.cachedResults==YES)
//    {
//        [self BusinessLayerDidFinish:YES];
//        //        NSLog(@"ann count=%i",annArray.count);
//        return;
//    }
//    appObject.cachedResults = YES;
    
    
    
    
    if([appObject.loyalaz.find_enable isEqualToString:@"1"])
    {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
        locationManager.desiredAccuracy = kCLLocationAccuracyBest; // 100 m
        [locationManager startUpdatingLocation];
        
        //        BusinessLayer *businessObject = [[BusinessLayer alloc]init];
        //        businessObject.delegate = self;
        //        [businessObject FindPrograms:@"" :@""];
        
    }
    
    
    [self ShowActivityView];
    
    
    
    
    //    NSLog(@"Total programs found= %d",appObject.morePrograms.MPrograms.count);
    //
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
                                               initWithBarButtonSystemItem:UIBarButtonSystemItemCamera
                                               target:self action:@selector(buttonCameraClicked:)] autorelease];
    
}





-(void)viewDidAppear:(BOOL)animated
{
    self.trackedViewName = @"Find Programs";
}








// -------------------------------------------------------------------------------
//	didReceiveMemoryWarning
// -------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // terminate all pending download connections
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    
    [self.imageDownloadsInProgress removeAllObjects];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    if (searching)
        return copyListOfItems.count;
    else
        return appObject.morePrograms.MPrograms.count;
}

- (NSIndexPath *)tableView :(UITableView *)theTableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(letUserSelectRow)
        return indexPath;
    else
        return nil;
}

- (ProgramCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"CellId";
    MProgram *prg;
    
    if(searching)
    {
        prg = [copyListOfItems objectAtIndex:indexPath.row];
    }
    else
    {
        prg = [appObject.morePrograms.MPrograms objectAtIndex:indexPath.row];
    }
    
    ProgramCell *cell = (ProgramCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil)
    {
//        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
//        cell = [[[ProgramCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ProgramCell" owner:nil options:nil];
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    NSString *detailText = [[NSString alloc]initWithFormat:@"%@.\n%@, %@\nDistance:%@ km",[prg.tagline stringByRemovingPercentEncoding],prg.com_street,prg.com_suburb , prg.distance];
    
    cell.labelProgramName.text = [prg.name stringByRemovingPercentEncoding];
    cell.labelProgramName.numberOfLines = 0;
    UIFont *fontTitle = [UIFont fontWithName:@"OpenSans-ExtraBold" size:14.0f];
    [cell.labelProgramName setFont:fontTitle];

    
    CGRect nameRect = cell.labelProgramName.bounds;
    NSLog(@"Old Height=%f",nameRect.size.height);
    
    CGSize constraint = CGSizeMake(213, 20000.0f);
    CGSize size = [[prg.name stringByRemovingPercentEncoding] sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat height = size.height;
    
    nameRect.size.height = height;

    [cell.labelProgramName sizeToFit];
    
    
    nameRect = cell.labelProgramName.frame;
    NSLog(@"New Height=%f",nameRect.size.height);
    NSLog(@"HDFHDHDHDFH");
    
//    UIFont *fontDescription = [UIFont fontWithName:@"open-sans.light" size:12.0f];
    [cell.labelProgramDetails setFont:[UIFont systemFontOfSize:14]];
    cell.labelProgramDetails.text = detailText;
    cell.labelProgramDetails.numberOfLines = 0;

    
    size = [detailText sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    
    CGRect newRect = nameRect;
    newRect.size.height = size.height;
    newRect.size.width = 213;
    newRect.origin.y = nameRect.origin.y+nameRect.size.height;
    cell.labelProgramDetails.frame=newRect;
    cell.labelProgramDetails.adjustsFontSizeToFitWidth=NO;
    [cell.labelProgramDetails sizeToFit];
    

    
    if([prg.type isEqualToString:@"3"])
    {
        cell.imageViewType.image = [UIImage imageNamed:@"type_savings.png"];
    }
    else
    {
        cell.imageViewType.image = [UIImage imageNamed:@"type_basic.png"];
    }

    if (!prg.icon)
    {
        if (tableViewPrograms.dragging == NO && tableViewPrograms.decelerating == NO)
        {
            [self startIconDownload:prg forIndexPath:indexPath];
        }
        // if a download is deferred or in progress, return a placeholder image
        cell.imageViewLogo.image = [UIImage imageNamed:@"placeholder_logo.png"];
    }
    else
    {
    
        cell.imageViewLogo.image = prg.icon;
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MProgram *prg;
    
    if(searching)
    {
        prg = [copyListOfItems objectAtIndex:indexPath.row];
    }
    else
    {
        prg = [appObject.morePrograms.MPrograms objectAtIndex:indexPath.row];
    }
    
    if([prg.c isEqualToString:@""]==NO)
    {
        cell.backgroundColor = [Helper colorFromHexString:prg.c];
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    MProgram *prg;
    
    if(searching)
    {
        prg = [copyListOfItems objectAtIndex:indexPath.row];
    }
    else
    {
        prg = [appObject.morePrograms.MPrograms objectAtIndex:indexPath.row];
    }
    NSString *detailText = [[NSString alloc]initWithFormat:@"%@.\n%@, %@\nDistance:%@ km",[prg.tagline stringByRemovingPercentEncoding],prg.com_street,prg.com_suburb , prg.distance];
    
    
    CGSize constraint = CGSizeMake(213, 20000.0f);
    
    
    // get the height of program name label
    
    CGSize size = [[prg.name stringByRemovingPercentEncoding] sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat height = size.height;
    
    // get the height of descrition label
    size = [detailText sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    
    // add the new height in previous height + 5 px gap.
    height += size.height+5;
    
    // get the height between calculated height and minimum height of 85
    height = MAX(height,90);
    
    UILabel *labelTemp = [[UILabel alloc]init];
    CGRect tempRect =  CGRectMake(0, 0, 213, 10);
    labelTemp.numberOfLines=0;
    UIFont *fontTitle = [UIFont fontWithName:@"OpenSans-ExtraBold" size:14.0f];
    [labelTemp setFont:fontTitle];
    [labelTemp setFrame:tempRect];
    labelTemp.text = [prg.name stringByRemovingPercentEncoding];
    [labelTemp sizeToFit];
    
    height = labelTemp.frame.size.height;
    
//    UIFont *fontDescription = [UIFont fontWithName:@"open-sans.light" size:12.0f];
    [labelTemp setFont:[UIFont systemFontOfSize:14]];
    [labelTemp setFrame:tempRect];
    labelTemp.text = detailText;
    [labelTemp sizeToFit];
    height +=labelTemp.frame.size.height+7;
    height = MAX(height,85);
    
    return height;//+ (CELL_CONTENT_MARGIN * 1) ;
}

#pragma mark Icons Lazy Loading

// -------------------------------------------------------------------------------
//	startIconDownload:forIndexPath:
// -------------------------------------------------------------------------------
- (void)startIconDownload:(MProgram *)prg forIndexPath:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [self.imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader == nil)
    {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.pRecord = prg;
        [iconDownloader setCompletionHandler:^{
            
//            UITableViewCell *cell = [tableViewPrograms cellForRowAtIndexPath:indexPath];
            ProgramCell *cell = (ProgramCell*) [tableViewPrograms cellForRowAtIndexPath:indexPath];
            
            // Display the newly loaded image
            cell.imageViewLogo.image = prg.icon;
            
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
    if ([appObject.morePrograms.MPrograms count] > 0)
    {
        NSArray *visiblePaths = [tableViewPrograms indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            MProgram *prgRecord;
            
            if(searching)
            {
                prgRecord = [copyListOfItems objectAtIndex:indexPath.row];
            }
            else
            {
                prgRecord = [appObject.morePrograms.MPrograms objectAtIndex:indexPath.row];
            }
            
            
            if (!prgRecord.icon)
                // Avoid the app icon download if the app already has an icon
            {
                [self startIconDownload:prgRecord forIndexPath:indexPath];
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

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    return @"";
//};

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // create the parent view that will hold header Label
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(1.0, 0.0, tableView.bounds.size.width, 40)];
    customView.backgroundColor = [UIColor lightGrayColor];
    customView.opaque=YES;
    // create the button object
    UIButton *headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [headerBtn setImage:[UIImage imageNamed:@"refer.jpg"] forState:UIControlStateNormal];
    headerBtn.frame = CGRectMake(1.0, 0.0, tableView.bounds.size.width, 40);
    headerBtn.opaque=YES;
    //    headerBtn.titleLabel.text = @"Button1";
    [headerBtn addTarget:self action:@selector(ReferButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [customView addSubview:headerBtn];
    
    return customView;
}


- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *gps = @"";
    if(buttonIndex==0)
        gps = @"0";
    else
        gps = @"1";
    
    NSArray *extras = [[NSArray alloc]initWithObjects:latValue,lngValue, gps, nil];
    ReferBusinessVC *referBusinessVC = [[ReferBusinessVC alloc]initWithNibNameExtras:@"ReferBusinessVC" bundle:nil withExtras:extras];
    [self.navigationController pushViewController:referBusinessVC animated:YES];
    [referBusinessVC release];
}


- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (void) tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MProgram *program = [appObject.morePrograms.MPrograms objectAtIndex:indexPath.row];
    MoreProgramDetailsVC *moreProgramDetailsVC = [[MoreProgramDetailsVC alloc]initWithNibNameAndProgram:@"MoreProgramDetailsVC" bundle:nil withProgram:program];
    [self.navigationController pushViewController:moreProgramDetailsVC animated:YES];
    [moreProgramDetailsVC release];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MProgram *program = [appObject.morePrograms.MPrograms objectAtIndex:indexPath.row];
//    NSLog(@"%@",program.pic_logo);
    MoreProgramDetailsVC *moreProgramDetailsVC = [[MoreProgramDetailsVC alloc]initWithNibNameAndProgram:@"MoreProgramDetailsVC" bundle:nil withProgram:program];
    [self.navigationController pushViewController:moreProgramDetailsVC animated:YES];
    [moreProgramDetailsVC release];
}

#pragma mark Business layer delegate functions

- (void)BusinessLayerDidFinish:(BOOL)result
{
    [self HideActivityView];
    if(result==YES)
    {
        //NSLog(@"Find programs returned.");
        listOfItems = [[NSMutableArray alloc]init];
        annArray = [[NSMutableArray alloc]init];
        MProgram *tempProgram = nil;
        for(int i=0;i<appObject.morePrograms.MPrograms.count;i++)
        {
            tempProgram = [appObject.morePrograms.MPrograms objectAtIndex:i];
            [listOfItems addObject:tempProgram];
        }
        [self SetupMapAnnotations];
        
        copyListOfItems = [[NSMutableArray alloc] init];
        searching = NO;
        letUserSelectRow = YES;
        [tableViewPrograms reloadData];
        // Fetched results are found in appObject.morePrograms.
    }
}



- (void)BusinessLayerErrorOccurred:(NSError *)err
{
    [self HideActivityView];
    //NSLog(@"FindPrograms: Error occurred, can't move further.");
}


#pragma mark SearchBar Delegate Functions

- (void) searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar {
    
    searching = YES;
    letUserSelectRow = NO;
    tableViewPrograms.scrollEnabled = NO;
    
    //Add the done button.
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
                                               initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                               target:self action:@selector(doneSearching_Clicked:)] autorelease];
}


- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText {
    
    //Remove all objects first.
    [copyListOfItems removeAllObjects];
    NSLog(@"LEN=%i",searchText.length);
    
    if([searchText length] > 0) {
        
        searching = YES;
        letUserSelectRow = YES;
        tableViewPrograms.scrollEnabled = YES;
        [self searchTableView];
    }
    else {
        
        searching = NO;
        letUserSelectRow = NO;
        tableViewPrograms.scrollEnabled = NO;
    }
    
    [tableViewPrograms reloadData];
}


- (void) searchBarSearchButtonClicked:(UISearchBar *)theSearchBar {
    
    [self searchTableView];
    [theSearchBar resignFirstResponder];
}

- (void) searchTableView {
    
    NSString *searchText = searchBar.text;
    NSMutableArray *searchArray = [[NSMutableArray alloc] init];
    
    NSString *tempName;
    
    if(annArray!=nil)
    {
        [mapView removeAnnotations:annArray];
        [annArray removeAllObjects];
    }
    
    for (MProgram *tmpProgram in listOfItems)
    {
        tempName = tmpProgram.name;
        NSRange titleResultsRange = [tempName rangeOfString:searchText options:NSCaseInsensitiveSearch];
        
        if (titleResultsRange.length > 0)
        {
            [copyListOfItems addObject:tmpProgram];
        }
        
    }
    
    if([mapView isHidden]==NO)
    {
        [mapView setMapType:MKMapTypeStandard];
        [mapView setZoomEnabled:YES];
        [mapView setScrollEnabled:YES];
        [mapView setDelegate:self];
        //mapView.showsUserLocation=YES;
        [self SetupMapAnnotations];
        [self ShowMapView];
        
    }
    
    
    [searchArray release];
    searchArray = nil;
}


#pragma mark Location Functions

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    
    
    CLLocationCoordinate2D coord;
    coord = newLocation.coordinate;
    //    MKUserLocation *mLocation = [[MKUserLocation alloc]init];
    //    mLocation.coordinate = coord;
    //    [self mapView:mapView didUpdateUserLocation:mLocation];
    
    if(searchedOnce)
        return;
    
    searchedOnce = YES;
    
    BusinessLayer *businessObject = [[BusinessLayer alloc]init];
    businessObject.delegate = self;
    
    
    
    latValue = [[NSString alloc]initWithFormat:@"%f", coord.latitude];
    lngValue = [[NSString alloc]initWithFormat:@"%f", coord.longitude];
    
    MKCoordinateRegion region = { {0.0, 0.0 }, { 0.0, 0.0 } };
    region.center = coord;
    region.span.longitudeDelta = 0.05f;
    region.span.latitudeDelta = 0.05f;
    
    mapView.region = region;
    
//    [businessObject FindPrograms:@"7.060835" lngValue:@"125.593475" userId:appObject.loyalaz.user.uid];
    [businessObject FindPrograms:latValue lngValue:lngValue userId:appObject.loyalaz.user.uid];
    //    [latValue release];
    //    [lngValue release];
}


#pragma mark Action Button Clicks

- (void) buttonCameraClicked:(id)sender
{
    //NSLog(@"Camera clicked.");
    ProgramsVC *programsVC = [[ProgramsVC alloc]initWithNibNameAndCamera:@"ProgramsVC" bundle:nil];
    [self.navigationController pushViewController:programsVC animated:YES];
    [programsVC release];
}

-(void)ReferButtonClicked:(id)sender
{
    NSString *msg = @"Recommend Current Location to join LoyalAZ?";
    UIAlertView *alertViewLocations = [[UIAlertView alloc]initWithTitle:@"" message:msg delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alertViewLocations show];
    [alertViewLocations release];
}

- (void) doneSearching_Clicked:(id)sender {
    
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    
    letUserSelectRow = YES;
    searching = NO;
    self.navigationItem.rightBarButtonItem = nil;
    tableViewPrograms.scrollEnabled = YES;
    
    [tableViewPrograms reloadData];
    [self SetupMapAnnotations];
    
    if(mapView.isHidden==NO)
    {
        [self ShowMapView];
    }
    
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
    MProgram *tempPrg = [listOfItems objectAtIndex: ann.indexNumber];
    //    NSLog(@"Index=%i",ann.indexNumber);
    //
    //    NSLog(@"DESC=%@",tempPrg.description);
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    MProgram *program = [appObject.morePrograms.MPrograms objectAtIndex:indexPath.row];
    MoreProgramDetailsVC *moreProgramDetailsVC = [[MoreProgramDetailsVC alloc]initWithNibNameAndProgram:@"MoreProgramDetailsVC" bundle:nil withProgram:tempPrg];
    [self.navigationController pushViewController:moreProgramDetailsVC animated:YES];
    [moreProgramDetailsVC release];
    
    //NSLog(@"clicked Golden Gate Bridge annotation");
    //[self.navigationController pushViewController:self.detailViewController animated:YES];
}

#pragma mark Custom Functions

-(void) viewTypeChanged:(id)sender
{
    UISegmentedControl *segmentedControl = (UISegmentedControl*) sender;
    switch ([segmentedControl selectedSegmentIndex]) {
        case 0:
            // Show list view
            //            NSLog(@"LIST VIEW");
            [tableViewPrograms setHidden:NO];
            [mapView setHidden:YES];
            break;
        case 1:
            // Show map view
            //            NSLog(@"MAP VIEW");
            [mapView setHidden:NO];
            [tableViewPrograms setHidden:YES];
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
    
    //    float maxLat = -200;
    //    float maxLong = -200;
    //    float minLat = MAXFLOAT;
    //    float minLong = MAXFLOAT;
    //
    //    for (int i=0 ;i< annArray.count ; i++) {
    //        CLLocationCoordinate2D location;
    //        DisplayMap* ann = [annArray objectAtIndex:i];
    //
    //        location = ann.coordinate;
    //
    //        if (location.latitude < minLat) {
    //            minLat = location.latitude;
    //        }
    //
    //        if (location.longitude < minLong) {
    //            minLong = location.longitude;
    //        }
    //
    //        if (location.latitude > maxLat) {
    //            maxLat = location.latitude;
    //        }
    //
    //        if (location.longitude < maxLong) {
    //            maxLong = location.longitude;
    //        }
    //    }
    //
    //    CLLocationCoordinate2D center = CLLocationCoordinate2DMake((maxLat - minLat) * 0.5, (maxLong - minLong) * 0.5);
    //    mapView.centerCoordinate = center;
    
    NSLog(@"ANN count=%i",annArray.count);
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

-(void)SetupMapAnnotations
{
    
    MProgram *tempProgram = nil;
    annArray = [[NSMutableArray alloc]init];
    
    if(searching==NO)
    {
        for(int i=0;i<appObject.morePrograms.MPrograms.count;i++)
        {
            tempProgram = [appObject.morePrograms.MPrograms objectAtIndex:i];
            
            // new coded added here
            MKCoordinateRegion region = { {0.0, 0.0 }, { 0.0, 0.0 } };
            region.center.latitude =  [tempProgram.lat doubleValue] ;
            region.center.longitude = [tempProgram.lng doubleValue];
            region.span.longitudeDelta = 0.01f;
            region.span.latitudeDelta = 0.01f;
            
            DisplayMap *ann = [[DisplayMap alloc] init];
            ann.title = [tempProgram.name stringByRemovingPercentEncoding];
            ann.subtitle = [tempProgram.description stringByRemovingPercentEncoding];
            ann.coordinate = region.center;
            ann.indexNumber = i;
            [annArray addObject:ann];
        }
        
    }
    else
    {
        for(int i=0;i<copyListOfItems.count;i++)
        {
            tempProgram = [copyListOfItems objectAtIndex:i];
            
            // new coded added here
            MKCoordinateRegion region = { {0.0, 0.0 }, { 0.0, 0.0 } };
            region.center.latitude =  [tempProgram.lat doubleValue] ;
            region.center.longitude = [tempProgram.lng doubleValue];
            region.span.longitudeDelta = 0.01f;
            region.span.latitudeDelta = 0.01f;
            
            DisplayMap *ann = [[DisplayMap alloc] init];
            ann.title = [tempProgram.name stringByRemovingPercentEncoding];
            ann.subtitle = [tempProgram.description stringByRemovingPercentEncoding];
            ann.coordinate = region.center;
            ann.indexNumber = i;
            [annArray addObject:ann];
            //
        }
        
    }
    
}



@end
