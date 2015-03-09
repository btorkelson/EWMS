//
//  EWHAppDelegate.h
//  eWarehouse
//
//  Created by Zbigniew Kisiel on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EWHAppDelegateProtocal.h"

@class EWHStartViewController;
@class EWHNewReceiptDataObject;

@interface EWHAppDelegate : UIResponder <UIApplicationDelegate, AppDelegateProtocol>
{
    EWHNewReceiptDataObject* theAppDataObject;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) EWHNewReceiptDataObject* theAppDataObject;

@end
