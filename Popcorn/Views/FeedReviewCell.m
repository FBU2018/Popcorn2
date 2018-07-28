//
//  FeedReviewCell.m
//  Popcorn
//
//  Created by Rucha Patki on 7/27/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import "FeedReviewCell.h"
#import "APIManager.h"

@implementation FeedReviewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCell:(PFUser *)author withMovie:(Movie *)movie{
    //set image if file is not nil
    PFFile *imageFile = author[@"userImage"];
    if(imageFile == nil){
        //create file with temporary image and save to parse
        UIImage *tempImage = [UIImage imageNamed:@"person placeholder"];
        PFFile *tempFile = [PFFile fileWithData: UIImageJPEGRepresentation(tempImage, 1.0)];
        author[@"userImage"] = tempFile;
        [author saveInBackground];
    }
    
    self.userImage.file = imageFile;
    [self.userImage loadInBackground];
    
    self.usernameLabel.text = author.username;
    self.reviewTitleLabel.text = [@"reviewed " stringByAppendingString:movie.title];
    self.titleLabel.text = movie.title;

    [[APIManager shared] getRating:[movie.movieID stringValue] withSessionId:author[@"sessionId"] completion:^(NSObject *rating, NSError *error) {
        if(error != nil){
            NSLog(@"Error: %@", error.localizedDescription);
        }
        else{
            NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
            [fmt setPositiveFormat:@"0.##"];
            NSString *ratingString = [[fmt stringFromNumber:rating] stringByAppendingString:@" /10"];
            
            self.ratedLabel.text = [[[@"Rated: " stringByAppendingString:ratingString] stringByAppendingString:@" by "] stringByAppendingString:author.username];
        }
    }];

    //TODO: set review text to the review fetched from parse
}

@end
