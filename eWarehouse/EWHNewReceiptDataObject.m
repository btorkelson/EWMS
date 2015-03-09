//
//  EWHNewReceiptDataObject.m
//  eWarehouse
//
//  Created by Brian Torkelson on 2/3/14.
//
//

#import "EWHNewReceiptDataObject.h"

@implementation EWHNewReceiptDataObject
@synthesize ProjectName;
@synthesize data1;
@synthesize float1;
@synthesize PromptInventoryType;
@synthesize program;

#pragma mark -
#pragma mark -Memory management methods

- (void)dealloc
{
	//Release any properties declared as retain or copy.
	self.ProjectName = nil;
	self.data1 = nil;
}


- (EWHNewReceiptDataObject *) init {
    ProjectName = nil;
    return self;
}

@end
