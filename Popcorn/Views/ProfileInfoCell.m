//
//  ProfileInfoCell.m
//  Popcorn
//
//  Created by Rucha Patki on 7/27/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import "ProfileInfoCell.h"
#import "Parse.h"
#import "Relations.h"
#import "PFUser+ExtendedUser.h"

@implementation ProfileInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UITapGestureRecognizer *followGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapFollow:)];
    [self.followButton addGestureRecognizer:followGestureRecognizer];
    [self.followButton setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *pictureGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapPicture:)];
    [self.userImage addGestureRecognizer:pictureGestureRecognizer];
    [self.userImage setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *searchUsersGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapSearchUsers:)];
    [self.searchUsersButton addGestureRecognizer:searchUsersGestureRecognizer];
    [self.searchUsersButton setUserInteractionEnabled:YES];
}

- (IBAction)didTapFollow:(id)sender {
    [self.delegate profileInfoCell:self didTapFollow:self.user];
}

- (IBAction)didTapPicture:(id)sender {
    [self.delegate profileInfoCell:self didTapPicture:self.user];
}

- (IBAction)didTapSearchUsers:(id)sender {
    [self.delegate profileInfoCell:self didTapSearchUsers:self.user];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setButton{
    self.followButton.layer.cornerRadius = 5;
    PFUser *loggedInUser = PFUser.currentUser;
    [self.user retrieveRelationsWithObjectID:self.user.relations.objectId andCompletion:^(Relations *userRelations) {
        if([userRelations.myfollowers containsObject:loggedInUser.username]){
            UIColor *lighterGray = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
            self.followButton.backgroundColor = lighterGray;
            [self.followButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [self.followButton setTitle:@"Unfollow" forState:UIControlStateNormal];
        }
        else{
            UIColor *red = [UIColor colorWithRed:189.0f/255.0f green:36.0f/255.0f blue:34.0f/255.0f alpha:1.0f];
            self.followButton.backgroundColor = red;
            [self.followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.followButton setTitle:@"Follow" forState:UIControlStateNormal];
        }
    }];
}

- (void)configureCell:(PFUser *)user withFollowing: (BOOL)following{
    self.user = user;
    if([user.username isEqualToString:PFUser.currentUser.username]){
        self.followButton.hidden = YES;
        self.followButton.enabled = NO;
    }
    else{

        self.followButton.hidden = NO;
        self.followButton.enabled = YES;
    }
    
    //setViews
    // Show the current users username and followers and following count
    self.usernameLabel.text = user.username;
    self.userShelvesLabel.text = [user.username stringByAppendingString:@"'s Shelves"];
    
    // Get current users relations object to get followers and following data
    [user retrieveRelationsWithObjectID:user.relations.objectId andCompletion:^(Relations *userRelations) {
        self.followingLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)userRelations.myfollowings.count];
        self.followersLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)userRelations.myfollowers.count];
    }];
    
    //set image if file is not nil
    PFFile *imageFile = user[@"userImage"];
    
    if(imageFile == nil){
        //create file with temporary image and save to parse
        UIImage *tempImage = [UIImage imageNamed:@"person placeholder"];
        PFFile *tempFile = [PFFile fileWithData: UIImageJPEGRepresentation(tempImage, 1.0)];
        self.user[@"userImage"] = tempFile;
        [self.user saveInBackground];
    }

    self.userImage.file = imageFile;
    [self.userImage loadInBackground];

    //make it a circle
    self.userImage.layer.cornerRadius = self.userImage.frame.size.height /2;
    self.userImage.layer.masksToBounds = YES;
    self.userImage.layer.borderWidth = 0;
    
    [self setButton];
}

@end
