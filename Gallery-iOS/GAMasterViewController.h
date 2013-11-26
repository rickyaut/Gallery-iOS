//
//  GAMasterViewController.h
//  Gallery-iOS
//
//  Created by Ricky Liu on 26/11/2013.
//  Copyright (c) 2013 Ricky Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GAVehicleCollectionViewController;

@interface GAMasterViewController : UITableViewController

@property (strong, nonatomic) GAVehicleCollectionViewController *detailViewController;

@end
