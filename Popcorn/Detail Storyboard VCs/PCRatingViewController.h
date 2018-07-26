//
//  PCRatingViewController.h
//  Popcorn
//
//  Created by Sarah Embry on 7/19/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"


@protocol PCRatingViewControllerDelegate;


@interface PCRatingViewController : UIViewController
@property (strong, nonatomic) Movie *movie;
@property (weak, nonatomic) id<PCRatingViewControllerDelegate> delegate;
@end 

@protocol PCRatingViewControllerDelegate
- (void) didPostRating;
@end
