//
//  UserSearchCell.m
//  Popcorn
//
//  Created by Rucha Patki on 7/24/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import "UserSearchCell.h"
#import "Parse.h"
#import "PFUser+ExtendedUser.h"

@implementation UserSearchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UITapGestureRecognizer *followGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapFollow:)];
    [self.followButton addGestureRecognizer:followGestureRecognizer];
    [self.followButton setUserInteractionEnabled:YES];
}

- (void)setButton{
    self.followButton.layer.cornerRadius = 5;
    PFUser *loggedInUser = PFUser.currentUser;
    [self.user retrieveRelationsWithObjectID:self.user.relations.objectId andCompletion:^(Relations *userRelations) {
        if([userRelations.myfollowers containsObject:loggedInUser.username]){
            self.following = YES;
            UIColor *lighterGray = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
            self.followButton.backgroundColor = lighterGray;
            [self.followButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [self.followButton setTitle:@"Unfollow" forState:UIControlStateNormal];
        }
        else{
            self.following = NO;
            UIColor *red = [UIColor colorWithRed:189.0f/255.0f green:36.0f/255.0f blue:34.0f/255.0f alpha:1.0f];
            self.followButton.backgroundColor = red;
            [self.followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.followButton setTitle:@"Follow" forState:UIControlStateNormal];
        }
    }];
}

- (IBAction)didTapFollow:(id)sender {
    [self.delegate userSearchCell:self didTapFollow:self.user];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)configureCell:(NSArray *)users withIndexPath:(NSIndexPath *)indexPath{
    PFUser *userForCell = users[indexPath.row];
    self.user = userForCell;
    self.usernameLabel.text = userForCell.username;
    
    PFFile *imageFile = userForCell[@"userImage"];
    if(imageFile != nil){
        self.userImage.file = imageFile;
        [self.userImage loadInBackground];
    }
    
    //make it a circle
    self.userImage.layer.cornerRadius = self.userImage.frame.size.height /2;
    self.userImage.layer.masksToBounds = YES;
    self.userImage.layer.borderWidth = 0;
    
    [self setButton];
}

@end
