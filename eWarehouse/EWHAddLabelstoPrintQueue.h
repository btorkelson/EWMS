//
//  CMSAddLabelstoPrintQueue.h
//  CMS Driver
//
//  Created by Brian Torkelson on 5/6/14.
//  Copyright (c) 2014 eWMS. All rights reserved.
//


#import "EWHRequestAF.h"

@interface EWHAddLabelstoPrintQueue : EWHRequestAF

- (void)AddLabelPrintQueue:(NSInteger)receiptId itemId:(NSInteger)itemId user:(EWHUser *)user;

@end
