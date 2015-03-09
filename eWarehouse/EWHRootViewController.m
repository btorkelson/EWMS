//
//  EWHViewController.m
//  eWarehouse
//
//  Created by Zbigniew Kisiel on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EWHRootViewController.h"

@implementation EWHRootViewController

UIActivityIndicatorView *loadingView;


@synthesize user;
@synthesize loginView;

-(void) viewDidLoad{
    loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    loadingView.center = self.view.center;
    loadingView.frame = self.view.frame;
    [self.view addSubview:loadingView];
}

- (void)signOut
{
    self.user = nil;
    [loginView clearForm];
    [self popToRootViewControllerAnimated:FALSE];
}

- (void)showLoading{
    if([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft ||
       [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight)
        loadingView.frame = CGRectMake(0, 0, self.view.window.frame.size.height, self.view.window.frame.size.width);
    else
        loadingView.frame = self.view.window.frame;
    [loadingView startAnimating];
}

- (void)hideLoading{
    [loadingView stopAnimating];
}

-(void)displayAlert:(NSString *)message withTitle:(NSString *)title
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
	[alert show];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"ShowLogin"]) {
        loginView = [segue destinationViewController];
        [self presentModalViewController:loginView animated:YES];
    }
    else if([[segue identifier] isEqualToString:@"SignOut"]){
        [self popToRootViewControllerAnimated:FALSE];
    }
}


@end
