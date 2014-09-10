//
//  ProgramsVC.m
//  LoyalAZ

#import "ProgramsVC.h"
#import "AppDelegate.h"

#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f

@interface ProgramsVC ()

@end

@implementation ProgramsVC
@synthesize collation;
@synthesize sectionsArray;
@synthesize StartScan;
@synthesize postParams = _postParams;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    self.StartScan = NO;
    return self;
}

- (id)initWithNibNameAndCamera:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    self.StartScan = YES;
    
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
    
    dateFirst = [[NSString alloc]initWithString:@""];
    dateSecond = [[NSString alloc]initWithString:@""];
    flagCalled = NO;
    
    
    postToFBWallPending = NO;
    getCouponCode = NO;
    
    if(StartScan)
    {
        StartScan = NO;
        [self buttonCameraClicked:nil];
    }
    else 
    {
        [self ShowActivityView];
    }
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(sessionStateChanged:)
     name:FBSessionStateChangedNotification
     object:nil];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate openSessionWithAllowLoginUI:NO];
    // Do any additional setup after loading the view from its nib.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void) viewDidAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.title = @"My Programs";
    self.trackedViewName = @"My Programs";
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
                                               initWithBarButtonSystemItem:UIBarButtonSystemItemCamera
                                               target:self action:@selector(buttonCameraClicked:)] autorelease];    
    [self SetupArrays];
    [tableViewPrograms reloadData];
    [self HideActivityView];
}

