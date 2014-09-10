//
//  DisplayMap.m
//  MapKitDisplay
//
//  Created by Chakra on 12/07/10.
//  Copyright 2010 Chakra Interactive Pvt Ltd. All rights reserved.
//

#import "DisplayMap.h"


@implementation DisplayMap

@synthesize coordinate,title,subtitle;
@synthesize mProgramObject,programObject;
@synthesize indexNumber;


-(void)dealloc{
	[title release];
	[super dealloc];
}

@end
