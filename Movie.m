
//
//  Movie.m
//  Popcorn
//
//  Created by Ernest Omondi on 7/16/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import "Movie.h"

@implementation Movie
// initialize Movie object with given dictionary
- (id)initWithDictionary:(NSDictionary*) dictionary{
    self = [super init];
    
    // set different properties that the movie will have
    self.title = dictionary[@"original_title"];
    
    // Setting the posterurl
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = dictionary[@"poster_path"] ;
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    
    self.posterUrl = [NSURL URLWithString:fullPosterURLString];
    
    // Setting the backdropurl
    NSString *backdropURLString = dictionary[@"backdrop_path"] ;
    NSString *fullBackdropURLString = [baseURLString stringByAppendingString:backdropURLString];
    
    self.backdropUrl = [NSURL URLWithString:fullBackdropURLString];

    
    self.overview = dictionary[@"overview"];
    self.releaseDateString = dictionary[@"release_date"];
    self.movieID = dictionary[@"id"];
    self.tagline = dictionary[@"tagline"];
    
    return self;
}

+ (NSMutableArray *)moviesWithDictionaries:(NSArray *)dictionaries; {
    // Takes an array of dictionaries and returns an array of movie objects
    
    NSMutableArray *movies = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dictionary in dictionaries){
        Movie *movie =[[Movie alloc] initWithDictionary:dictionary];
        [movies addObject:movie];
    }
    
    return movies;
}

@end
