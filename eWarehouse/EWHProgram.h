//
//  EWHProgram.h
//  eWarehouse
//
//  Created by Brian Torkelson on 1/30/14.
//
//

#import <Foundation/Foundation.h>

@interface EWHProgram : NSObject {
    NSInteger ProgramId;
    NSString *Name;
    BOOL IsContainer;
    BOOL IsStrictCatalog;
    BOOL IsLateReceipt;
    BOOL IsReceiptToOrder;
    BOOL IsCaptureOrigin;
}
@property (assign, nonatomic) NSInteger ProgramId;
@property (nonatomic, retain) NSString *Name;
@property (assign, nonatomic) BOOL IsContainer;
@property (assign, nonatomic) BOOL IsStrictCatalog;
@property (assign, nonatomic) BOOL IsLateReceipt;
@property (assign, nonatomic) BOOL IsReceiptToOrder;
@property (assign, nonatomic) BOOL IsCaptureOrigin;


- (EWHProgram *)initWithDictionary:(NSDictionary *)dictionary;
@end
