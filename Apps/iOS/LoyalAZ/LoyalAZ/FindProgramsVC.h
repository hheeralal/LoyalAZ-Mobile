//
//  FindProgramsVC.h
//  LoyalAZ
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "CustomVC.h"
#import "Application.h"
#import "BusinessLayer.h"
#import "MProgram.h"
//#import "ScanQRCodeVC.h"
#import "MoreProgramDetailsVC.h"
#import "ScanQR.h"
#import "IconDownloader.h"
#import "DisplayMap.h"
#import "ProgramCell.h"

@interface FindProgramsVC : CustomVC <BusinessLayerDelegate,CLLocationManagerDelegate,MKMapViewDelegate>
{
    CLLocationManager *locationManager;
    NSMutableArray *listOfItems;
    NSMutableArray *copyListOfItems;
    NSMutableArray *cellHeight;
    IBOutlet UISearchBar *searchBar;
    BOOL searching;
    BOOL letUserSelectRow;
    IBOutlet UITableView *tableViewPrograms;
    
    Application *appObject;
    
    BOOL searchedOnce;
    
    NSMutableDictionary *dicImages;
    NSString *latValue,*lngValue;
    
    IBOutlet UISegmentedControl* viewType;
    IBOutlet MKMapView *mapView;
    
    NSMutableArray *annArray;

}

-(IBAction) viewTypeChanged:(id)sender;
- (void) searchTableView;
- (void) doneSearching_Clicked:(id)sender;

- (void) buttonCameraClicked:(id)sender;

@end
