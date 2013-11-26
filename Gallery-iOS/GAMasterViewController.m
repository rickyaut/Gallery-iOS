//
//  GAMasterViewController.m
//  Gallery-iOS
//
//  Created by Ricky Liu on 26/11/2013.
//  Copyright (c) 2013 Ricky Liu. All rights reserved.
//

#import "GAMasterViewController.h"

#import "GAVehicleCollectionViewController.h"

@interface GAMasterViewController () {
    NSMutableArray *manufacturers;
}
@end

@implementation GAMasterViewController

- (void)awakeFromNib
{
    self.clearsSelectionOnViewWillAppear = NO;
    self.preferredContentSize = CGSizeMake(320.0, 600.0);
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    /*self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;*/
    manufacturers = [[NSMutableArray alloc] initWithObjects:@"Audi", @"audi-gallery", @"", @"",
                     //@"Mercedes-Benz", @"benz-gallery", @"", @"",
                     @"BMW", @"bmw-gallery", @"", @"",
                     @"Ford", @"ford-gallery", @"", @"",
                     @"GM", @"gm-gallery", @"", @"",
                     @"Honda", @"honda-gallery", @"", @"",
                     @"Jaguar", @"jaguar-gallery", @"", @"",
                     @"Lamborghini", @"lamborghini-gallery", @"", @"",
                     //@"Lexus", @"lexus-gallery", @"", @"",
                     @"Maserati", @"maserati-gallery", @"", @"",
                     @"Mazda", @"mazda-gallery", @"", @"",
                     @"Porsche", @"porsche-gallery", @"", @"",
                     @"Toyota", @"toyota-gallery", @"", @"",
                     nil];
    
    self.detailViewController = (GAVehicleCollectionViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
}

/*
 -(void)viewDidAppear:(BOOL)animated
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [super.tableView selectRowAtIndexPath:indexPath
                           animated:NO
                     scrollPosition:UITableViewScrollPositionMiddle];
}
 */

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return manufacturers.count/4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSDate *object = manufacturers[indexPath.row*4];
    cell.textLabel.text = [object description];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [manufacturers removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *object = manufacturers[indexPath.row*4+1];
    [self.detailViewController setVehiclesJSONFile:object];
    [self.detailViewController.collectionView reloadData];
}

@end
