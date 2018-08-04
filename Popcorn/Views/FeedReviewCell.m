//
//  FeedReviewCell.m
//  Popcorn
//
//  Created by Rucha Patki on 7/27/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import "FeedReviewCell.h"
#import "APIManager.h"
#import "UIImageView+AFNetworking.h"
#import "PFUser+ExtendedUser.h"
#import "NSDate+DateTools.h"

@implementation FeedReviewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCell:(NSString *)authorId withMovie:(NSString *)movieId withDate:(NSDate*)date{
    
    self.userImage.image = [UIImage imageNamed:@"person placeholder"];
    self.usernameLabel.text = @"";
    self.reviewTitleLabel.text = @"";
    self.movieImage.image = [UIImage imageNamed:@"poster-placeholder"];
    self.titleLabel.text = @"";
    self.ratedLabel.text = @"";
    self.reviewTextLabel.text = @"";
    self.timestampLabel.text = @"";
    
    self.authorId = authorId;
    self.movieId = movieId;

    //set date
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
    NSString *newDateString = [formatter stringFromDate:date];
    NSDate *newDate = [NSDate dateWithString:newDateString formatString:formatter.dateFormat];
    NSString *timeInterval = [NSDate shortTimeAgoSinceDate:newDate];
    self.timestampLabel.text = timeInterval;
    
    PFQuery *query = [PFUser query];
    [query getObjectInBackgroundWithId:authorId block:^(PFObject * _Nullable user, NSError * _Nullable error) {
        if(error != nil){
            NSLog(@"error: %@", error.localizedDescription);
        }
        else{
            PFUser *author = (PFUser*)user;
            
            //set profile image if file is not nil
            PFFile *imageFile = author[@"userImage"];
            if(imageFile == nil){
                //create file with temporary image and save to parse
                UIImage *tempImage = [UIImage imageNamed:@"person placeholder"];
                PFFile *tempFile = [PFFile fileWithData: UIImageJPEGRepresentation(tempImage, 1.0)];
                author[@"userImage"] = tempFile;
                [author saveInBackground];
            }
            
            self.userImageFile = imageFile;
            self.userImage.file = imageFile;
            [self.userImage loadInBackground];
            
            //make it a circle
            self.userImage.layer.cornerRadius = self.userImage.frame.size.height /2;
            self.userImage.layer.masksToBounds = YES;
            self.userImage.layer.borderWidth = 0;
            
            self.usernameLabel.text = author.username;
            
            //everything that needs movie details:
            [[APIManager shared] getMovieDetails:movieId completion:^(NSDictionary *dataDictionary, NSError *error) {
                if(error != nil){
                    NSLog(@"Error: %@", error.localizedDescription);
                }
                else{
                    //set review and title
                    NSNumber *statusCode = dataDictionary[@"status_code"];
                    if([[statusCode stringValue] isEqualToString:@"25"]){
                        NSLog(@"Too many requests");
                    }
                    else{
                        self.reviewTitleLabel.text = [@"reviewed " stringByAppendingString:dataDictionary[@"title"]];
                        self.titleLabel.text = dataDictionary[@"title"];
                        
                        //set image of movie
                        [self.movieImage setImageWithURL:[NSURL URLWithString:[@"https://image.tmdb.org/t/p/w500" stringByAppendingString:dataDictionary[@"poster_path"]]]];
                        self.movieImageURL = [NSURL URLWithString:[@"https://image.tmdb.org/t/p/w500" stringByAppendingString:dataDictionary[@"poster_path"]]];
                    }
                }
            }];
            
            
            //rating related labels
            [[APIManager shared] getRating:movieId withSessionId:author[@"sessionId"] completion:^(NSObject *rating, NSError *error) {
                if(error != nil){
                    NSLog(@"Error: %@", error.localizedDescription);
                }
                else{
                    
                    if([rating isKindOfClass:[NSDictionary class]]){
                        //has been rated
                        NSDictionary *ratingDict = (NSDictionary*) rating;
                        NSNumber *ratingVal = ratingDict[@"value"];
                        
                        //set label
                        NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
                        [fmt setPositiveFormat:@"0.##"];
                        NSString *ratingString = [[fmt stringFromNumber:ratingVal] stringByAppendingString:@"/10"];
                        self.ratingString = ratingString;
                        
                        self.ratedLabel.text = [[[@"Rated " stringByAppendingString:ratingString] stringByAppendingString:@" by "] stringByAppendingString:author.username];
                        
                    }
                    else{
                        //rating is 0/undefined
                        self.ratedLabel.text = [author.username stringByAppendingString:@" has not rated this movie yet."];
                    }
                    

                }
            }];
            
            
            
            //set review text to the review fetched from parse
            PFQuery *query = [PFUser query];
            [query getObjectInBackgroundWithId:author.objectId block:^(PFObject * _Nullable user, NSError * _Nullable error) {
                if(user != nil){
                    NSArray *usersReviews = user[@"reviews"];
                    for(NSDictionary *review in usersReviews){
                        NSArray *keys = review.allKeys; //should only be 1 key
                        for(NSString *key in keys){
                            if([key isEqualToString:movieId]){
                                //want the review for this movie
                                NSString *reviewString = review[key];
                                self.reviewTextLabel.text = [[@"\"" stringByAppendingString:reviewString] stringByAppendingString:@"\""];
                            }
                        }
                    }
                }
            }];
        }
    }];
}

@end
