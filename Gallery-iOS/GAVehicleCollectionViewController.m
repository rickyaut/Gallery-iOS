//
//  GADetailViewController.m
//  Gallery-iOS
//
//  Created by Ricky Liu on 26/11/2013.
//  Copyright (c) 2013 Ricky Liu. All rights reserved.
//

#import "GAVehicleCollectionViewController.h"
#import "UIImageView+AFNetworking.h"
#import "GAGalleryViewController.h"

@interface GAVehicleCollectionViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@property (strong, nonatomic) NSString* jsonFile;
@property (strong, nonatomic) NSArray* vehicles;
@end

@implementation GAVehicleCollectionViewController

#pragma mark - Managing the detail item

- (id) initWithCoder:(NSCoder *)aDecoder
{
    NSLog(@"initWithCoder");
    self = [super initWithCoder:aDecoder];
    return self;
}

- (void)setDetailItem:(id)newDetailItem
{
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setVehiclesJSONFile: (NSString*) jsonFile
{
    self.jsonFile = jsonFile;
    NSError *error;
    NSString* path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"/%@", jsonFile]
                                                     ofType:@"json"];
    NSString *galleryString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    
    self.vehicles = [NSJSONSerialization JSONObjectWithData:[galleryString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
}
#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[self filterCollection] count];
}

-(UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    [cell.contentView.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    
    UILabel *vehicleNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 120, 170, 30)];
    NSDictionary *vehicleData = [[self filterCollection] objectAtIndex:indexPath.row];
    vehicleNameLabel.text = [vehicleData valueForKey:@"name"];
    [cell.contentView addSubview: vehicleNameLabel];
    
    UIImageView *vehicleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 180, 120)];
    [cell.contentView addSubview: vehicleImageView];
    __weak UIImageView *weakImageView = vehicleImageView;
    [weakImageView setImageWithURLRequest: [NSURLRequest requestWithURL:[NSURL URLWithString:[vehicleData valueForKey:@"thumbnailUrl"]]]
                         placeholderImage: nil
                                  success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                      CGSize viewSize = weakImageView.frame.size;
                                      CGSize imageSize = image.size;
                                      CGFloat bestScale = fmin(viewSize.width/imageSize.width, viewSize.height/imageSize.height);
                                      CGSize bestSize = CGSizeMake(imageSize.width*bestScale, imageSize.height*bestScale);
                                      weakImageView.frame = CGRectMake(weakImageView.frame.origin.x, weakImageView.frame.origin.y, bestSize.width, bestSize.height);
                                      weakImageView.image = image;
                                  }
                                  failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                      NSLog(@"fail to load image for: %@", [request URL]);
                                  }];
    return cell;
}

-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row>=0){
        GAGalleryViewController *galleryViewController =[[GAGalleryViewController alloc] initWithNibName:@"GAGalleryViewController" bundle:nil];
        NSDictionary *vehicleData = [[self filterCollection] objectAtIndex:indexPath.row];
        [galleryViewController setImagesWithVehicleData:vehicleData];
        [self.navigationController pushViewController:galleryViewController animated:YES];
    }
}
/*- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    self.searchText = self.searchBar.text;
    [self.collectionView reloadData];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if(!self.searchBar.text||[self.searchBar.text length] == 0){
        self.searchText = searchBar.text;
        [self.collectionView reloadData];
    }
}*/

- (NSArray*) filterCollection{
    /*if(self.searchText&&[self.searchText length] != 0){
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@", self.searchText];
        return [self.vehicles filteredArrayUsingPredicate:predicate];
    }else{
        return self.vehicles;
    }*/
    return self.vehicles;
}
@end