-(void) SetupArrays
{
    appObject = [Application applicationManager];
    
    //NSLog(@"Total programs = %d",appObject.loyalaz.programs.count);
    listOfItems = [[NSMutableArray alloc]init];
    
    Program *tempProgram = nil;
    for(int i=0;i<appObject.loyalaz.programs.count;i++)
    {
        tempProgram = [appObject.loyalaz.programs objectAtIndex:i];
        [listOfItems addObject:tempProgram];
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
    
    NSMutableArray *arrayPID = [[NSMutableArray alloc]init];
    BOOL flagDuplicate = NO;
    
	for (Program *prog in appObject.loyalaz.programs) {
        
        for(int i=0;i<arrayPID.count;i++)
        {
            if([prog.pid isEqualToString:[arrayPID objectAtIndex:i]])
            {
                flagDuplicate = YES;
                break;
            }
        }
        
        if(flagDuplicate==NO)
        {
            
            if([prog.active isEqualToString:@"0"]==NO) // condition to check if the program has been deleted in offline mode.
            {
                [arrayPID addObject:prog.pid];
                // Ask the collation which section number the time zone belongs in, based on its locale name.
                NSInteger sectionNumber = [collation sectionForObject:prog collationStringSelector:@selector(name)];
                
                
                // Get the array for the section.
                NSMutableArray *sectionPrograms = [newSectionsArray objectAtIndex:sectionNumber];
                
                //  Add the time zone to the section.
                [sectionPrograms addObject:prog];
                
            }
            
            
        }
        flagDuplicate = NO;
		
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

- (void) searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar {
    
    searching = YES;
    letUserSelectRow = NO;
    tableViewPrograms.scrollEnabled = NO;
    
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
}

- (void) searchTableView {
    
    NSString *searchText = searchBar.text;
    NSMutableArray *searchArray = [[NSMutableArray alloc] init];
    

    
    NSString *tempName;
    for (Program *tmpProgram in listOfItems)
    {
        tempName = tmpProgram.name;
        NSRange titleResultsRange = [tempName rangeOfString:searchText options:NSCaseInsensitiveSearch];
        
        if (titleResultsRange.length > 0)
            [copyListOfItems addObject:tmpProgram];
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
    tableViewPrograms.scrollEnabled = YES;
    [tableViewPrograms reloadData];
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
                                               initWithBarButtonSystemItem:UIBarButtonSystemItemCamera
                                               target:self action:@selector(buttonCameraClicked:)] autorelease];        
}

- (void) buttonCameraClicked:(id)sender
{

//    [self ScanDidFinish:@"LAZ+33+2577+Free 1 Glass of Wine+Lorem ipsum dolor sit amet%2C consectetuer adipiscing elit%2C sed diam nonummy++3+10+http://www.loyalaz.com/test/images/uploads/programs/logo/432014-98F4D.png+http://www.loyalaz.com/test/images/uploads/programs/front/432014-93C50.jpg+http://www.loyalaz.com/test/images/uploads/programs/back/432014-FB9FD.jpg+60+York San Pedro+LoyalAZ/+www.GasolinePremium.co.nz+0224578703+tulid.miexie@gmail.com++++Lorem ipsum dolor sit amet%2C consectetuer adipiscin+EA49,1E9A,9E85"];
    ScanQR *scanObject = [[ScanQR alloc]init];
    scanObject.scandelegate = self;
    [scanObject ScanCode:self];
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
	NSArray *programsInSection = [sectionsArray objectAtIndex:section];
    
    if (searching)
        return copyListOfItems.count;
    else
        return [programsInSection count];
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


//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if(cell==nil)
//    {
//        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
//
//    }
//    NSArray *programsInSection = [sectionsArray objectAtIndex:indexPath.section];
//    Program *prg;
//    
//    if(searching)
//    {
//        prg = [copyListOfItems objectAtIndex:indexPath.row];
//    }
//    else
//    {
//        prg = [programsInSection objectAtIndex:indexPath.row];
//    }
//    
//    cell.textLabel.text = [prg.name stringByRemovingPercentEncoding];
//    NSString *detailText = [[NSString alloc]initWithFormat:@"%@ \nRewards: (%@/%@)",[prg.tagline stringByRemovingPercentEncoding],prg.pt_balance,prg.pt_target];
//    cell.detailTextLabel.text=detailText;
//    cell.detailTextLabel.numberOfLines = 0;
//    //cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
//    cell.textLabel.adjustsFontSizeToFitWidth=YES;
//    
//    
////    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
////    
////    CGSize size = [detailText sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
////    
////    CGFloat height = MAX(size.height, 44.0f);
////    [cell.textLabel setFrame:CGRectMake(0, 0, size.width, height)];
//    
//    
//    if([prg.d isEqualToString:@"1"])
//    {
//        cell.imageView.image = [UIImage imageNamed:@"placeholder_logo"];
//    }
//    else
//    {
//        cell.imageView.image = [UIImage imageWithContentsOfFile:[Helper GetStoragePath:prg.pic_logo]];
////        cell.imageView.image = [UIImage imageWithContentsOfFile:prg.pic_logo];
//    }
//    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
//    
////    if([prg.c isEqualToString:@""]==NO)
////    {
////        cell.contentView.backgroundColor = [Helper colorFromHexString:prg.c];
////        cell.backgroundView.backgroundColor =[Helper colorFromHexString:prg.c];
////        cell.accessoryView.backgroundColor= [Helper colorFromHexString:prg.c];
////        cell.textLabel.backgroundColor = [Helper colorFromHexString:prg.c];
////        cell.detailTextLabel.backgroundColor=[Helper colorFromHexString:prg.c];
////    }
//    
//
//    [detailText release];
//    
//    
//    return cell;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    NSArray *programsInSection = [sectionsArray objectAtIndex:indexPath.section];
    Program *prg;
    
    if(searching)
    {
        prg = [copyListOfItems objectAtIndex:indexPath.row];
    }
    else
    {
        prg = [programsInSection objectAtIndex:indexPath.row];
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
    
    NSString *detailText;
    

    if([prg.type isEqualToString:@"3"])
    {
        cell.imageViewType.image = [UIImage imageNamed:@"type_savings.png"];
        detailText = [[NSString alloc]initWithFormat:@"%@ \nAvailable: (%@/%@)",[prg.tagline stringByRemovingPercentEncoding],prg.pt_balance,prg.pt_target];
    }
    else
    {
        cell.imageViewType.image = [UIImage imageNamed:@"type_basic.png"];
        detailText = [[NSString alloc]initWithFormat:@"%@ \nRewards: (%@/%@)",[prg.tagline stringByRemovingPercentEncoding],prg.pt_balance,prg.pt_target];
    }


    cell.labelProgramName.text = [prg.name stringByRemovingPercentEncoding];
    cell.labelProgramName.numberOfLines = 0;
    UIFont *fontTitle = [UIFont fontWithName:@"OpenSans-ExtraBold" size:14.0f];
    [cell.labelProgramName setFont:fontTitle];
    
    
//    cell.labelProgramName.text = [prg.name stringByRemovingPercentEncoding];
//    cell.labelProgramDetails.text = detailText;
//    cell.labelProgramDetails.numberOfLines = 0;
//    [cell.labelProgramName sizeToFit];
//    [cell.labelProgramDetails sizeToFit];
    
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
    
    UIFont *fontDescription = [UIFont fontWithName:@"open-sans.light" size:12.0f];
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
    
    

    if([prg.d isEqualToString:@"1"])
    {
        cell.imageViewLogo.image = [UIImage imageNamed:@"placeholder_logo"];
    }
    else
    {
        
        cell.imageViewLogo.contentMode=UIViewContentModeCenter;
        cell.imageViewLogo.image = [UIImage imageWithContentsOfFile:[Helper GetStoragePath:prg.pic_logo]];

    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    [detailText release];
    
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSArray *programsInSection = [sectionsArray objectAtIndex:indexPath.section];
    Program *prg;
    
    if(searching)
    {
        prg = [copyListOfItems objectAtIndex:indexPath.row];
    }
    else
    {
        prg = [programsInSection objectAtIndex:indexPath.row];
    }
    
    
    NSString *detailText;
    
    
    if([prg.type isEqualToString:@"3"])
    {
        detailText = [[NSString alloc]initWithFormat:@"%@ \nAvailable: (%@/%@)",[prg.tagline stringByRemovingPercentEncoding],prg.pt_balance,prg.pt_target];
    }
    else
    {
        detailText = [[NSString alloc]initWithFormat:@"%@ \nRewards: (%@/%@)",[prg.tagline stringByRemovingPercentEncoding],prg.pt_balance,prg.pt_target];
    }
    
    CGSize constraint = CGSizeMake(213, 20000.0f);
    
    
    // get the height of program name label
    
    CGSize size = [[prg.name stringByRemovingPercentEncoding] sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
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
    labelTemp.text = [prg.name stringByRemovingPercentEncoding];
    [labelTemp sizeToFit];
    
    height = labelTemp.frame.size.height;
    

    
    UIFont *fontDescription = [UIFont fontWithName:@"open-sans.light" size:12.0f];
    [labelTemp setFont:[UIFont systemFontOfSize:14]];
    [labelTemp setFrame:tempRect];
    labelTemp.text = detailText;
    [labelTemp sizeToFit];
    height +=labelTemp.frame.size.height+5;
    
    height = MAX(height,85);
    
    return height;//+ (CELL_CONTENT_MARGIN * 1) ;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

    NSArray *programsInSection = [sectionsArray objectAtIndex:indexPath.section];
    Program *prg;
    
    if(searching)
    {
        prg = [copyListOfItems objectAtIndex:indexPath.row];
    }
    else
    {
        prg = [programsInSection objectAtIndex:indexPath.row];
    }
        if([prg.c isEqualToString:@""]==NO)
        {
            cell.backgroundColor = [Helper colorFromHexString:prg.c];
        }
    
    if([prg.type isEqualToString:@"3"])
    {
        if([prg.pt_balance isEqualToString:@"0"])
        {
            cell.backgroundColor = [UIColor redColor];
        }
    }
    
}



- (void) tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Program *program;
    
    NSArray *programsInSection = [sectionsArray objectAtIndex:indexPath.section];
    program = [programsInSection objectAtIndex:indexPath.row];
    
    if([program.act isEqualToString:@"1"])
    {
        //        getCouponCode = YES;
        //        BusinessLayer *businessObject = [[BusinessLayer alloc]init];
        //        businessObject.coupondelegate = self;
        //        couponProgram = program;
        //        [self ProcessRedeem];
        
        
        getCouponCode = YES;
        couponProgram = program;
        tempCompanyName = program.com_name;
        [self CouponCodeFinishedWithCouponCode:YES withCouponCode:program.coupon_no];
        //businessObject.coupondelegate = self;
        //[businessObject GetCouponNumber:appObject.loyalaz.user.uid :vProgram];
    }
    else
    {
        ProgramDetailsVC *programDetailsVC = [[ProgramDetailsVC alloc]initWithNibNameAndProgram:@"ProgramDetailsVC" bundle:nil withProgram:program];
        [self.navigationController pushViewController:programDetailsVC animated:YES];
        [programDetailsVC release];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Program *program;
    
    NSArray *programsInSection = [sectionsArray objectAtIndex:indexPath.section];
    
    if(searching)
    {
        program = [copyListOfItems objectAtIndex:indexPath.row];
    }
    else
    {
        program = [programsInSection objectAtIndex:indexPath.row];
    }
    
    [self NavigateToProgramDetails:program];
    
    
    
//    if([program.act isEqualToString:@"1"])
//    {
////        getCouponCode = YES;
////        BusinessLayer *businessObject = [[BusinessLayer alloc]init];
////        businessObject.coupondelegate = self;
////        couponProgram = program;
////        [self ProcessRedeem];
//        
//        if([program.coupon_no isEqualToString:@""]) // Check if the ACT state==1 and Coupon number is not yet generated.
//        {
//            if([Helper IsInternetAvailable]==YES)
//            {
//                BusinessLayer *businessObject = [[BusinessLayer alloc]init];
//                getCouponCode = YES;
//                couponProgram = program;
//                tempCompanyName = program.com_name;
//                businessObject.coupondelegate = self;
//                [businessObject GetCouponNumber:appObject.loyalaz.user.uid withProgram:program];
//            }
//            else
//            {
//                NSString *message = [[NSString alloc]initWithFormat:@"Internet connection is required to receive the Coupon Number. Please click on this Program when internet connection is available."];
//                UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//                [av show];
//                [av release];
//                [message release];
//            }
//
//        }
//        else //ACT state==1 and coupon number is already generated.
//        {
//            getCouponCode = YES;
//            couponProgram = program;
//            tempCompanyName = program.com_name;
//            [self CouponCodeFinishedWithCouponCode:YES withCouponCode:program.coupon_no];
//        }
//        //businessObject.coupondelegate = self;
//        //[businessObject GetCouponNumber:appObject.loyalaz.user.uid :vProgram];
//    }
//    else 
//    {
//        ProgramDetailsVC *programDetailsVC = [[ProgramDetailsVC alloc]initWithNibNameAndProgram:@"ProgramDetailsVC" bundle:nil withProgram:program];
//        [self.navigationController pushViewController:programDetailsVC animated:YES];
//        [programDetailsVC release];
//    }
}

-(void)NavigateToProgramDetails:(Program *)programObject
{
    if([programObject.act isEqualToString:@"1"])
    {
        //        getCouponCode = YES;
        //        BusinessLayer *businessObject = [[BusinessLayer alloc]init];
        //        businessObject.coupondelegate = self;
        //        couponProgram = program;
        //        [self ProcessRedeem];
        
        if([programObject.coupon_no isEqualToString:@""]) // Check if the ACT state==1 and Coupon number is not yet generated.
        {
            if([Helper IsInternetAvailable]==YES)
            {
                BusinessLayer *businessObject = [[BusinessLayer alloc]init];
                getCouponCode = YES;
                couponProgram = programObject;
                tempCompanyName = programObject.com_name;
                businessObject.coupondelegate = self;
                [businessObject GetCouponNumber:appObject.loyalaz.user.uid withProgram:programObject];
            }
            else
            {
                NSString *message = [[NSString alloc]initWithFormat:@"Internet connection is required to receive the Coupon Number. Please click on this Program when internet connection is available."];
                UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [av show];
                [av release];
                [message release];
            }
            
        }
        else //ACT state==1 and coupon number is already generated.
        {
            getCouponCode = YES;
            couponProgram = programObject;
            tempCompanyName = programObject.com_name;
            [self CouponCodeFinishedWithCouponCode:YES withCouponCode:programObject.coupon_no];
        }
        //businessObject.coupondelegate = self;
        //[businessObject GetCouponNumber:appObject.loyalaz.user.uid :vProgram];
    }
    else
    {
        ProgramDetailsVC *programDetailsVC = [[ProgramDetailsVC alloc]initWithNibNameAndProgram:@"ProgramDetailsVC" bundle:nil withProgram:programObject];
        [self.navigationController pushViewController:programDetailsVC animated:YES];
        [programDetailsVC release];
    }
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView beginUpdates];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Do whatever data deletion you need to do...
        // Delete the row from the data source

        
        NSArray *programsInSection = [sectionsArray objectAtIndex:indexPath.section];
        programToDelete = [programsInSection objectAtIndex:indexPath.row];
        indexPathToDelete = indexPath;
        
        UIAlertView *avConfirmDelete = [[UIAlertView alloc]initWithTitle:@"LoyalAZ" message:@"Are you sure? You will lose all rewards accumulated for this program!" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        avConfirmDelete.tag = 4;
        [avConfirmDelete show];
        
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


#pragma mark - FB Posting methods

- (void)doFBLogin {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (FBSession.activeSession.isOpen==NO) //Means the user is not logged in.
    {
        // The user has initiated a login, so call the openSession method
        // and show the login UX if necessary.
        [appDelegate openSessionWithAllowLoginUI:YES];
    }
}


- (void)publishStory
{
    
    NSLog(@"FB Story---%@",self.postParams);
    
    [FBRequestConnection
     startWithGraphPath:@"me/feed"
     parameters:self.postParams
     HTTPMethod:@"POST"
     completionHandler:^(FBRequestConnection *connection,
                         id result,
                         NSError *error) {
         NSString *alertText;
         if (error) {
             alertText = [NSString stringWithFormat:
                          @"error: domain = %@, code = %d",
                          error.domain, error.code];
             
             NSLog(@"Error:%@",alertText);
         } else {
             alertText = [NSString stringWithFormat:
                          @"Posted action, id: %@",
                          [result objectForKey:@"id"]];
             NSLog(@"Posted action:%@",alertText);
         }
         // Show the result in an alert
         //         [[[UIAlertView alloc] initWithTitle:@"Result"
         //                                     message:alertText
         //                                    delegate:nil
         //                           cancelButtonTitle:@"OK!"
         //                           otherButtonTitles:nil]
         //          show];
     }];
}



- (void)PostToFBWall
{
    // Hide keyboard if showing when button clicked
    
    
    //    self.postParams =
    //    [[NSMutableDictionary alloc] initWithObjectsAndKeys:
    //     @"Program scanned", @"name",
    //     @"A new program is scanned.", @"caption",
    //     @"Your rewards (8/10)", @"description",
    //     nil];
    NSLog(@"Before posting...");
    
    if(flagCalled==YES)
    {
        //        dateSecond = stringDTStamp;
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"dd-MM-yyyy hh:mm:ss a"];
        NSDate *firstDate = [formatter dateFromString:dateFirst];
        NSLog(@"%@",firstDate);
        
        NSDate *current = [NSDate date];
        NSString *stringDTStamp = [formatter stringFromDate:current];
        NSDate *currentDate = [[NSDate alloc] init];
        // voila!
        currentDate = [formatter dateFromString:stringDTStamp];
        [formatter release];
        
        NSTimeInterval tInt =  [currentDate timeIntervalSinceDate:firstDate];
        NSLog(@"DIFF = %f",tInt);
        if(tInt <= 1.0)
        {
            NSLog(@"Too frequent function call.");
            return;
        }
        NSLog(@"Proceed with function.");
        flagCalled = NO;
        
    }
    else
    {
        flagCalled = YES;
        NSDate *current = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd-MM-yyyy hh:mm:ss a"];
        NSString *stringDTStamp = [formatter stringFromDate:current];
        [formatter release];
        
        dateFirst  = [[NSString alloc]initWithString:stringDTStamp];
        //        [stringDTStamp release];
        
        NSLog(@"date first=%@",dateFirst);
        
        
        if (FBSession.activeSession.isOpen==NO) //Means the user is not logged in.
        {
            NSLog(@"Need to login to FB.");
            [self doFBLogin];
        }
        
        // Ask for publish_actions permissions in context
        if ([FBSession.activeSession.permissions
             indexOfObject:@"publish_actions"] == NSNotFound) {
            // No permissions found in session, ask for it
            NSLog(@"FB Permissions required");
            [FBSession.activeSession
             reauthorizeWithPublishPermissions:
             [NSArray arrayWithObject:@"publish_actions"]
             defaultAudience:FBSessionDefaultAudienceFriends
             completionHandler:^(FBSession *session, NSError *error) {
                 if (!error) {
                     // If permissions granted, publish the story
                     NSLog(@"Permissions granted.");
                     [self publishStory];
                 }
             }];
        } else {
            // If permissions present, publish the story
            NSLog(@"Permissions already present.");
            [self publishStory];
        }
        
    }
    
    
    
}

- (void)sessionStateChanged:(NSNotification*)notification {
    if (FBSession.activeSession.isOpen)
    {
        [self PostToFBWall];
        //NSLog(@"User is logged in.");
        if(postToFBWallPending == YES)
        {
            //NSLog(@"Will post the pending feed now.");
            //[self PostToFBWall];
        }
        //[self.authButton setTitle:@"Logout" forState:UIControlStateNormal];
    } else
    {
        //NSLog(@"User needs to be logged in.");
        //[self.authButton setTitle:@"Login" forState:UIControlStateNormal];
    }
}



#pragma mark - Scanning methods

- (void)ScanDidFinish:(NSString *)resultString
{
//    NSLog(@"Scanned code===%@",resultString);
    //Create the object of Program here and do the next step.
    
    NSArray *stringValues = [resultString componentsSeparatedByString:@"+"];
//    NSLog(@"total items=%d",stringValues.count);
    
    if([[stringValues objectAtIndex:0]isEqualToString:@"LAZ"]==NO)
    {
        NSString *message = [[NSString alloc]initWithFormat:@"This is not a valid LoyalAZ code."];
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"LoyalAZ" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [av show];
        [av release];
        [message release];
        return;
    }
    
    if([[stringValues objectAtIndex:6]isEqualToString:@"1"]==YES || [[stringValues objectAtIndex:6]isEqualToString:@"2"]==YES)
    {
        [self ProcessPerItemProgramType:resultString];
    }
    else if([[stringValues objectAtIndex:6]isEqualToString:@"3"]==YES)
    {
        [self ProcessSavingProgramType:resultString];
//        NSString *message = [[NSString alloc]initWithFormat:@"To recharge or load your SAVINGS card – please show your handset to staff member for validation"];
//        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"LoyalAZ" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
//        av.tag = 5;
//        [av show];
//        [av release];
//        [message release];
//        qrCodeString = resultString;
    }
    else if([[stringValues objectAtIndex:6]isEqualToString:@"4"]==YES)
    {
        [self ProcessAccumulatingProgramType:resultString];
    }
    
    
    //[vProgram release];
}

-(void)ProcessAccumulatingProgramType:(NSString *)scannedString
{
    NSArray *stringValues = [scannedString componentsSeparatedByString:@"+"];
    
    Program *vProgram = [[Program alloc]init];
    vProgram.id=[stringValues objectAtIndex:1];
    vProgram.pid=[stringValues objectAtIndex:2];
    vProgram.name=[stringValues objectAtIndex:3];
    vProgram.tagline=[stringValues objectAtIndex:4];
    //vProgram.description=[stringValues objectAtIndex:4];
    vProgram.type=[stringValues objectAtIndex:6];
    vProgram.pt_target=[stringValues objectAtIndex:7];
    vProgram.pic_logo=[stringValues objectAtIndex:8];
    vProgram.pic_front=[stringValues objectAtIndex:9];
    vProgram.pic_back=[stringValues objectAtIndex:10];
    vProgram.com_id=[stringValues objectAtIndex:11];
    vProgram.com_name=[stringValues objectAtIndex:12];
    vProgram.com_web1=[stringValues objectAtIndex:13];
    vProgram.com_web2=[stringValues objectAtIndex:14];
    vProgram.com_phone=[stringValues objectAtIndex:15];
    vProgram.com_email = [stringValues objectAtIndex:16];
    //    vProgram.lat = [stringValues objectAtIndex:17];
    //    vProgram.lng= [stringValues objectAtIndex:18];
    vProgram.u=@"";
    vProgram.c=@"";
    vProgram.pins = @"";
    NSLog(@"COUNT=%i",[stringValues count]);
    if([stringValues count]>20 && [[stringValues objectAtIndex:19] isEqualToString:@""]==NO) // This check needs to be changed to greater than value check
    {
        NSDate *current = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd-MM-yyyy hh:mm:ss a"];
        NSString *stringDTStamp = [formatter stringFromDate:current];
        
        vProgram.rt =[stringValues objectAtIndex:19];
        vProgram.s_dt = stringDTStamp;
        
    }
    else
    {
        vProgram.s_dt = @"";
        vProgram.rt = @"";
    }
    
    if([stringValues count]>=21) // Check if new node for fb_status is available or not.
    {
        vProgram.fbstatus = [stringValues objectAtIndex:20];
    }
    else
    {
        vProgram.fbstatus = @"";
    }
    
    
    
    //vProgram.
    getCouponCode = NO;
    BusinessLayer *businessObject = [[BusinessLayer alloc]init];
    
    if([vProgram.rt isEqualToString:@""]==NO) // only check if delay parameter has a value.
    {
        if([businessObject ValidateProgramScan:vProgram]==NO)
        {
            NSLog(@"DELAY WORKING");
            NSString *msg = @"Program has been scanned too frequently then the allowed frequency. Please try later.";
            UIAlertView *alertViewLocations = [[UIAlertView alloc]initWithTitle:@"LoyalAZ" message:msg delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
            [alertViewLocations show];
            [alertViewLocations release];
            return;
        }
    }
    
    if([stringValues count]==23) // check if value for spt node exists.
    {
        vProgram.spt = [stringValues objectAtIndex:22];
    }
    else
    {
        vProgram.spt = @"";
    }
    
    int target_points = 0;
    int balance_points = 0;
    target_points = [vProgram.pt_target intValue];
    balance_points = [vProgram.pt_balance intValue];
    
    
    if(balance_points<target_points)
    {
        NSString *newbalance = [businessObject UpdateProgramBalance:vProgram]; //get the new balance as string
        vProgram.pt_balance = newbalance;
        
        balance_points = [newbalance intValue];
        NSLog(@"BALANCE=%i",balance_points);
        //NSLog(@"Total programs at scan= %d",appObject.loyalaz.programs.count);
        
        if(balance_points==-1)
        {
            NSString *message = [[NSString alloc]initWithFormat:@"This program is already pending for redemption. Click this program to redeem."];
            UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [av show];
            [av release];
            [message release];
        }
        else if(balance_points<target_points)
        {
            NSString *message = [[NSString alloc]initWithFormat:@"Congratulations! You now have %@ rewards. Your reward target is %@",newbalance,vProgram.pt_target];
            UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            av.tag=3;
            [av show];
            [av release];
            
            [self SetupArrays];
            [tableViewPrograms reloadData];
            [tableViewPrograms reloadSectionIndexTitles];
            
            self.postParams =
            [[NSMutableDictionary alloc] initWithObjectsAndKeys:
             @"http://www.loyalaz.com/newapp/", @"link",
             nil];
            
            NSString *FBMessage = nil;
            
            FBMessage = [[NSString alloc]initWithFormat:@"I've just collected a reward point at %@, %@ using www.LoyalAZ.com",[vProgram.com_name stringByRemovingPercentEncoding],vProgram.com_web2];
            [self.postParams setObject:FBMessage forKey:@"message"];
            
            if([vProgram.fbstatus isEqualToString:@""]==NO)
            {
                FBMessage = [vProgram.fbstatus stringByRemovingPercentEncoding];
                [self.postParams setObject:FBMessage forKey:@"caption"];
            }
            else
            {
                [self.postParams setObject:@"LoyalAZ Loyalty Reward System - An ultimate loyalty program that saves money, gives best rewards in the shortest period of time to the customer AND helps retailers and local businesses to build a loyal client base - cost-effectively and with minimum fuss." forKey:@"caption"];
            }
            
            
            
            //            if([appObject.loyalaz.enableFBPost isEqualToString:@""])
            //            {
            //                NSLog(@"No value set for enable FB posts");
            //                NSString *FBPrompt = [[NSString alloc]initWithFormat:@"Also check-in and post about it to your Facebook Wall?"];
            //                UIAlertView *avFB = [[UIAlertView alloc]initWithTitle:@"" message:FBPrompt delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
            //                avFB.tag=2;
            //                [avFB show];
            //            }
            if([appObject.loyalaz.enableFBPost isEqualToString:@"1"])
            {
                [self MakeFBCall];
            }
            
        }
        else if(balance_points == target_points )
        {
            couponProgram = vProgram;
            if([Helper IsInternetAvailable]==YES)
            {
                getCouponCode = YES;
                tempCompanyName = vProgram.com_name;
                businessObject.coupondelegate = self;
                [businessObject GetCouponNumber:appObject.loyalaz.user.uid withProgram:vProgram];
                
                self.postParams =
                [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                 @"http://www.loyalaz.com/newapp/", @"link",
                 nil];
                
                NSString *FBMessage = nil;
                
                FBMessage = [[NSString alloc]initWithFormat:@"I've just collected a reward point at %@, %@ using www.LoyalAZ.com",[vProgram.com_name stringByRemovingPercentEncoding],vProgram.com_web2];
                [self.postParams setObject:FBMessage forKey:@"message"];
                
                if([vProgram.fbstatus isEqualToString:@""]==NO)
                {
                    FBMessage = [vProgram.fbstatus stringByRemovingPercentEncoding];
                    [self.postParams setObject:FBMessage forKey:@"caption"];
                }
                else
                {
                    [self.postParams setObject:@"LoyalAZ Loyalty Reward System - An ultimate loyalty program that saves money, gives best rewards in the shortest period of time to the customer AND helps retailers and local businesses to build a loyal client base - cost-effectively and with minimum fuss." forKey:@"caption"];
                }
                
                if([appObject.loyalaz.enableFBPost isEqualToString:@"1"])
                {
                    [self MakeFBCall];
                }
                
            }
            else
            {
                NSString *message = [[NSString alloc]initWithFormat:@"Internet connection is required to receive the Coupon Number. Please click on this Program when internet connection is available."];
                UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [av show];
                [av release];
                [message release];
                couponProgram.coupon_no = @"";
                BusinessLayer *businessObject = [[BusinessLayer alloc]init];
                [businessObject UpdateProgramActState:couponProgram];
            }
        }
    }
}

-(void)ProcessPerItemProgramType:(NSString *)scannedString
{
    NSArray *stringValues = [scannedString componentsSeparatedByString:@"+"];
    
    Program *vProgram = [[Program alloc]init];
    vProgram.id=[stringValues objectAtIndex:1];
    vProgram.pid=[stringValues objectAtIndex:2];
    vProgram.name=[stringValues objectAtIndex:3];
    vProgram.tagline=[stringValues objectAtIndex:4];
    //vProgram.description=[stringValues objectAtIndex:4];
    vProgram.type=[stringValues objectAtIndex:6];
    vProgram.pt_target=[stringValues objectAtIndex:7];
    vProgram.pic_logo=[stringValues objectAtIndex:8];
    vProgram.pic_front=[stringValues objectAtIndex:9];
    vProgram.pic_back=[stringValues objectAtIndex:10];
    vProgram.com_id=[stringValues objectAtIndex:11];
    vProgram.com_name=[stringValues objectAtIndex:12];
    vProgram.com_web1=[stringValues objectAtIndex:13];
    vProgram.com_web2=[stringValues objectAtIndex:14];
    vProgram.com_phone=[stringValues objectAtIndex:15];
    vProgram.com_email = [stringValues objectAtIndex:16];
//    vProgram.lat = [stringValues objectAtIndex:17];
//    vProgram.lng= [stringValues objectAtIndex:18];
    vProgram.u=@"";
    vProgram.c=@"";
    vProgram.pins = @"";
    NSLog(@"COUNT=%i",[stringValues count]);
    if([stringValues count]>20 && [[stringValues objectAtIndex:19] isEqualToString:@""]==NO) // This check needs to be changed to greater than value check
    {
        NSDate *current = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd-MM-yyyy hh:mm:ss a"];
        NSString *stringDTStamp = [formatter stringFromDate:current];
        
        vProgram.rt =[stringValues objectAtIndex:19];
        vProgram.s_dt = stringDTStamp;
        
    }
    else
    {
        vProgram.s_dt = @"";
        vProgram.rt = @"";
    }
    
    if([stringValues count]>=21) // Check if new node for fb_status is available or not.
    {
        vProgram.fbstatus = [stringValues objectAtIndex:20];
    }
    else
    {
        vProgram.fbstatus = @"";
    }
    
    
    
    //vProgram.
    getCouponCode = NO;
    BusinessLayer *businessObject = [[BusinessLayer alloc]init];
    
    if([vProgram.rt isEqualToString:@""]==NO) // only check if delay parameter has a value.
    {
        if([businessObject ValidateProgramScan:vProgram]==NO)
        {
            NSLog(@"DELAY WORKING");
            NSString *msg = @"Program has been scanned too frequently then the allowed frequency. Please try later.";
            UIAlertView *alertViewLocations = [[UIAlertView alloc]initWithTitle:@"LoyalAZ" message:msg delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
            [alertViewLocations show];
            [alertViewLocations release];
            return;
        }
    }
    
    if([stringValues count]==23) // check if value for spt node exists.
    {
        vProgram.spt = [stringValues objectAtIndex:22];
    }
    else
    {
        vProgram.spt = @"";
    }
    
    int target_points = 0;
    int balance_points = 0;
    target_points = [vProgram.pt_target intValue];
    balance_points = [vProgram.pt_balance intValue];
    
    
    if(balance_points<target_points)
    {
        NSString *newbalance = [businessObject UpdateProgramBalance:vProgram]; //get the new balance as string
        vProgram.pt_balance = newbalance;
        
        balance_points = [newbalance intValue];
        NSLog(@"BALANCE=%i",balance_points);
        //NSLog(@"Total programs at scan= %d",appObject.loyalaz.programs.count);
        
        if(balance_points==-1)
        {
            NSString *message = [[NSString alloc]initWithFormat:@"This program is already pending for redemption. Click this program to redeem."];
            UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [av show];
            [av release];
            [message release];
        }
        else if(balance_points<target_points)
        {
            NSString *message = [[NSString alloc]initWithFormat:@"Congratulations! You now have %@ rewards. Your reward target is %@",newbalance,vProgram.pt_target];
            UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            av.tag=3;
            [av show];
            [av release];
            
            [self SetupArrays];
            [tableViewPrograms reloadData];
            [tableViewPrograms reloadSectionIndexTitles];
            
            self.postParams =
            [[NSMutableDictionary alloc] initWithObjectsAndKeys:
             @"http://www.loyalaz.com/newapp/", @"link",
             nil];
            
            NSString *FBMessage = nil;
            
            FBMessage = [[NSString alloc]initWithFormat:@"I've just collected a reward point at %@, %@ using www.LoyalAZ.com",[vProgram.com_name stringByRemovingPercentEncoding],vProgram.com_web2];
            [self.postParams setObject:FBMessage forKey:@"message"];
            
            if([vProgram.fbstatus isEqualToString:@""]==NO)
            {
                FBMessage = [vProgram.fbstatus stringByRemovingPercentEncoding];
                [self.postParams setObject:FBMessage forKey:@"caption"];
            }
            else
            {
                [self.postParams setObject:@"LoyalAZ Loyalty Reward System - An ultimate loyalty program that saves money, gives best rewards in the shortest period of time to the customer AND helps retailers and local businesses to build a loyal client base - cost-effectively and with minimum fuss." forKey:@"caption"];
            }
            
            
            
            //            if([appObject.loyalaz.enableFBPost isEqualToString:@""])
            //            {
            //                NSLog(@"No value set for enable FB posts");
            //                NSString *FBPrompt = [[NSString alloc]initWithFormat:@"Also check-in and post about it to your Facebook Wall?"];
            //                UIAlertView *avFB = [[UIAlertView alloc]initWithTitle:@"" message:FBPrompt delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
            //                avFB.tag=2;
            //                [avFB show];
            //            }
            if([appObject.loyalaz.enableFBPost isEqualToString:@"1"])
            {
                [self MakeFBCall];
            }
            
        }
        else if(balance_points == target_points )
        {
            couponProgram = vProgram;
            if([Helper IsInternetAvailable]==YES)
            {
                getCouponCode = YES;
                tempCompanyName = vProgram.com_name;
                businessObject.coupondelegate = self;
                [businessObject GetCouponNumber:appObject.loyalaz.user.uid withProgram:vProgram];
                
                self.postParams =
                [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                 @"http://www.loyalaz.com/newapp/", @"link",
                 nil];
                
                NSString *FBMessage = nil;
                
                FBMessage = [[NSString alloc]initWithFormat:@"I've just collected a reward point at %@, %@ using www.LoyalAZ.com",[vProgram.com_name stringByRemovingPercentEncoding],vProgram.com_web2];
                [self.postParams setObject:FBMessage forKey:@"message"];
                
                if([vProgram.fbstatus isEqualToString:@""]==NO)
                {
                    FBMessage = [vProgram.fbstatus stringByRemovingPercentEncoding];
                    [self.postParams setObject:FBMessage forKey:@"caption"];
                }
                else
                {
                    [self.postParams setObject:@"LoyalAZ Loyalty Reward System - An ultimate loyalty program that saves money, gives best rewards in the shortest period of time to the customer AND helps retailers and local businesses to build a loyal client base - cost-effectively and with minimum fuss." forKey:@"caption"];
                }
                
                if([appObject.loyalaz.enableFBPost isEqualToString:@"1"])
                {
                    [self MakeFBCall];
                }
                
            }
            else
            {
                NSString *message = [[NSString alloc]initWithFormat:@"Internet connection is required to receive the Coupon Number. Please click on this Program when internet connection is available."];
                UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [av show];
                [av release];
                [message release];
                couponProgram.coupon_no = @"";
                BusinessLayer *businessObject = [[BusinessLayer alloc]init];
                [businessObject UpdateProgramActState:couponProgram];
            }
        }
    }

}

-(void)ProcessSavingProgramType:(NSString *)scannedString
{
    NSArray *stringValues = [scannedString componentsSeparatedByString:@"+"];
    
    Program *vProgram = [[Program alloc]init];
    vProgram.id=[stringValues objectAtIndex:1];
    vProgram.pid=[stringValues objectAtIndex:2];
    vProgram.name=[stringValues objectAtIndex:3];
    vProgram.tagline=[stringValues objectAtIndex:4];
    //vProgram.description=[stringValues objectAtIndex:4];
    vProgram.type=[stringValues objectAtIndex:6];
    vProgram.pt_target=[stringValues objectAtIndex:7];
    vProgram.pic_logo=[stringValues objectAtIndex:8];
    vProgram.pic_front=[stringValues objectAtIndex:9];
    vProgram.pic_back=[stringValues objectAtIndex:10];
    vProgram.com_id=[stringValues objectAtIndex:11];
    vProgram.com_name=[stringValues objectAtIndex:12];
    vProgram.com_web1=[stringValues objectAtIndex:13];
    vProgram.com_web2=[stringValues objectAtIndex:14];
    vProgram.com_phone=[stringValues objectAtIndex:15];
    vProgram.com_email = [stringValues objectAtIndex:16];
    vProgram.u=@"";
    vProgram.c=@"";
    NSLog(@"COUNT=%i",[stringValues count]);
    if([stringValues count]>20 && [[stringValues objectAtIndex:19] isEqualToString:@""]==NO) // This check needs to be changed to greater than value check
    {
        NSDate *current = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd-MM-yyyy hh:mm:ss a"];
        NSString *stringDTStamp = [formatter stringFromDate:current];
        
        vProgram.rt =[stringValues objectAtIndex:19];
        vProgram.s_dt = stringDTStamp;
        
    }
    else
    {
        vProgram.s_dt = @"";
        vProgram.rt = @"";
    }
    
    if([stringValues count]>=21) // Check if new node for fb_status is available or not.
    {
        vProgram.fbstatus = [stringValues objectAtIndex:20];
    }
    else
    {
        vProgram.fbstatus = @"";
    }
    
    if([stringValues count]>=22) // check if new node for pins is available or not.
    {
        vProgram.pins = [stringValues objectAtIndex:21];
    }
    else
    {
        vProgram.pins = @"";
    }
    
    if([stringValues count]==23) // check if value for spt node exists.
    {
        NSLog(@"SPT=%@",[stringValues objectAtIndex:22]);
        vProgram.spt = [stringValues objectAtIndex:22];
    }
    else
    {
        vProgram.spt = @"";
    }

    flagMsgShown = NO;
    BusinessLayer *businessLayer = [[BusinessLayer alloc]init];
//    if([businessLayer IsProgramExistsWithLocation:vProgram.pid withLocation:vProgram.com_id]==NO)
    if([businessLayer IsProgramExists:vProgram.pid]==NO)
    {
        // Ask for password
        flagRecharge=NO;
        flagMsgShown = YES;
        savingProgram = vProgram;
        NSString *message = [[NSString alloc]initWithFormat:@"To recharge or load your SAVINGS card – please show your handset to staff member for validation"];
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"LoyalAZ" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
        av.tag = 5;
        [av show];
        [av release];
        [message release];
//        PasscodeVC *passcodeVC = [[PasscodeVC alloc]initWithNibName:@"PasscodeVC" bundle:nil withProgram:vProgram];
//        passcodeVC.delegate = self;
//        [self presentViewController:passcodeVC animated:YES completion:nil];
    }
    else
    {
        if([businessLayer IsProgramReachedRechargeLevel:vProgram.pid withLocation:vProgram.com_id]==YES)
        {
            flagRecharge=YES;
            flagMsgShown = YES;
            savingProgram = vProgram;
            NSString *message = [[NSString alloc]initWithFormat:@"To recharge or load your SAVINGS card – please show your handset to staff member for validation"];
            UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"LoyalAZ" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
            av.tag = 5;
            [av show];
            [av release];
            [message release];

//            PasscodeVC *passcodeVC = [[PasscodeVC alloc]initWithNibName:@"PasscodeVC" bundle:nil withProgram:vProgram];
//            passcodeVC.delegate = self;
//            [self presentViewController:passcodeVC animated:YES completion:nil];
        }
        else
        {
            [self UpdateSavingTypeProgram:vProgram];
        }
        
    }

    
    //vProgram.
    getCouponCode = NO;
    
    
    if([vProgram.rt isEqualToString:@""]==NO) // only check if delay parameter has a value.
    {
        BusinessLayer *businessObject = [[BusinessLayer alloc]init];
        if([businessObject ValidateProgramScan:vProgram]==NO)
        {
            NSLog(@"DELAY WORKING");
            NSString *msg = @"Program has been scanned too frequently then the allowed frequency. Please try later.";
            UIAlertView *alertViewLocations = [[UIAlertView alloc]initWithTitle:@"LoyalAZ" message:msg delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
            [alertViewLocations show];
            [alertViewLocations release];
            return;
        }
        
    }
    
}

-(void)UpdateSavingTypeProgram:(Program *)program
{
    BusinessLayer *businessObject = [[BusinessLayer alloc]init];
    int target_points = 0;
    int balance_points = 0;
    target_points = [program.pt_target intValue];
    balance_points = [program.pt_balance intValue];
    
    NSString *newbalance = [businessObject UpdateSavingTypeProgramBalance:program]; //get the new balance as string
    NSLog(@"BALA=%@",newbalance);
    if([newbalance isEqualToString:@"0"])
    {
        NSLog(@"Reached the limit. Please recharge.");
        NSString *msg = @"Program has reached to 0 balance, Kindly recharge.";
        UIAlertView *avLimit = [[UIAlertView alloc]initWithTitle:@"LoyalAZ" message:msg delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
        [avLimit show];
        [avLimit release];
        
    }
    else
    {
        if(flagMsgShown==NO)
        {
            NSString *message = [[NSString alloc]initWithFormat:@"Successfully used one savings point."];
            UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"LoyalAZ" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [av show];
            [av release];
            [message release];
        }

    }
    [tableViewPrograms reloadData];

}

-(void)MakeFBCall
{
    if (FBSession.activeSession.isOpen==NO) //Means the user is not logged in.
    {
//        postToFBWallPending = YES;
        [self doFBLogin];
    }
    else // User is logged in and have the permissions to post to wall.
    {
        postToFBWallPending = NO;
        if([Helper IsInternetAvailable]==YES)
        {
            [self PostToFBWall];
        }

    }
}


- (void)ScanDidCancelled
{
    [self ShowActivityView];
}


#pragma mark - Business Layer Delegates

- (void)BusinessLayerErrorOccurred:(NSError *)err
{
    //NSLog(@"Error occurred, can't move further.");
}

-(void)BusinessLayerDidFinish:(BOOL)result
{
    if(flagProgramDelete==YES && result==YES)
    {
        flagProgramDelete = NO;
//        appObject = [Application applicationManager];
//        [appObject.loyalaz.programs removeObject:programToDelete];
//        [Helper SaveObjectToDB:appObject.loyalaz];
        
        BusinessLayer *businessObject = [[BusinessLayer alloc]init];
        [businessObject DeleteProgramFromXML:programToDelete];
        
        [self SetupArrays];
        
        //[tableViewPrograms deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPathToDelete, nil] withRowAnimation:UITableViewRowAnimationTop];
        [tableViewPrograms reloadData];
        
    }
}

#pragma mark - AlertView Delegates

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag==1)
    {
        //NSLog(@"Index clicked:%@",buttonIndex);
        if(buttonIndex==0)
        {
            [self ProcessRedeem];
        }
        else if(buttonIndex==1)
        {
            // Save the state
            BusinessLayer *businessObject = [[BusinessLayer alloc]init];
            [businessObject UpdateProgramActState:couponProgram];
        }
    }
    else if(actionSheet.tag==2)
    {
        if(buttonIndex==0)
        {
            appObject.loyalaz.enableFBPost = @"0"; // Disallow FB Post
        }
        else if(buttonIndex==1)
        {
            appObject.loyalaz.enableFBPost = @"1"; // Enable FB Post
            [self MakeFBCall];
        }
        [Helper SaveObjectToDB:appObject.loyalaz];
    }
    else if(actionSheet.tag==3)
    {
        if([appObject.loyalaz.enableFBPost isEqualToString:@""])
        {
            NSString *FBPrompt = [[NSString alloc]initWithFormat:@"Also check-in and post about it to your Facebook Wall?"];
            UIAlertView *avFB = [[UIAlertView alloc]initWithTitle:@"" message:FBPrompt delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
            avFB.tag=2;
            [avFB show];
        }
    }
    else if(actionSheet.tag==4)
    {
        if(buttonIndex==1)
        {
            BusinessLayer *businessObject = [[BusinessLayer alloc]init];
            businessObject.delegate = self;
            flagProgramDelete = YES;
            [businessObject RemoveProgram:programToDelete];
        }
    }
    else if(actionSheet.tag==5)
    {
        if(buttonIndex==0)
        {
            PasscodeVC *passcodeVC = [[PasscodeVC alloc]initWithNibName:@"PasscodeVC" bundle:nil withProgram:savingProgram];
            passcodeVC.delegate = self;
            [self presentViewController:passcodeVC animated:YES completion:nil];
        }
    }


}

#pragma mark - Coupon Methods


- (void)CouponCodeFinishedWithCouponCode:(BOOL)result withCouponCode:(NSString *)couponCode
{
    
    if(result==YES)
    {
        if(getCouponCode==YES)
        {
            getCouponCode = NO;
            NSMutableString *message = [[NSMutableString alloc]initWithFormat:@"Congratulation you earned FREE reward at %@ your coupon number is  %@",tempCompanyName,couponCode];
            [message appendString:@"\nShow staff to redeem now?"];
            couponProgram.coupon_no = couponCode;
            UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"" message:message delegate:self cancelButtonTitle:@"Verified" otherButtonTitles:@"Not Now", nil];
            av.tag=1;
            [av show];
            [av release];
            [message release];
        }
    }
}


- (void) ProcessRedeem
{
    if([Helper IsInternetAvailable]==YES)
    {
        getCouponCode = NO;
        BusinessLayer *businessObject = [[BusinessLayer alloc]init];
        businessObject.coupondelegate = self;
        [businessObject ProcessRedeem:appObject.loyalaz.user.uid withProgram:couponProgram];
    }
    else
    {
        NSString *message = [[NSString alloc]initWithFormat:@"Internet connection is required to redeemp the Coupon. Please click on this Program when internet connection is available."];
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [av show];
        [av release];
        [message release];
    }

}

-(void)CouponRedeemCompleted:(BOOL)result
{
    if(result)
    {
        BusinessLayer *businessObject = [[BusinessLayer alloc]init];
        [businessObject UpdateProgramRedeemed:couponProgram];
        
        NSMutableString *message = [[NSMutableString alloc]initWithFormat:@"Coupon redeemed successfully"];
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [av show];
        [av release];
        [message release];

        [tableViewPrograms reloadData];
    }
    else {
        //NSLog(@"Some error in redeeming coupon.");
    }
}

-(void)PasscodeVerified:(Program *)prg
{
    if(flagRecharge==NO)
        [self UpdateSavingTypeProgram:prg];
    else
    {
        BusinessLayer *businessLayer = [[BusinessLayer alloc]init];
        [businessLayer RechargeSavingTypeProgram:prg];
        [tableViewPrograms reloadData];
    }
}

-(void)PasscodeDidCancelled
{
    NSMutableString *message = [[NSMutableString alloc]initWithFormat:@"Confirmation cancelled."];
    UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"LoyalAZ" message:message delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
    [av show];
    [av release];
    [message release];

}



@end
