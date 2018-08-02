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
- (void)getTheaterswithLat:(NSString*) lat withLong: (NSString*) lng completion:(void (^) (NSDictionary *dataDictionary, NSError *error))completion;

@end
