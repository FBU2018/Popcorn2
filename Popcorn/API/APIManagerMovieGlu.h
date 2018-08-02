//
//  APIManagerMovieGlu.h
//  Popcorn
//
//  Created by Rucha Patki on 8/1/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIManagerMovieGlu : NSObject

+ (instancetype)shared;


//movieGlu
- (void)getFilmsNowShowing: (void (^) (NSDictionary *dataDictionary, NSError *error))completion;
- (void)getCinemasNearby: (NSString*) latLong completion:(void (^) (NSDictionary *dataDictionary, NSError *error))completion;

//graceNote
- (void)getTheaterswithLat:(NSString*) lat withLong: (NSString*) lng completion:(void (^) (NSMutableDictionary *theatres, NSError *error))completion;

//googlePlaces
- (void)findPlaceFromText: (NSString*) placeName completion:(void(^) (NSDictionary *dataDictionary, NSError *error)) completion;
- (void)getPhotoFromReference: (NSString*) photoReference completion:(void(^) (NSData *imageData, NSError *error)) completion;

@end
