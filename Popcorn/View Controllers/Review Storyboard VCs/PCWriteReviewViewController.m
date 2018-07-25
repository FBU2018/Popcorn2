//
//  PCWriteReviewViewController.m
//  Popcorn
//
//  Created by Rucha Patki on 7/25/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import "PCWriteReviewViewController.h"
#import "Parse.h"

@interface PCWriteReviewViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UITextView *reviewTextView;

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
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    //gets rid of placeholder text and changes text color to black
    if([self.reviewTextView.text isEqualToString:self.placeholderText]){
        self.reviewTextView.text = @"";
        self.reviewTextView.textColor = [UIColor blackColor];
    }
    [self.reviewTextView becomeFirstResponder]; //TODO: review!!
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
    if([self.reviewTextView.text isEqualToString:self.placeholderText] == NO && [self.reviewTextView.text isEqualToString:@""] == NO){
        //push review to parse
        //dictionary = [key: movieId, value: review]
        NSDictionary *reviewDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:self.reviewTextView.text,self.currentMovie.movieID, nil];
        [PFUser.currentUser addUniqueObject:reviewDictionary forKey:@"reviews"];
        [PFUser.currentUser saveInBackground];
        
        //reset --> TODO: check if needed
        self.reviewTextView.text = self.placeholderText;
        self.reviewTextView.textColor = [UIColor lightGrayColor];
    }
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
