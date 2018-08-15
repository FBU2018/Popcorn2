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
#import "Parse/Parse.h"
#import "JGProgressHUD.h"

@interface PCReviewViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSArray *reviews;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)didTapDone:(id)sender;
@property (strong, nonatomic) JGProgressHUD *HUD;

@end

@implementation PCReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    self.HUD.textLabel.text = @"Loading";
    [self.HUD showInView:self.view];
    
    [self fetchReviews];
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
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell configureCell:self.reviews withIndexPath:indexPath]; 
    return cell;
    
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.reviews.count;
}


-(void) fetchReviews{
    NSMutableArray *communityReviews = [NSMutableArray new];
    PFQuery *query = [PFUser query];
    [query orderByAscending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable users, NSError * _Nullable error) {
        if(users != nil){
            //loop through users in parse
            for (int i = 0; i < users.count; i++){
                NSMutableDictionary *review = [NSMutableDictionary new];
                //accessing reviews a user has written
                NSArray *userReviews = users[i][@"reviews"];
                if(userReviews.count > 0){
                    for(int j = 0; j <userReviews.count; j++){
                        //accesses review in parse, where key is string movieID and object is content
                        NSDictionary *currentReview = userReviews[j];
                        //accessing array of movieId keys (there is only 1 for each review, but still an array)
                        NSArray *movieKey = [currentReview allKeys];
                        if([movieKey[0] isEqualToString:[self.movie.movieID stringValue]]){
                            //sets dictionary keys to be the same as from API call
                            [review setObject:users[i][@"username"] forKey:@"author"];
                            [review setObject:[currentReview allValues][0] forKey:@"content"];
                            [communityReviews addObject:review];
                        }
                    }
                }
            }
        }
    }];
    [[APIManager shared] getReviews:[self.movie.movieID stringValue] completion:^(NSArray *reviews, NSError *error) {
        if(error != nil){
            NSLog(@"%@", [error localizedDescription]);
        }
        else{
            NSLog(@"Successfully fetched reviews");
           // self.reviews = reviews;
            if(reviews.count > 0){
                for(int i = 0; i < reviews.count; i++){
                    //append review to list
                    [communityReviews addObject:reviews[i]];
                }
            }
            self.reviews = communityReviews;
            if(self.reviews.count == 0){
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"No Reviews" message:@"This movie has no reviews" preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                [alert addAction:okAction];
                [self presentViewController:alert animated:YES completion:^{
                    
                }];
            }
            
    
            [self.tableView reloadData];
        }
        [self.HUD dismissAnimated:YES];
    }];
}



@end
