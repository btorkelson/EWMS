//
//  EWHCustomAttributeCatalog.m
//  eWarehouse
//
//  Created by Brian Torkelson on 10/14/14.
//
//

#import "EWHCustomAttributeCatalog.h"

@implementation EWHCustomAttributeCatalog

@synthesize CustomAttributeCatalogId;
@synthesize Value;
@synthesize Name;
@synthesize Editable;
@synthesize Required;
@synthesize ErrorMessage;
@synthesize CustomControlType;
@synthesize OptionListString;

- (EWHCustomAttributeCatalog *)initWithDictionary:(NSDictionary *)dictionary {
    CustomAttributeCatalogId = [[dictionary objectForKey:@"CustomAttributeCatalogId"] intValue];
    Value = [dictionary objectForKey:@"Value"];
    Name = [dictionary objectForKey:@"Name"];
    Editable = [[dictionary objectForKey:@"Editable"] boolValue];
    Required = [[dictionary objectForKey:@"Required"] boolValue];
    ErrorMessage = [dictionary objectForKey:@"ErrorMessage"];
    CustomControlType = [[dictionary objectForKey:@"CustomControlType"] intValue];
    OptionListString = [dictionary objectForKey:@"OptionListString"];
    return [super init];
}

@end
