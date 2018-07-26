//
//  PCReviewViewController.m
//  Popcorn
//
//  Created by Sarah Embry on 7/19/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import "PCReviewViewController.h"
#import "ReviewCell.h"
#import "APIManager.h"

@interface PCReviewViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSArray *reviews;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)didTapDone:(id)sender;

@end

@implementation PCReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self fetchReviews];

    //this is displaying every time for some reason, breakpoint says that reviews is nill
//    if(self.reviews.count == 0){
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"No Reviews" message:@"This movie has no reviews" preferredStyle:(UIAlertControllerStyleAlert)];
//        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            [self dismissViewControllerAnimated:NO completion:nil];
//        }];
//        [alert addAction:okAction];
//        [self presentViewController:alert animated:YES completion:^{
//
//        }];
//    }


}
- (IBAction)didTapDone:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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



- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ReviewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ReviewCell" forIndexPath:indexPath];
    [cell configureCell:self.reviews withIndexPath:indexPath];
    return cell;
    
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.reviews.count;
}


-(void) fetchReviews{
    [[APIManager shared] getReviews:[self.movie.movieID stringValue] completion:^(NSArray *reviews, NSError *error) {
        if(error != nil){
            NSLog(@"%@", [error localizedDescription]);
        }
        else{
            NSLog(@"Successfully fetched reviews");
            self.reviews = reviews;
            if(self.reviews.count == 0){
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"No Reviews" message:@"This movie has no reviews" preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }];
                [alert addAction:okAction];
                [self presentViewController:alert animated:YES completion:^{
                    
                }];
            }
            [self.tableView reloadData];
        }
    }];
}


@end
