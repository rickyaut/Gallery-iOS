//
//  GAGalleryViewController.m
//  Gallery-iOS
//
//  Created by Ricky Liu on 26/11/2013.
//  Copyright (c) 2013 Ricky Liu. All rights reserved.
//

#import "GAGalleryViewController.h"
#import "UIImageView+AFNetworking.h"
#import <AFHTTPRequestOperation.h>

@interface GAGalleryViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property(strong, nonatomic) NSDictionary* vehicleData;
@property(strong, nonatomic) NSMutableArray* images;
@property (strong, nonatomic) NSDictionary *currentImage;
@end

@implementation GAGalleryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.images = [[NSMutableArray alloc] init];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(onNextButtonTapped:)];
    }
    return self;
}
- (IBAction)onSwipeRight:(UISwipeGestureRecognizer *)sender {
    int i=[self.images count] - 1;
    for (; i>=0; i--) {
        if([self.images objectAtIndex:i] == self.currentImage){
            if(i == 0){
                self.currentImage = [self.images objectAtIndex:[self.images count]-1];
            }else{
                self.currentImage = [self.images objectAtIndex:i-1];
            }
            break;
        }
    }
    
    [self displayImageWithURL: [NSURL URLWithString:[self.currentImage valueForKey: @"imageUrl"]]];
}

- (IBAction)onSwipeLeft:(UISwipeGestureRecognizer *)sender {
    int i=0;
    for (; i<[self.images count]; i++) {
        if([self.images objectAtIndex:i] == self.currentImage){
            if(i == [self.images count] - 1){
                self.currentImage = [self.images objectAtIndex:0];
            }else{
                self.currentImage = [self.images objectAtIndex:i+1];
            }
            break;
        }
    }
    [self displayImageWithURL: [NSURL URLWithString:[self.currentImage valueForKey: @"imageUrl"]]];
}

- (void) onNextButtonTapped:(id)control{
    int i=0;
    for (; i<[self.images count]; i++) {
        if([self.images objectAtIndex:i] == self.currentImage){
            if(i == [self.images count] - 1){
                self.currentImage = [self.images objectAtIndex:0];
            }else{
                self.currentImage = [self.images objectAtIndex:i+1];
            }
            break;
        }
    }
    [self displayImageWithURL: [NSURL URLWithString:[self.currentImage valueForKey: @"imageUrl"]]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.currentImage = [self.images objectAtIndex:0];
    [self displayImageWithURL: [NSURL URLWithString:[self.currentImage valueForKey:@"imageUrl"]]];
    self.navigationItem.title = [self.vehicleData valueForKey:@"name"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setImagesWithVehicleData: (NSDictionary*) vehicleData{
    self.vehicleData = vehicleData;
    [self.images addObjectsFromArray:[vehicleData valueForKey:@"images"]];
    [self.images addObjectsFromArray:[vehicleData valueForKey:@"exteriorImages"]];
    [self.images addObjectsFromArray:[vehicleData valueForKey:@"interiorImages"]];
}

- (void) displayImageWithURL:(NSURL*) url
{
    [self.imageView setImageWithURLRequest: [NSURLRequest requestWithURL:url]
                          placeholderImage: nil
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                       CGSize viewSize = self.imageView.frame.size;
                                       CGSize imageSize = image.size;
                                       CGFloat bestScale = fmin(viewSize.width/imageSize.width, viewSize.height/imageSize.height);
                                       CGSize bestSize = CGSizeMake(imageSize.width*bestScale, imageSize.height*bestScale);
                                       self.imageView.frame = CGRectMake(self.imageView.frame.origin.x, self.imageView.frame.origin.y, bestSize.width, bestSize.height);
                                       self.imageView.image = image;
                                   }
                                   failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                       NSLog(@"fail to load image for: %@", [request URL]);
                                   }];
}
@end
