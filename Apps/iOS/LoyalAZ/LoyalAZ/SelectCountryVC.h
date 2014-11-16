//
//  SelectCountryVC.h
//  LoyalAZ
//

#import <UIKit/UIKit.h>
#import "Country.h"
#import "XMLParser.h"
#import "Helper.h"
#import "Countries.h"

@protocol SelectCountryDelegate
@optional
- (void)SelectCountryDidFinish:(Country *)selectedCountry;
- (void)SelectCountryDidCancelled;
@end

@interface SelectCountryVC : UIViewController
{
    Countries *countriesObject;
    NSIndexPath *prevIndexPath;
    Country *selectedCountry;
    NSString *prevCountryName;

}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil countryName:(NSString *)countryNameOrNil;
@property (strong, nonatomic) id <SelectCountryDelegate> delegate;
@property (retain, nonatomic) IBOutlet UITableView *tableViewCountry;
- (IBAction)selectClicked:(id)sender;
- (IBAction)cancelClicked:(id)sender;

@end
