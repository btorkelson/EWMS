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
    IBOutlet UIButton *btnScanUserName;
}
@synthesize lblVersion;

EWHRootViewController *rootController;
DTDevices *linea;

BOOL isAuthenticated;
BOOL keyboardVisible;
CGPoint offset;
NSInteger logintries;

//@synthesize rootController;

- (void)viewDidLoad {
    [super viewDidLoad];
    lblVersion.text = [NSString stringWithFormat:@"Version %@",  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    
    
    rootController = (EWHRootViewController *)self.navigationController;
    rootController.loginView = self;
    
    keyboardVisible = NO;
    logintries =1 ;

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
    
    linea=[DTDevices sharedDevice];
	[linea connect];
	[linea addDelegate:self];
	//update display according to current linea state
	[self connectionState:linea.connstate];

}

-(void)viewWillDisappear:(BOOL)animated
{
	[linea removeDelegate:self];
    [linea disconnect];
    linea = nil;
}


- (void)viewDidUnload {
    btnScanUserName = nil;
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
//    [username becomeFirstResponder];
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
            if(user.Message) {
                [rootController hideLoading];
                [rootController displayAlert:user.Message withTitle:@"Sign In"];
            } else {
            rootController.user = user;
            EWHGetUserWarehouseListRequest *request = [[EWHGetUserWarehouseListRequest alloc] initWithCallbacks:self callback:@selector(getWarehouseListCallback:) errorCallback:@selector(errorCallback:) accessDeniedCallback:@selector(accessDeniedCallback)];
            [request getUserWarehouseListRequest:user.UserId withAuthHash:user.AuthHash];
            }
        }
        else{
            [rootController hideLoading];
            if (logintries == 1) {
                logintries = 2;
                EWHLoginRequest* loginRequest = [[EWHLoginRequest alloc] initWithCallbacks:self callback:@selector(signInCallback:) errorCallback:@selector(errorCallback:) accessDeniedCallback:@selector(accessDeniedCallback)];
                [loginRequest loginUser:username.text withPassword:password.text];
            } else {
                logintries = 1;
                [rootController displayAlert:user.Message withTitle:@"Sign In"];
            }


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
/////////////////////////////////////////////////////////////////////////////////////////////



- (IBAction)scanUserNameDown:(id)sender {
    NSError *error = nil;
	[linea startScan:&error];
    if(error != nil)
        [rootController displayAlert:error.localizedDescription withTitle:@"Error"];
}

- (IBAction)scanUserNameUp:(id)sender {
     [self stopScan];
}



-(void) stopScan{
    NSError *error = nil;
    int scanMode;
    
    if([linea getScanMode:&scanMode error:&error] && scanMode!=MODE_MOTION_DETECT)
       [linea stopScan:&error];
    if(error != nil)
        [rootController displayAlert:error.localizedDescription withTitle:@"Error"];
}

-(void)connectionState:(int)state {
	switch (state) {
		case CONN_DISCONNECTED:
		case CONN_CONNECTING:
            //[btnScanUserName setHidden:true];
            //[scannerMsg setHidden:false];
            //[voltageLabel setHidden:true];
            //[battery setHidden:true];
			break;
		case CONN_CONNECTED:
            //[btnScanUserName setHidden:false];
            //[scannerMsg setHidden:true];
            //[self updateBattery];
            ////Z - remove in production
            ////            [linea setScanBeep:false volume:0 beepData:nil length:0];
			break;
	}
}

-(void)barcodeData:(NSString *)barcode isotype:(NSString *)isotype
{

    if(self.navigationController.visibleViewController == self){
        [self stopScan];

    username.text=barcode;
        [password becomeFirstResponder];
    
}
    [self updateBattery];
}

-(void)barcodeData:(NSString *)barcode type:(int)type {

    if(self.navigationController.visibleViewController == self){
        [self stopScan];
        username.text=barcode;
        [password becomeFirstResponder];
    }
    [self updateBattery];
}

-(void)updateBattery
{
    NSError *error=nil;
    
    int percent;
    float voltage;
    
	if([linea getBatteryCapacity:&percent voltage:&voltage error:&error])
    {
        //        [voltageLabel setText:[NSString stringWithFormat:@"%d%%,%.1fv",percent,voltage]];
       /* 
        [voltageLabel setText:[NSString stringWithFormat:@"%d%%",percent]];
        [battery setHidden:FALSE];
        [voltageLabel setHidden:FALSE];
        if(percent<0.1)
            [battery setImage:[UIImage imageNamed:@"0.png"]];
        else if(percent<40)
            [battery setImage:[UIImage imageNamed:@"25.png"]];
        else if(percent<60)
            [battery setImage:[UIImage imageNamed:@"50.png"]];
        else if(percent<80)
            [battery setImage:[UIImage imageNamed:@"75.png"]];
        else
            [battery setImage:[UIImage imageNamed:@"100.png"]];
        */
        }else
    {
        /*[battery setHidden:TRUE];
        [voltageLabel setHidden:TRUE];*/
    }
}

@end
