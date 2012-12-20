//
//  EWHLoginClass.m
//  eWarehouse
//
//  Created by Zbigniew Kisiel on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EWHLoginController.h"

@implementation EWHLoginController
{
    IBOutlet UIImageView* logo;
    IBOutlet UITextField* username;
    IBOutlet UITextField* password;
    IBOutlet UIButton* btnSignIn;
}

EWHRootViewController *rootController;

BOOL isAuthenticated;
BOOL keyboardVisible;
CGPoint offset;

//@synthesize rootController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    rootController = (EWHRootViewController *)self.navigationController;
    rootController.loginView = self;
    
    keyboardVisible = NO;

    [self setScrollViewContentHight];
    
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:self.view.window];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:self.view.window];
}

-(void) setScrollViewContentHight
{
    [(UIScrollView *)self.view setContentSize: CGSizeMake(self.view.frame.size.width, CONTENT_HEIGHT)];
}

-(void) viewWillAppear:(BOOL)animated{
    //Z - remove for distribution
//    [username setText:@"zkisiel@cswsolutions.com"];
//    [password setText:@"123456"];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidUnload {
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification
                                                  object:nil];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait ||
            toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
            toInterfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self setScrollViewContentHight];
}

- (BOOL) textFieldShouldReturn:(UITextField *) textField{
    return [textField resignFirstResponder];
}

- (void)keyboardDidShow:(NSNotification *)notif {
    
    // If keyboard is visible, return
    if (keyboardVisible)
    {
        EWHLog(@"Keyboard is already visible. Ignoring notification.");
        return;
    }
    
    CGRect viewFrame = self.view.frame;
    int keyboardHeight = 0;

    // Get the size of the keyboard.
    NSDictionary* info = [notif userInfo];
    NSValue* aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [aValue CGRectValue].size;
    if([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft ||
       [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight)
        keyboardHeight = keyboardSize.width;
    else
        keyboardHeight = keyboardSize.height;
    
    offset = ((UIScrollView *)self.view).contentOffset;
    
    viewFrame.size.height -= keyboardHeight;
    self.view.frame = viewFrame;
    ((UIScrollView *)self.view).contentOffset = CGPointMake(offset.x, offset.y + keyboardHeight);
    
    keyboardVisible = YES;
}

- (void)keyboardDidHide:(NSNotification *)n{
    // Is the keyboard already shown
    if (!keyboardVisible)
    {
        EWHLog(@"Keyboard is already hidden. Ignoring notification.");
        return;
    }
    
    if([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft ||
       [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight)
        self.view.frame = CGRectMake(0, 0, self.view.window.frame.size.height, self.view.window.frame.size.width);
    else
        self.view.frame = self.view.window.frame;
    [self setScrollViewContentHight];

    ((UIScrollView *)self.view).contentOffset = offset;

    keyboardVisible = NO;
}

- (void) clearForm;
{
    [username setText:@""];
    [password setText:@""];
    [username becomeFirstResponder];
}

-(IBAction) signIn: (id) sender 
{
    [rootController showLoading];
    EWHLoginRequest* loginRequest = [[EWHLoginRequest alloc] initWithCallbacks:self callback:@selector(signInCallback:) errorCallback:@selector(errorCallback:) accessDeniedCallback:@selector(accessDeniedCallback)];
    [loginRequest loginUser:username.text withPassword:password.text];
}

-(void) signInCallback: (EWHUser*) user
{
    if(user != nil){
        if(user.UserId > 0){
            rootController.user = user;
            EWHGetUserWarehouseListRequest *request = [[EWHGetUserWarehouseListRequest alloc] initWithCallbacks:self callback:@selector(getWarehouseListCallback:) errorCallback:@selector(errorCallback:) accessDeniedCallback:@selector(accessDeniedCallback)];
            [request getUserWarehouseListRequest:user.UserId withAuthHash:user.AuthHash];
        }
        else{
            [rootController hideLoading];
            [rootController displayAlert:user.Message withTitle:@"Sign In"];
        }
    }
    else{
        [rootController hideLoading];
    }
}

-(void) getWarehouseListCallback: (NSMutableArray*) warehouses
{
    [rootController hideLoading];
    [self dismissModalViewControllerAnimated:YES];
    [self performSegueWithIdentifier:@"ShowWarehouses" sender:warehouses];
}

-(void) errorCallback: (NSError*) error
{
    [rootController hideLoading];
    [rootController displayAlert:error.localizedDescription withTitle:@"Error"];
}

-(void) accessDeniedCallback
{
    [rootController hideLoading];
    [rootController displayAlert:@"Session has timed out. Please sign in." withTitle:@"Session"];
    [rootController signOut];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"ShowWarehouses"]) {
        EWHSelectWarehouseController *selectWarehouseController = [segue destinationViewController];
        selectWarehouseController.warehouses = sender;
    }
    
}

@end
