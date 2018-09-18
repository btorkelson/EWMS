//
//  EWHCustomControl.m
//  eWarehouse
//
//  Created by Brian Torkelson on 9/11/18.
//
//

#import "EWHCustomControl.h"

@implementation EWHCustomControl

@synthesize ControlType;
@synthesize CustomControlId;
@synthesize CustomControlName;
@synthesize DefaultValue;
@synthesize LabelCaption;
@synthesize ReadOnly;
@synthesize Required;
@synthesize Visible;
@synthesize ErrorMessage;
@synthesize MaxLength;


- (EWHCustomControl *)initWithDictionary:(NSDictionary *)dictionary {
    ControlType = [[dictionary objectForKey:@"ControlType"] intValue];
    CustomControlId = [[dictionary objectForKey:@"CustomControlId"] intValue];
    CustomControlName = [dictionary objectForKey:@"CustomControlName"];
    DefaultValue = [dictionary objectForKey:@"DefaultValue"];
    ErrorMessage = [dictionary objectForKey:@"ErrorMessage"];
    LabelCaption = [dictionary objectForKey:@"LabelCaption"];
    MaxLength = [[dictionary objectForKey:@"MaxLength"] intValue];
    ReadOnly = [[dictionary objectForKey:@"ReadOnly"] boolValue];
    Required = [[dictionary objectForKey:@"Required"] boolValue];
    Visible = [[dictionary objectForKey:@"Visible"] boolValue];
    return [super init];
}


@end
