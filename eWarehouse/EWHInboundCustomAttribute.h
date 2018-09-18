//
//  EWHInboundCustomAttribute.h
//  eWarehouse
//
//  Created by Brian Torkelson on 9/13/18.
//
//

#import <Foundation/Foundation.h>

@interface EWHInboundCustomAttribute : NSObject {
    NSInteger CustomAttributeId;
    NSInteger CustomControlType;
    NSString *DefaultValue;
    NSString *Value;
    NSString *LabelCaption;
    NSString *ErrorMessage;
    NSString *OptionListString;
    BOOL CheckBoxDefaultValue;
    BOOL CheckBoxValue;
    BOOL ReadOnly;
    BOOL Required;
    BOOL Visible;
}

@property (assign, nonatomic) NSInteger CustomAttributeId;
@property (assign, nonatomic) NSInteger CustomControlType;
@property (nonatomic, retain) NSString *DefaultValue;
@property (nonatomic, retain) NSString *Value;
@property (nonatomic, retain) NSString *LabelCaption;
@property (nonatomic, retain) NSString *ErrorMessage;
@property (nonatomic, retain) NSString *OptionListString;
@property (nonatomic) BOOL CheckBoxDefaultValue;
@property (nonatomic) BOOL CheckBoxValue;
@property (nonatomic) BOOL ReadOnly;
@property (nonatomic) BOOL Required;
@property (nonatomic) BOOL Visible;

- (EWHInboundCustomAttribute *)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary*) toJSON;
@end
