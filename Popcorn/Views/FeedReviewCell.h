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

@interface FeedReviewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet PFImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *reviewTitleLabel;
@property (weak, nonatomic) IBOutlet PFImageView *movieImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratedLabel;
@property (weak, nonatomic) IBOutlet UILabel *reviewTextLabel;

//@property (strong, nonatomic) PFUser *author;
//@property (strong, nonatomic) Movie *movie;

- (void)configureCell:(PFUser*) author withMovie:(Movie*) movie;


@end
