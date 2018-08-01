//
//  PCSingleReviewViewController.h
//  Popcorn
//
//  Created by Rucha Patki on 7/31/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"
#import "Parse.h"

@interface PCSingleReviewViewController : UIViewController

//need movie name, rating by user, movie picture, username, user pic, review, movie
@property (strong, nonatomic) NSString *movieName;
@property (strong, nonatomic) NSString *ratingString;
@property (strong, nonatomic) NSURL *movieImageURL;
@property (strong, nonatomic) NSString* username;
@property (strong, nonatomic) PFFile *userImage;
@property (strong, nonatomic) NSString *review;

@property (strong, nonatomic) Movie* movie;

@end
