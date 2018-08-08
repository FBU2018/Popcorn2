//
//  ShelfUpdateCell.h
//  Popcorn
//
//  Created by Rucha Patki on 7/30/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParseUI.h"
#import "Movie.h"

@protocol ShelfUpdateCellDelegate;

@interface ShelfUpdateCell : UITableViewCell

@property (weak, nonatomic) IBOutlet PFImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet PFImageView *movieImage;
@property (weak, nonatomic) IBOutlet UILabel *movieTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *addToShelvesButton;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *addToGestureRecognizer;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *userImageGestureRecognizer;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *usernameGestureRecognizer;


@property (nonatomic, weak) id<ShelfUpdateCellDelegate> delegate;
@property (strong, nonatomic) NSString *authorId;
@property (strong, nonatomic) NSString *authorSessionId;
@property (strong, nonatomic) NSString *movieId;

@property (strong, nonatomic) NSArray *userShelves;
@property (strong, nonatomic) Movie* movie;
@property (strong, nonatomic) NSString *voteAverage;
@property (strong, nonatomic) PFUser *author;

- (void)configureCell: (NSString *) authorId withSession: (NSString *) sessionId withMovie: (NSString*) movieId withShelves: (NSMutableArray*) shelves withDate: (NSDate*) date;


@end



@protocol ShelfUpdateCellDelegate

- (void)shelfUpdateCell:(ShelfUpdateCell*) cell didTapAddTo: (Movie*) movie;
- (void)shelfUpdateCell:(ShelfUpdateCell*) cell didTapUser: (PFUser*) author;

@end;
