//
//  DisplayMap.h
//  MapKitDisplay
//
//  Created by Chakra on 12/07/10.
//  Copyright 2010 Chakra Interactive Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>
#import "Program.h"
#import "MProgram.h"

@interface DisplayMap : NSObject <MKAnnotation> {

	CLLocationCoordinate2D coordinate; 
	NSString *title; 
	NSString *subtitle;
    Program *programObject;
    MProgram *mProgramObject;
    int indexNumber;
}

@property (nonatomic, assign) CLLocationCoordinate2D coordinate; 
@property (nonatomic, copy) NSString *title; 
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) Program *programObject;
@property (nonatomic, copy) MProgram *mProgramObject;
@property (nonatomic,assign) int indexNumber;

@end
