//
//  PCMovieDetailViewController.h
//  Popcorn
//
//  Created by Sarah Embry on 7/16/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"
#import "PCRatingViewController.h"

@interface PCMovieDetailViewController : UIViewController 
@property (strong, nonatomic) Movie *movie;
@property (strong, nonatomic) NSArray *shelves;
@end
