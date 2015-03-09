//
//  EWHProgram.m
//  eWarehouse
//
//  Created by Brian Torkelson on 1/30/14.
//
//

#import "EWHProgram.h"

@implementation EWHProgram
@synthesize ProgramId;
@synthesize Name;
@synthesize IsContainer;
@synthesize IsStrictCatalog;
@synthesize IsLateReceipt;
@synthesize IsReceiptToOrder;
@synthesize IsCaptureOrigin;

- (EWHProgram *)initWithDictionary:(NSDictionary *)dictionary {
    ProgramId = [[dictionary objectForKey:@"ProgramId"] intValue];
    Name = [[NSString alloc] initWithString:[dictionary objectForKey:@"ProgramName"]];
    IsContainer = [[dictionary objectForKey:@"IsContainer"] intValue];
    IsStrictCatalog = [[dictionary objectForKey:@"IsStrictCatalog"] intValue];
    IsLateReceipt = [[dictionary objectForKey:@"IsLateReceipt"] intValue];
    IsReceiptToOrder = [[dictionary objectForKey:@"IsReceiptToOrder"] intValue];
    IsCaptureOrigin = [[dictionary objectForKey:@"IsCaptureOrigin"] intValue];
    return [super init];

}

@end
