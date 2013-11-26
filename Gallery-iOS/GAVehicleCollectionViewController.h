//
//  GADetailViewController.h
//  Gallery-iOS
//
//  Created by Ricky Liu on 26/11/2013.
//  Copyright (c) 2013 Ricky Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GAVehicleCollectionViewController : UICollectionViewController <UISplitViewControllerDelegate>

-(void) setVehiclesJSONFile: (NSString*) jsonFile;

@end
