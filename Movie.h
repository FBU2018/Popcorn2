//
//  Movie.h
//  Popcorn
//
//  Created by Ernest Omondi on 7/16/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Movie : NSObject
+ (NSMutableArray *)moviesWithDictionaries:(NSArray *)dictionaries;
- (id)initWithDictionary:(NSDictionary*) dictionary;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSURL *posterUrl;
@property (strong, nonatomic) NSURL *backdropUrl;
@property (strong, nonatomic) NSString *overview;
@property (strong, nonatomic) NSString *releaseDateString;
@property (strong, nonatomic) NSNumber *movieID; 
@property (strong, nonatomic) NSString *tagline;
@property (strong, nonatomic) NSNumber *rating;
@end
