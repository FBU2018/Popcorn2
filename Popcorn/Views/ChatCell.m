//
//  ChatCell.m
//  Popcorn
//
//  Created by Ernest Omondi on 7/31/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import "ChatCell.h"
#import "UIImageView+AFNetworking.h"
#import "NSDate+DateTools.h"
#import "Parse.h"


@implementation ChatCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configureCell:(Chat *)chat withUserObjectId:(NSString *)objectId andIndexPath:(NSIndexPath *)indexPath{
    // Get user object from objectId
    PFQuery *query = [PFUser query];
    [query getObjectInBackgroundWithId:objectId block:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if(error == nil){
            PFUser *user = (PFUser *)object;
            // Set labels and image views
            self.usernameLabel.text = user.username;
            self.chatTextLabel.text = chat.message;
            
            // Set timestamp
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // Configure the input format to parse the date string
            formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
            // Convert string to date
            NSDate *date = [formatter dateFromString:chat.createdAtString];
            // Configure output format
            formatter.dateStyle = NSDateFormatterShortStyle;
            formatter.timeStyle = NSDateFormatterNoStyle;
            // Covert Date to string and store in timestamp label
            self.timeStampLabel.text = date.shortTimeAgoSinceNow;
            
            //set profile image if file is not nil
            PFFile *imageFile = user[@"userImage"];
            if(imageFile == nil){
                //create file with temporary image and save to parse
                UIImage *tempImage = [UIImage imageNamed:@"person placeholder"];
                PFFile *tempFile = [PFFile fileWithData: UIImageJPEGRepresentation(tempImage, 1.0)];
                user[@"userImage"] = tempFile;
                [user saveInBackground];
            }
            
            self.userImageView.file = imageFile;
            [self.userImageView loadInBackground];
            
            //make it a circle
            self.userImageView.layer.cornerRadius = self.userImageView.frame.size.height /2;
            self.userImageView.layer.masksToBounds = YES;
            self.userImageView.layer.borderWidth = 0;
            
            // Make the view a bubble
            self.bubbleView.layer.cornerRadius = 16;
            self.bubbleView.clipsToBounds = true;
        }
        else{
            NSLog(@"Error retrieving user with query: %@", error.localizedDescription);
        }
    }];
}
@end
