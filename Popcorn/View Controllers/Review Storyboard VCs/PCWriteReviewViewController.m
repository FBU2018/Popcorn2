//
//  PCWriteReviewViewController.m
//  Popcorn
//
//  Created by Rucha Patki on 7/25/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import "PCWriteReviewViewController.h"
#import "Parse.h"
#import "HCSStarRatingView.h"
#import "APIManager.h"
#import "Post.h"


@interface PCWriteReviewViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UITextView *reviewTextView;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *ratingView;

@property(strong, nonatomic) NSString *placeholderText;


@end

@implementation PCWriteReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.reviewTextView.delegate = self;
    self.placeholderText = @"Write your review here...";
    [self setViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setViews{
    self.titleLabel.text = self.currentMovie.title;
    self.ratingLabel.text = [[self.currentMovie.rating stringValue] stringByAppendingString:@"/10"];
    //sets placeholder text
    self.reviewTextView.text = self.placeholderText;
    self.reviewTextView.textColor = [UIColor lightGrayColor];
    
    self.reviewTextView.layer.borderWidth = 0.3f;
    self.reviewTextView.layer.borderColor = [[UIColor grayColor] CGColor];
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    //gets rid of placeholder text and changes text color to black
    if([self.reviewTextView.text isEqualToString:self.placeholderText]){
        self.reviewTextView.text = @"";
        self.reviewTextView.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:224/255.0 alpha:1];
    }
    [self.reviewTextView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    //brings back placeholder text and changes text color to light gray
    if([self.reviewTextView.textColor isEqual:@""]){
        self.reviewTextView.text = self.placeholderText;
        self.reviewTextView.textColor = [UIColor lightGrayColor];
    }
    [self.reviewTextView resignFirstResponder];
}


- (IBAction)didTapDone:(id)sender {
    //push review to Parse
    if([self.reviewTextView.text isEqualToString:self.placeholderText] || [self.reviewTextView.text isEqualToString:@""]){
        //alert saying you need to write a review to publish
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Can't Publish Review" message:@"You need to include a review to publish" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:^{
        }];
    }
    else{
        //push review to parse
        //dictionary = [key: movieId, value: review]
        NSDictionary *reviewDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:self.reviewTextView.text,[self.currentMovie.movieID stringValue], nil];
        [PFUser.currentUser addUniqueObject:reviewDictionary forKey:@"reviews"];
        [PFUser.currentUser saveInBackground];
        
        //reset --> TODO: check if needed
        self.reviewTextView.text = self.placeholderText;
        self.reviewTextView.textColor = [UIColor lightGrayColor];
        
        //converts the rating from 5 stars to out of 10 points to match the movieDB
        NSString *ratingString = [NSString stringWithFormat:@"%.1f", self.ratingView.value * 2];
        //post rating to movieDB
        [[APIManager shared]addRating:[self.currentMovie.movieID stringValue] withRating:ratingString withSessionId: PFUser.currentUser[@"sessionId"] completion:^(NSError * error) {
            if(error != nil){
                NSLog(@"%@", error.localizedDescription);
            }
            else{
                PFUser *currUser = PFUser.currentUser;
                [Post postReviewWithUser:currUser.objectId ofUsername: currUser.username withSession:currUser[@"sessionId"] andMovie:[self.currentMovie.movieID stringValue] withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
                    if(error != nil){
                        NSLog(@"Error making post in parse: %@", error.localizedDescription);
                    }
                    else{
                        NSLog(@"Successfully pushed post to parse");
                    }
                }];
                NSLog(@"Request successful");
            }
        }];
        
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)didTapCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
