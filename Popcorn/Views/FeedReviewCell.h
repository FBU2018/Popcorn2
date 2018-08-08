//
//  FeedReviewCell.h
//  Popcorn
//
//  Created by Rucha Patki on 7/27/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParseUI.h"
#import "Movie.h"
#import "PFUser+ExtendedUser.h"

@protocol FeedReviewCellDelegate;

@interface FeedReviewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet PFImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *reviewTitleLabel;
@property (weak, nonatomic) IBOutlet PFImageView *movieImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratedLabel;
@property (weak, nonatomic) IBOutlet UILabel *reviewTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;


@property (strong, nonatomic) PFFile *userImageFile;
@property (strong, nonatomic) NSURL *movieImageURL;
@property (strong, nonatomic) NSString *ratingString;

@property (strong, nonatomic) NSString* authorId;
@property (strong, nonatomic) NSString* movieId;
@property (strong, nonatomic) Movie* movie;
@property (strong, nonatomic) PFUser* author;

@property (nonatomic, weak) id<FeedReviewCellDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *userImageGestureRecognizer;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *usernameGestureRecognizer;

- (void)configureCell:(NSString*) authorId withMovie:(NSString*) movieId withDate: (NSDate*) date;


@end


@protocol FeedReviewCellDelegate

- (void)feedReviewCell:(FeedReviewCell*) cell didTapUser: (PFUser*) author;

@end;
