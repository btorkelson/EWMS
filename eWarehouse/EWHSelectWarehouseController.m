//
//  EWHLoginClass.m
//  eWarehouse
//
//  Created by Zbigniew Kisiel on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EWHSelectWarehouseController.h"

@implementation EWHSelectWarehouseController
{

}
@synthesize warehouses;

EWHRootViewController *rootController;

//- (void)viewWillAppear:(BOOL)animated{
//
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.navigationItem setHidesBackButton:YES];
    rootController = (EWHRootViewController *)self.navigationController;
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait ||
            toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
            toInterfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (IBAction)signOut:(id)sender
{
    [rootController signOut];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Only one section.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Only one section, so return the number of items in the list.
    return [warehouses count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier = @"WarehouseCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    // Get the object to display and set the value in the cell.
    EWHWarehouse* warehouse = [warehouses objectAtIndex:indexPath.row];
    cell.textLabel.text = warehouse.Name;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSString *title = NSLocalizedString(@"Warehouses", @"Warehouses");
    return title;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ShowMenu"]) {
        EWHSelectActionController *menuController = [segue destinationViewController];
        NSIndexPath *selectedRowIndex = [self.tableView indexPathForSelectedRow];
        menuController.warehouse = [warehouses objectAtIndex:selectedRowIndex.row];
    }
}
@end
