//
//  PCMapViewController.m
//  Popcorn
//
//  Created by Rucha Patki on 8/1/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import "PCMapViewController.h"
#import <MapKit/MapKit.h>
#import "APIManagerMovieGlu.h"

@interface PCMapViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *myMapView;

@end

@implementation PCMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.myMapView.delegate = self;
    
    //TODO: change region to be user's, SF region for now
    MKCoordinateRegion sfRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.783333, -122.416667), MKCoordinateSpanMake(0.1, 0.1));
    [self.myMapView setRegion:sfRegion animated:false];
    
    [[APIManagerMovieGlu shared] getTheaterswithLat:@"37.783333" withLong:@"-122.416667" completion:^(NSDictionary *dataDictionary, NSError *error) {
        if(error != nil){
            NSLog(@"Error: %@", error.localizedDescription);
        }
        else{
            NSLog(@"dataDictionary: %@", dataDictionary);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
