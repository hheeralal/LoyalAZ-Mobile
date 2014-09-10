//
//  CouponsVC.h
//  LoyalAZ
//

#import "CustomVC.h"
#import "Application.h"
#import "BusinessLayer.h"
#import "CouponDetailsVC.h"
#import "CustomCell.h"
#import "NSString+HTML.h"
#import "CouponCell.h"

@interface CouponsVC : CustomVC

{
    Application *appObject;
    NSMutableArray *listOfItems;
    NSMutableArray *copyListOfItems;
    IBOutlet UISearchBar *searchBar;
    BOOL searching;
    BOOL letUserSelectRow;
    
    NSString *tempCompanyName;
    
    IBOutlet UITableView *tableViewCoupons;
    
    NSMutableArray *sectionsArray;
	UILocalizedIndexedCollation *collation;
}

@property (nonatomic, retain) NSMutableArray *sectionsArray;
@property (nonatomic, retain) UILocalizedIndexedCollation *collation;

- (void) searchTableView;
- (void) doneSearching_Clicked:(id)sender;
- (void) SetupArrays;
@end
