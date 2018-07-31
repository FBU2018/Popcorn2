//
//  ShelfUpdateCell.h
//  Popcorn
//
//  Created by Rucha Patki on 7/30/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParseUI.h"

@interface ShelfUpdateCell : UITableViewCell

@property (weak, nonatomic) IBOutlet PFImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet PFImageView *movieImage;
@property (weak, nonatomic) IBOutlet UILabel *movieTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *addToShelvesButton;

- (void)configureCell: (NSString *) authorId withMovie: (NSString*) movieId withShelves: (NSMutableArray*) shelves;


@end
