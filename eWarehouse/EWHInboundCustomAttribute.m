//
//  EWHInboundCustomAttribute.m
//  eWarehouse
//
//  Created by Brian Torkelson on 9/13/18.
//
//

#import "EWHInboundCustomAttribute.h"

@implementation EWHInboundCustomAttribute

@synthesize CustomAttributeId;
@synthesize CustomControlType;
@synthesize DefaultValue;
@synthesize Value;
@synthesize LabelCaption;
@synthesize ErrorMessage;
@synthesize OptionListString;
@synthesize CheckBoxDefaultValue;
@synthesize CheckBoxValue;
@synthesize ReadOnly;
@synthesize Required;
@synthesize Visible;;


- (EWHInboundCustomAttribute *)initWithDictionary:(NSDictionary *)dictionary {
    CustomAttributeId = [[dictionary objectForKey:@"CustomAttributeId"] intValue];
    CustomControlType = [[dictionary objectForKey:@"CustomControlType"] intValue];
    DefaultValue = [dictionary objectForKey:@"DefaultValue"];
    Value = [dictionary objectForKey:@"DefaultValue"];
//    Value = @"";
    ErrorMessage = [dictionary objectForKey:@"ErrorMessage"];
    LabelCaption = [dictionary objectForKey:@"LabelCaption"];
    OptionListString = [dictionary objectForKey:@"OptionListString"];
    CheckBoxDefaultValue = [[dictionary objectForKey:@"CheckBoxDefaultValue"] boolValue];
    CheckBoxValue = [[dictionary objectForKey:@"CheckBoxValue"] boolValue];
    ReadOnly = [[dictionary objectForKey:@"ReadOnly"] boolValue];
    Required = [[dictionary objectForKey:@"Required"] boolValue];
    Visible = [[dictionary objectForKey:@"Visible"] boolValue];
    return [super init];
}

-(NSDictionary*) toJSON {
    return @{
             @"CustomAttributeId": @(self.CustomAttributeId),
             @"CustomControlType": @(self.CustomControlType),
             @"DefaultValue": self.DefaultValue,
             @"Value": self.Value,
             @"LabelCaption": self.LabelCaption,
             @"OptionListString": self.OptionListString,
             @"CheckBoxDefaultValue": @(self.CheckBoxDefaultValue),
             @"CheckBoxValue": @(self.CheckBoxValue),
             @"ReadOnly": @(self.ReadOnly),
             @"Required": @(self.Required),
             @"Visible": @(self.Visible)
             };
}


@end
