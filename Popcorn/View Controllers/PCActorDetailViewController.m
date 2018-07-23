//
//  PCActorDetailViewController.m
//  Popcorn
//
//  Created by Sarah Embry on 7/20/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import "PCActorDetailViewController.h"
#import "UIImageView+AFNetworking.h"

@interface PCActorDetailViewController ()
@property (strong, nonatomic) NSDictionary *actorDetails;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *knownForLabel;
@property (weak, nonatomic) IBOutlet UILabel *birthdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *birthplaceLabel;
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;
@end

@implementation PCActorDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self fetchActorDetails];
   // [self configureDetails];
    NSLog(@"%@", self.actorDetails);
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

- (void)getActorDetails:(NSString *)actorID completion:(void (^)(NSDictionary *, NSError *))completion{
    NSString *apiKey = @"15703e94357b9dc777959d930e92e7dc";
    NSString *urlString = [[[[@"https://api.themoviedb.org/3/person/" stringByAppendingString:actorID]stringByAppendingString:@"?api_key="] stringByAppendingString:apiKey] stringByAppendingString:@"&language=en-US"];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error != nil){
            NSLog(@"%@", [error localizedDescription]);
            completion(nil, error);
        }
        else{
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            completion(dataDictionary, nil);
        }
    }];
    [task resume];
}

- (void)fetchActorDetails{
    [self getActorDetails:[self.actorID stringValue] completion:^(NSDictionary *results, NSError *error) {
        if(error != nil){
            NSLog(@"%@", [error localizedDescription]);
        }
        else{
            self.actorDetails = results;
       //NSLog(@"%@", self.actorDetails);
            [self configureDetails];
        }
    }];
   
}

-(void) configureDetails{
    NSString *urlString = [@"https://image.tmdb.org/t/p/w500" stringByAppendingString:self.actorDetails[@"profile_path"]];
    [self.profileImageView setImageWithURL:[NSURL URLWithString:urlString]];
    self.nameLabel.text = self.actorDetails[@"name"];
    self.knownForLabel.text = [@"Known for " stringByAppendingString:self.actorDetails[@"known_for_department"]];
    self.birthdayLabel.text = self.actorDetails[@"birthday"];
    self.birthplaceLabel.text = self.actorDetails[@"place_of_birth"];
    self.bioLabel.text = self.actorDetails[@"biography"];
}

@end
