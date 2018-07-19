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

@end

@implementation PCReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchReviews];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

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
            NSLog(@"%@", self.reviews);
            [self.tableView reloadData];
        }
    }];
    [task resume];
}

@end
