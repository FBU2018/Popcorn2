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

@interface PCMapViewController () <MKMapViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *myMapView;
@property (strong, nonatomic) NSString *lat;
@property (strong, nonatomic) NSString *lng;

@end

@implementation PCMapViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    self.myMapView.delegate = self;

    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    if([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]){
        [self.locationManager requestAlwaysAuthorization];
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [self.locationManager startUpdatingLocation];
    
    
    self.lat = [[NSNumber numberWithDouble:self.locationManager.location.coordinate.latitude] stringValue];
    self.lng = [[NSNumber numberWithDouble:self.locationManager.location.coordinate.longitude] stringValue];
    MKCoordinateRegion sfRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake([self.lat doubleValue], [self.lng doubleValue]), MKCoordinateSpanMake(0.8, 0.8));
    [self.myMapView setRegion:sfRegion animated:false];
    
    [self findTheaters];
    
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"Error: %@", error.localizedDescription);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
}



- (void)findTheaters{
    [[APIManagerMovieGlu shared] getTheaterswithLat:self.lat withLong:self.lng completion:^(NSMutableDictionary *theatres, NSError *error) {
        if(error != nil){
            NSLog(@"Error: %@", error.localizedDescription);
        }
        else{
            NSLog(@"Successfully got theaters with movies playing");
            NSArray *theaterNames = [theatres allKeys];
            [[APIManagerMovieGlu shared] getTheaterswithLocation:self.lat withLong:self.lng completion:^(NSDictionary *theaters, NSError *error) {
                if(error != nil){
                    NSLog(@"Error: %@", error.localizedDescription);
                }
                else{
                    NSArray *dataDictionary = theaters[@"results"];
                    for(NSDictionary *theatre in dataDictionary){
                        
                        if([theaterNames containsObject:theatre[@"name"]]){
                            //set the annotation
                            NSString *latString = theatre[@"geometry"][@"location"][@"lat"];
                            NSString *lngString = theatre[@"geometry"][@"location"][@"lng"];
                            double latitude = [latString doubleValue];
                            double longitude = [lngString doubleValue];
                            
                            CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(latitude, longitude);
                            
                            TheatreAnnotation *annotation = [TheatreAnnotation new]; //changed
                            annotation.coordinate = coord;
                            annotation.title = theatre[@"name"];
                            NSArray *moviesPlayingAtTheatre = theatres[theatre[@"name"]];
                            annotation.subtitle = [[NSString stringWithFormat:@"%@", @(moviesPlayingAtTheatre.count)] stringByAppendingString:@" movies playing"];
                            annotation.moviesPlaying = theatres[theatre[@"name"]];
                            annotation.theatreInfo = theatre;
                            annotation.rating = [theatre[@"rating"] stringValue];
                            [self.myMapView addAnnotation:annotation];
                        }
                    }
                }
            }];

        }
    }];
    
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
        UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];

        annotationView.rightCalloutAccessoryView = detailButton;
    }
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
    }
}


@end
