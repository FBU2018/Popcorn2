//
//  UserSearchCell.m
//  Popcorn
//
//  Created by Rucha Patki on 7/24/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import "UserSearchCell.h"
#import "Parse.h"

@implementation UserSearchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCell:(NSArray *)users withIndexPath:(NSIndexPath *)indexPath{
    //Configure labels and image
    PFUser *userForCell = users[indexPath.row];
    self.usernameLabel.text = userForCell.username;
    
    //set image if file is not nil
    PFFile *imageFile = userForCell[@"profileImage"];
    if(imageFile != nil){
        self.userImage.file = imageFile;
        [self.userImage loadInBackground];
    }
    
    //make it a circle
    self.userImage.layer.cornerRadius = self.userImage.frame.size.height /2;
    self.userImage.layer.masksToBounds = YES;
    self.userImage.layer.borderWidth = 0;
}

@end
