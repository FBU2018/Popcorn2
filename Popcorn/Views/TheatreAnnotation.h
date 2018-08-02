//
//  TheatreAnnotation.h
//  Popcorn
//
//  Created by Rucha Patki on 8/2/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MapKit;

@interface TheatreAnnotation : NSObject <MKAnnotation>

@property (strong, nonatomic) NSArray *moviesPlaying;
@property (strong, nonatomic) NSDictionary *theatreInfo;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;


@end
