//
//  FindCouponsVC.h
//  LoyalAZ
//
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "Application.h"
#import "BusinessLayer.h"
#import "MCoupon.h"
#import "CustomVC.h"
#import "CouponDetailsVC.h"
#import "CouponIconDownloader.h"
#import "DisplayMap.h"
#import "CouponCell.h"

@interface FindCouponsVC : CustomVC <BusinessLayerDelegate,CLLocationManagerDelegate,MKMapViewDelegate>
{
    CLLocationManager *locationManager;
    NSMutableArray *listOfItems;
    NSMutableArray *copyListOfItems;
    IBOutlet UISearchBar *searchBar;
    BOOL searching;
    BOOL letUserSelectRow;
    IBOutlet UITableView *tableViewCoupons;
    
    Application *appObject;
    
    BOOL searchedOnce;
    
    NSMutableArray *sectionsArray;
	UILocalizedIndexedCollation *collation;
    
    IBOutlet UISegmentedControl* viewType;
    IBOutlet MKMapView *mapView;
    
    NSMutableArray *annArray;

}

@property (nonatomic, retain) NSMutableArray *sectionsArray;
@property (nonatomic, retain) UILocalizedIndexedCollation *collation;

-(IBAction) viewTypeChanged:(id)sender;

- (void) searchTableView;
- (void) doneSearching_Clicked:(id)sender;
@end
