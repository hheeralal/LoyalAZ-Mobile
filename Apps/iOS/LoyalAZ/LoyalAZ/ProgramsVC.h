//
//  ProgramsVC.h
//  LoyalAZ

#import <UIKit/UIKit.h>
#import "CustomVC.h"
//#import "Application.h"
#import "BusinessLayer.h"
#import "Helper.h"
#import "LoyalAZ.h"
#import "ProgramDetailsVC.h"
#import "ScanQR.h"
#import "NSString+HTML.h"
#import "PasscodeVC.h"
#import <MapKit/MapKit.h>
#import "DisplayMap.h"


@interface ProgramsVC : CustomVC <ScanQRDelegate,CouponCodeDelegate,UIAlertViewDelegate,BusinessLayerDelegate,PasscodeVCDelegate,MKMapViewDelegate>
{
    Application *appObject;
    NSMutableArray *listOfItems;
    NSMutableArray *copyListOfItems;
    IBOutlet UISearchBar *searchBar;
    BOOL searching;
    BOOL letUserSelectRow;
    
    BOOL getCouponCode;
    NSString *tempCompanyName;
    Program *couponProgram;
    
    IBOutlet UITableView *tableViewPrograms;
    BOOL StartScan;
    
    
    NSMutableArray *sectionsArray;
	UILocalizedIndexedCollation *collation;
    
    BOOL postToFBWallPending;
    
    NSString *dateFirst;
    NSString *dateSecond;
    BOOL flagCalled;
    Program *programToDelete;
    NSIndexPath *indexPathToDelete;
    BOOL flagProgramDelete;
    BOOL flagRecharge;
    NSString *qrCodeString;
    Program *savingProgram;
    BOOL flagMsgShown;
    

}

    @property (strong, nonatomic) NSMutableDictionary *postParams;
    @property (nonatomic,assign) BOOL StartScan;
    @property (nonatomic, retain) NSMutableArray *sectionsArray;
    @property (nonatomic, retain) UILocalizedIndexedCollation *collation;


- (void) searchTableView;
- (void) doneSearching_Clicked:(id)sender;
- (void) buttonCameraClicked:(id)sender;
- (void) ProcessRedeem;
- (id)initWithNibNameAndCamera:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
- (void) SetupArrays;

@end
