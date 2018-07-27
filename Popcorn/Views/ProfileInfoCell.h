//
//  ProfileInfoCell.h
//  Popcorn
//
//  Created by Rucha Patki on 7/27/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParseUI.h"

@protocol ProfileInfoCellDelegate;

@interface ProfileInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet PFImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIButton *followButton;
@property (weak, nonatomic) IBOutlet UILabel *followersLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingLabel;
@property (weak, nonatomic) IBOutlet UILabel *userShelvesLabel;
@property (weak, nonatomic) IBOutlet UIButton *searchUsersButton;


@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *followGestureRecognizer;
@property(strong, nonatomic) IBOutlet UITapGestureRecognizer *pictureGestureRecognizer;
@property(strong, nonatomic) IBOutlet UITapGestureRecognizer *searchUsersGestureRecognizer;

@property (nonatomic, weak) id<ProfileInfoCellDelegate> delegate;
@property (strong, nonatomic) PFUser *user;
@property (strong, nonatomic) NSString *followingCountString;
@property (strong, nonatomic) NSString *followersCountString;


- (void)configureCell:(PFUser *)user;

@end

//delegate for the follow button
@protocol ProfileInfoCellDelegate

- (void)profileInfoCell:(ProfileInfoCell*) cell didTapFollow: (PFUser*) user;
- (void)profileInfoCell:(ProfileInfoCell*) cell didTapPicture: (PFUser*) user;
- (void)profileInfoCell:(ProfileInfoCell*) cell didTapSearchUsers: (PFUser*) user;

@end
