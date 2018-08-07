//
//  ShelfUpdateCell.m
//  Popcorn
//
//  Created by Rucha Patki on 7/30/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import "ShelfUpdateCell.h"
#import "PFUser+ExtendedUser.h"
#import "APIManager.h"
#import "UIImageView+AFNetworking.h"
#import "NSDate+DateTools.h"

@implementation ShelfUpdateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UITapGestureRecognizer *addToGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapAddTo:)];
    [self.addToShelvesButton addGestureRecognizer:addToGestureRecognizer];
    [self.addToShelvesButton setUserInteractionEnabled:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)didTapAddTo:(id)sender {
    [self.delegate shelfUpdateCell:self didTapAddTo:self.movie];
}


- (void)configureCell:(NSString *)authorId withSession: (NSString *) sessionId withMovie:(NSString *)movieId withShelves:(NSMutableArray *)shelves withDate: (NSDate*) date{
    

    self.userImage.image = [UIImage imageNamed:@"person placeholder"];
    self.usernameLabel.text = @"";
    self.descriptionLabel.text = @"";
    self.movieImage.image = [UIImage imageNamed:@"poster-placeholder"];
    self.movieTitleLabel.text = @"";
    self.timestampLabel.text = @"";
    self.summaryLabel.text = @"";

    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = [UIColor blackColor];
    self.selectedBackgroundView = backgroundView;

    
    self.authorId = authorId;
    self.movieId = movieId;
    self.authorSessionId = sessionId;
    
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
            NSLog(@"Error: %@", error.localizedDescription);
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
                    NSNumber *statusCode = dataDictionary[@"status_code"];
                    if([[statusCode stringValue] isEqualToString:@"25"]){
                        NSLog(@"Too many requests");
                    }
                    else{
                        self.summaryLabel.text = dataDictionary[@"overview"];
                        
                        //fade in images
                        self.movieImage.alpha = 0.0;
                        [self.movieImage setImageWithURL:[NSURL URLWithString:[@"https://image.tmdb.org/t/p/w500" stringByAppendingString:dataDictionary[@"poster_path"]]]];
                        [UIView animateWithDuration:0.3 animations:^{
                            self.movieImage.alpha = 1.0;
                        }];
                        
                        //set title
                        self.movieTitleLabel.text = dataDictionary[@"title"];
                        
                        //set description text
                        int index = 0;
                        NSString *descriptionNonmutable = [[@"added \"" stringByAppendingString:self.movieTitleLabel.text] stringByAppendingString:@"\" to "];
                        NSMutableString *description = [descriptionNonmutable mutableCopy];
                        
                        for(NSString *shelf in shelves){
                            if(index == 0){
                                description = [[description stringByAppendingString:shelf] mutableCopy];
                            }
                            else{
                                description = [[description stringByAppendingString:@" and "] mutableCopy];
                                description = [[description stringByAppendingString:shelf] mutableCopy];
                            }
                            index++;
                        }
                        self.descriptionLabel.text = description;
                    }
                }
            }];
            
        }
    }];
}

@end
