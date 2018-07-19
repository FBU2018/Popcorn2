//
//  PCReviewViewController.m
//  Popcorn
//
//  Created by Sarah Embry on 7/19/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import "PCReviewViewController.h"
#import "ReviewCell.h"

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

//move to APIManager later
-(void) fetchReviews{
    NSString *movieID = [self.movie.movieID stringValue];
    NSString *apiKey = @"69308a1aa1f4a3c54b17a53c591eadb0";
    NSString *urlString = [[[@"https://api.themoviedb.org/3/movie/" stringByAppendingString:movieID]stringByAppendingString:@"/reviews?api_key="]stringByAppendingString:apiKey];
    
    NSURL *url = [NSURL URLWithString: urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
        else {
            NSLog(@"successfully fetched reviews");
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            self.reviews = dataDictionary[@"results"];
            //NSLog(@"%@", self.reviews);
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
    [task resume];
}

- (IBAction)didTapDone:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
