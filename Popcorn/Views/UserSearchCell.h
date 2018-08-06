//
//  UserSearchCell.h
//  Popcorn
//
//  Created by Rucha Patki on 7/24/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParseUI.h"

@protocol UserSearchCellDelegate;

@interface UserSearchCell : UITableViewCell

@property (weak, nonatomic) IBOutlet PFImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIButton *followButton;

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *followGestureRecognizer;
@property (nonatomic, weak) id<UserSearchCellDelegate> delegate;
@property (nonatomic) BOOL following;

@property (strong, nonatomic) PFUser *user;

- (void) configureCell:(NSArray *)users withIndexPath:(NSIndexPath *)indexPath;
- (void)setButton;

@end

//delegate for the follow button
@protocol UserSearchCellDelegate

- (void)userSearchCell:(UserSearchCell*) cell didTapFollow: (PFUser*) user;

@end
