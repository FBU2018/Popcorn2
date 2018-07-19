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
@end

@implementation PCRatingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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



@end
