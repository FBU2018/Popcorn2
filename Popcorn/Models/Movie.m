//
//  Movie.m
//  Popcorn
//
//  Created by Ernest Omondi on 7/26/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import "Movie.h"

@implementation Movie
// initialize Movie object with given dictionary
- (id)initWithDictionary:(NSDictionary*) dictionary{
    self = [super init];
    //    NSLog(@"dictionary: %@", dictionary);
    
    // set different properties that the movie will have
    self.title = dictionary[@"original_title"];
    
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    
    // Setting the posterurl if the property exists
    if(![dictionary[@"poster_path"] isEqual:[NSNull null]]){
        NSString *posterURLString = dictionary[@"poster_path"] ;
        NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
        
        self.posterUrl = [NSURL URLWithString:fullPosterURLString];
    }
    // Setting the backdropurl if the property exists
    if(![dictionary[@"backdrop_path"] isEqual:[NSNull null]]){
        NSString *backdropURLString = dictionary[@"backdrop_path"];
        NSString *fullBackdropURLString = [baseURLString stringByAppendingString:backdropURLString];
        
        self.backdropUrl = [NSURL URLWithString:fullBackdropURLString];
    }
    
    self.overview = dictionary[@"overview"];
    self.releaseDateString = dictionary[@"release_date"];
    self.movieID = dictionary[@"id"];
    
    // Hard coded to movie but should change once we implement multi-search instead
    self.mediaType = @"movie";
    
    //    self.tagline = dictionary[@"tagline"];
    self.rating = dictionary[@"vote_average"];
    
    NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
    [fmt setPositiveFormat:@"0.##"];
    self.ratingString = [fmt stringFromNumber:self.rating];
    
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

