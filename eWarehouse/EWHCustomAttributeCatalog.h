//
//  EWHCustomAttributeCatalog.h
//  eWarehouse
//
//  Created by Brian Torkelson on 10/14/14.
//
//

#import <Foundation/Foundation.h>

@interface EWHCustomAttributeCatalog : NSObject {
    NSInteger CustomAttributeCatalogId;
    NSString *Value;
    NSString *Name;
    BOOL Editable;
    BOOL Required;
    NSString *ErrorMessage;
    NSInteger CustomControlType;
    NSString *OptionListString;
}

@property (assign, nonatomic) NSInteger CustomAttributeCatalogId;
@property (nonatomic, retain) NSString *Value;
@property (nonatomic, retain) NSString *Name;
@property (nonatomic) BOOL Editable;
@property (nonatomic) BOOL Required;
@property (nonatomic, retain) NSString *ErrorMessage;
@property (assign, nonatomic) NSInteger CustomControlType;
@property (nonatomic, retain) NSString *OptionListString;

- (EWHCustomAttributeCatalog *)initWithDictionary:(NSDictionary *)dictionary;

@end
