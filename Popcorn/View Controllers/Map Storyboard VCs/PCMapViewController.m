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
#import "TheatreAnnotation.h"
#import "PCMapDetailViewController.h"

@interface PCMapViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *myMapView;

@end

@implementation PCMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.myMapView.delegate = self;
    
    //TODO: change region to be user's, MPK 20 region for now
    
    //sf: 37.783333, -122.416667
    //mpk 20: 37.481009, -122.155085
    MKCoordinateRegion sfRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.783333, -122.416667), MKCoordinateSpanMake(0.1, 0.1));
    [self.myMapView setRegion:sfRegion animated:false];
    
    [self getLocations];
    
    
}

- (void)getLocations{
    [[APIManagerMovieGlu shared] getTheaterswithLat:@"37.783333" withLong:@"-122.416667" completion:^(NSMutableDictionary *theatres, NSError *error) {
        if(error != nil){
            NSLog(@"Error: %@", error.localizedDescription);
        }
        else{
            NSArray *theatreNames = [theatres allKeys]; //array of names of all theatres
            
            //get dictionary of coordinates from theatreNames
            NSMutableDictionary *theatreInfo = [[NSMutableDictionary alloc] init];
            NSMutableDictionary *ratings = [[NSMutableDictionary alloc] init];
            
            for(NSString *theatreName in theatreNames){
                [[APIManagerMovieGlu shared] findPlaceFromText:theatreName completion:^(NSDictionary *dataDictionary, NSError *error) {
                    if(error != nil){
                        NSLog(@"Error: %@", error.localizedDescription);
                    }
                    else{
                        //TODO: make sure candidates isn't 0 length
                        NSLog(@"Successfully got places from text");
                        NSDictionary *location = dataDictionary[@"candidates"][0][@"geometry"][@"location"];
                        
                        [theatreInfo setObject:[NSMutableArray new] forKey:theatreName];
                        [theatreInfo[theatreName] addObject:location];
                        
                        ratings[theatreName] = dataDictionary[@"candidates"][0][@"rating"];
                        
//                        NSDictionary *candidate = dataDictionary[@"candidates"][0];
//                        NSLog(@"candidate 1: %@", candidate);
                    }
                    
                    if(theatreInfo.count == theatreNames.count-1){ //all taken into account
                        
                        //Create annotations at each of the theatres
                        for(NSString *key in theatreInfo){
                            NSDictionary *location = [theatreInfo objectForKey:key][0];
                            NSString *latString = location[@"lat"];
                            NSString *lngString = location[@"lng"];
                            double latitude = [latString doubleValue];
                            double longitude = [lngString doubleValue];

                            CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(latitude, longitude);

                            TheatreAnnotation *annotation = [TheatreAnnotation new]; //changed
                            annotation.coordinate = coord;
                            annotation.title = key;
                            NSArray *moviesPlayingAtTheatre = theatres[key];
                            annotation.subtitle = [[NSString stringWithFormat:@"%@", @(moviesPlayingAtTheatre.count)] stringByAppendingString:@" movies playing"];
                            annotation.moviesPlaying = theatres[key];
                            annotation.theatreInfo = dataDictionary;
                            annotation.rating = [ratings[key] stringValue];
                            [self.myMapView addAnnotation:annotation];
                        }
                    }
                }];
            }
        }
    }];

}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    MKPinAnnotationView *annotationView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"Pin"];
    if (annotationView == nil) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"];
        annotationView.canShowCallout = true;
//        annotationView.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 50.0, 50.0)];
        UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];

        annotationView.rightCalloutAccessoryView = detailButton;
    }
    
//    UIImageView *imageView = (UIImageView*)annotationView.leftCalloutAccessoryView;
//    imageView.image = [UIImage imageNamed:@"camera"];
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    [self performSegueWithIdentifier:@"mapToMapDetail" sender:view];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"mapToMapDetail"]){
        MKAnnotationView *annotationView = sender;
        TheatreAnnotation *annotation = annotationView.annotation;
        
        PCMapDetailViewController *receiver = [segue destinationViewController];
        receiver.moviesPlaying = annotation.moviesPlaying;
        receiver.theatreInfo = annotation.theatreInfo;
        receiver.theatreTitle = annotation.title;
        receiver.rating = annotation.rating;
        
//        NSLog(@"theatreInfo: %@", annotation.theatreInfo);
//        NSLog(@"moviesPlaying: %@", annotation.moviesPlaying);
    }
}


@end
