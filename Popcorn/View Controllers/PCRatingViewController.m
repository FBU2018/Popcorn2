//
//  PCRatingViewController.m
//  Popcorn
//
//  Created by Sarah Embry on 7/19/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import "PCRatingViewController.h"

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
    [self postRating];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) postRating{
    //post request to add item to list
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString *urlString = [[@"https://api.themoviedb.org/4/list/" stringByAppendingString:shelfId] stringByAppendingString:@"/items"];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    //headers
    [request addValue:@"application/json;charset=utf-8" forHTTPHeaderField: @"Content-Type"];
    
    //request body + variables
    NSDictionary *itemDict = [[NSDictionary alloc] initWithObjectsAndKeys: item.mediaType,@"media_type",item.movieID, @"media_id", nil];
    NSArray *itemArr = [[NSArray alloc] initWithObjects:itemDict, nil];
    NSDictionary *userDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:itemArr, @"items", nil];
    
    if ([NSJSONSerialization isValidJSONObject:userDictionary]) {
        NSError* error;
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:userDictionary options:NSJSONWritingPrettyPrinted error: &error];
        [request setHTTPBody:jsonData];
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
        
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if(error != nil){
                NSLog(@"Error: %@", error.localizedDescription);
                completion(error);
            }
            else{
                NSLog(@"Request successful");
                completion(nil);
            }
        }];
        [task resume];
    }
}

@end
