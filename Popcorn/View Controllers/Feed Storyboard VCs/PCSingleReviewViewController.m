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
#import "PCMovieDetailViewController.h"
#import "APIManager.h"
#import "Movie.h"

@interface PCSingleReviewViewController ()

@property (weak, nonatomic) IBOutlet PFImageView *moviePosterImage;
@property (weak, nonatomic) IBOutlet UILabel *movieTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet PFImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UITextView *reviewTextView;

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *movieTitleGestureRecognizer;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *movieImageGestureRecognizer;



@end

@implementation PCSingleReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setViews];
    
    self.shelves = [NSArray new];
    [self getLists];
    [self getMovieObject];
    [self.movieTitleLabel setUserInteractionEnabled:YES];
    
}

- (void)getMovieObject{
    NSString *movieNameInput = [self.movieName stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
    [[APIManager shared] searchMoviesWithString:movieNameInput andPageNumber:@"1" andResultsCompletionHandler:^(NSArray *results) {
        Movie *currMovie = [[Movie alloc] initWithDictionary:results[0]];
        self.movie = currMovie;
    } andErrorCompletionHandler:^(NSError *error) {
        if(error != nil){
            NSLog(@"Error for movie object: %@", error.localizedDescription);
        }
    }];
}

- (void)getLists{
    //gets a dictionary of all of user's saved lists
    [[APIManager shared] getShelvesWithSessionId:PFUser.currentUser[@"sessionId"] andAccountId: PFUser.currentUser[@"accountId"] andCompletionBlock:^(NSArray *results, NSError *error) {
        if(error == nil){
            self.shelves = results;
            NSLog(@"Successfully got all of user's shelves");
        }
        else{
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
}

- (IBAction)didTapMovieTitle:(id)sender {
    [self performSegueWithIdentifier:@"reviewToDetail" sender:nil];
}

- (IBAction)didTapMovieImage:(id)sender {
    [self performSegueWithIdentifier:@"reviewToDetail" sender:nil];
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
    if(self.ratingString != nil){
            self.ratingLabel.text = [[[@"Rated " stringByAppendingString:self.ratingString] stringByAppendingString:@" by "] stringByAppendingString:self.username];
    }
    else{
        self.ratingLabel.text = [self.username stringByAppendingString:@" has not rated this movie yet"];
    }
    self.usernameLabel.text = self.username;
    self.reviewTextView.text = self.review;
    self.reviewTextView.editable = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([segue.identifier isEqualToString:@"reviewToDetail"]){
        PCMovieDetailViewController *receiver = [segue destinationViewController];
        receiver.movie = self.movie;
        receiver.shelves = self.shelves;
    }
}


@end
