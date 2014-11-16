//
//  SelectCountryVC.m
//  LoyalAZ
//

#import "SelectCountryVC.h"

@interface SelectCountryVC ()

@end

@implementation SelectCountryVC

@synthesize tableViewCountry;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil countryName:(NSString *)countryNameOrNil
{
    prevCountryName =countryNameOrNil;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSString *countriesXML = [Helper GetCountriesXML];
    countriesObject = [XMLParser XmlToObject:countriesXML];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    [self.tableViewCountry release];
    [super dealloc];
}
- (IBAction)selectClicked:(id)sender {
    [self.delegate SelectCountryDidFinish:selectedCountry];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelClicked:(id)sender {
    [self.delegate SelectCountryDidCancelled];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return countriesObject.countries.count;
}


//-(NSString *)tableView :(UITableView*)theTableView titleForHeaderInSection:(NSInteger)section
//{
//    return @"Select Country";
//}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    Country *tmpCountry =[countriesObject.countries objectAtIndex:indexPath.row];
    
    if([prevCountryName isEqualToString:tmpCountry.name])
    {
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    cell.textLabel.text = tmpCountry.name;
    cell.detailTextLabel.text = tmpCountry.code;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Country *tmpCountry =[countriesObject.countries objectAtIndex:indexPath.row];
    UITableViewCell *cell;
    NSLog(@"Selected=%@",tmpCountry.name);
    
//    if(prevIndexPath)
//    {
//        cell = (UITableViewCell *) [tableView cellForRowAtIndexPath:prevIndexPath];
//        [cell setAccessoryType:UITableViewCellAccessoryNone];
//    }
    
    prevIndexPath = indexPath;
    cell = (UITableViewCell *) [tableView cellForRowAtIndexPath:indexPath];
//    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    selectedCountry = tmpCountry;
    [cell release];
    
}
@end
