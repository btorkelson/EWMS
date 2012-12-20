//
//  EWHUtils.h
//  eWarehouse
//
//  Created by Zbigniew Kisiel on 8/16/12.
//
//

#import <Foundation/Foundation.h>

@interface EWHUtils : NSObject

+ (NSDateFormatter *) dateFormatter;
+ (NSDate *)mfDateFromDotNetJSONString:(NSString *)string;

@end
