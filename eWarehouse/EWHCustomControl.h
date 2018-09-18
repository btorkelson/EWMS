//
//  EWHCustomControl.h
//  eWarehouse
//
//  Created by Brian Torkelson on 9/11/18.
//
//

#import <Foundation/Foundation.h>

@interface EWHCustomControl : NSObject {
    NSInteger ControlType;
    NSInteger CustomControlId;
    NSString *CustomControlName;
    NSString *DefaultValue;
    NSString *LabelCaption;
    NSString *ErrorMessage;
    NSInteger MaxLength;
    BOOL ReadOnly;
    BOOL Required;
    BOOL Visible;
}

@property (assign, nonatomic) NSInteger ControlType;
@property (assign, nonatomic) NSInteger CustomControlId;
@property (nonatomic, retain) NSString *CustomControlName;
@property (nonatomic, retain) NSString *DefaultValue;
@property (nonatomic, retain) NSString *ErrorMessage;
@property (nonatomic, retain) NSString *LabelCaption;
@property (assign, nonatomic) NSInteger MaxLength;
@property (nonatomic) BOOL ReadOnly;
@property (nonatomic) BOOL Required;
@property (nonatomic) BOOL Visible;

- (EWHCustomControl *)initWithDictionary:(NSDictionary *)dictionary;

@end
