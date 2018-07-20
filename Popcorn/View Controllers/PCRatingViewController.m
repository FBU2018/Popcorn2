//
//  PCRatingViewController.m
//  Popcorn
//
//  Created by Sarah Embry on 7/19/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import "PCRatingViewController.h"
#import "APIManager.h"

@interface PCRatingViewController ()
- (IBAction)didTapDone:(id)sender;
- (IBAction)didTapCancel:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *ratingTextField;
@property (weak, nonatomic) IBOutlet UILabel *currentRatingLabel;

@end

@implementation PCRatingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self fetchRating];
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

- (IBAction)didTapDone:(id)sender {
    [[APIManager shared]addRating:[self.movie.movieID stringValue] withRating:self.ratingTextField.text completion:^(NSError * error) {
        if(error != nil){
            NSLog(@"%@", error.localizedDescription);
        }
        else{
            NSLog(@"Request successful");
        }
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)fetchRating{
    NSString *stringID = [self.movie.movieID stringValue];
    [[APIManager shared] getRating:stringID completion:^(NSObject *rating, NSError *error) {
        if(error != nil){
            NSLog(@"%@", error.localizedDescription);
        }
        else{
//            check if the object being returned from api call is a dictionary or a boolean
            if([rating isKindOfClass:[NSDictionary class]]){
                NSDictionary *ratingDict = (NSDictionary *)rating;
                self.currentRatingLabel.text = [[@"You previously rated this " stringByAppendingString:[ratingDict[@"value"] stringValue]] stringByAppendingString:@"/10"];
//                NSLog(@"%@", ratingDict[@"value"]);
            }
            //if the result is a boolean, that means the user hasn't rated it yet
            else{
                self.currentRatingLabel.text = @"You haven't rated this movie yet!";
            }
        }
    }];
}

@end
