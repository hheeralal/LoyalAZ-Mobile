//
//  User.m
//  TestXML
//

#import "User.h"

@implementation User

@synthesize uid,st,name,email,lastname,firstname;
@synthesize addresscity,mobilephone,addressstreet,addresssuburb,addresscountry;
-(void)dealloc
{
    [st release];
    [name release];
    [lastname release];
    [firstname release];
    [addresscity release];
    [mobilephone release];
    [addressstreet release];
    [addresssuburb release];
    [uid release];
    [addresscountry release];
    
    st = nil;
    name = nil;
    lastname = nil;
    firstname = nil;
    addresscity = nil;
    mobilephone = nil;
    addressstreet = nil;
    addresssuburb = nil;
    uid = nil;
    addresscountry = nil;
    dtoken = nil;
    
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        //programs = [[NSMutableArray alloc]init];
        st = @"";
        name = @"";
        lastname = @"";
        firstname = @"";
        addresscity = @"";
        mobilephone = @"";
        addressstreet = @"";
        addresssuburb = @"";
        uid = @"";
        addresscountry = @"";
        dtoken = @"";
    }
    return self;
}

@end
