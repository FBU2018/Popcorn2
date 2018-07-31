//
//  PCSingleReviewViewController.m
//  Popcorn
//
//  Created by Rucha Patki on 7/31/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import "PCSingleReviewViewController.h"
#import "ParseUI.h"
#import "UIImageView+AFNetworking.h"

@interface PCSingleReviewViewController ()

@property (weak, nonatomic) IBOutlet PFImageView *moviePosterImage;
@property (weak, nonatomic) IBOutlet UILabel *movieTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet PFImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UITextView *reviewTextView;


@end

@implementation PCSingleReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setViews];
}

- (void)setViews{
    //user image
    self.userImageView.file = self.userImage;
    [self.userImageView loadInBackground];
    //make it a circle
    self.userImageView.layer.cornerRadius = self.userImageView.frame.size.height /2;
    self.userImageView.layer.masksToBounds = YES;
    self.userImageView.layer.borderWidth = 0;
    
    //set movie poster image
    [self.moviePosterImage setImageWithURL:self.movieImageURL];
    
    //set labels
    self.movieTitleLabel.text = self.movieName;
    self.ratingLabel.text = [[[@"Rated " stringByAppendingString:self.ratingString] stringByAppendingString:@" by "] stringByAppendingString:self.username];
    self.usernameLabel.text = self.username;
    self.reviewTextView.text = self.review;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
