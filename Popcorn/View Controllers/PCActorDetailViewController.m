//
//  PCActorDetailViewController.m
//  Popcorn
//
//  Created by Sarah Embry on 7/20/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import "PCActorDetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "PCActorBioViewController.h"

@interface PCActorDetailViewController ()
@property (strong, nonatomic) NSDictionary *actorDetails;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *knownForLabel;
@property (weak, nonatomic) IBOutlet UILabel *birthdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *birthplaceLabel;
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;
@property (weak, nonatomic) IBOutlet UIButton *bioButton;
- (IBAction)didTapBio:(id)sender;
@end

@implementation PCActorDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self fetchActorDetails];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"actorDetailsToBio"]){
        PCActorBioViewController *receiver = [segue destinationViewController];
        receiver.bio = self.actorDetails[@"biography"];
    }
}


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
            NSLog(@"%@", self.actorDetails);
            [self configureDetails];
        }
    }];
   
}

-(void) configureDetails{
    [self.profileImageView setImage:[UIImage imageNamed:@"person placeholder.png"]];
    if(![self.actorDetails[@"profile_path"] isEqual:[NSNull null]]){
        NSString *urlString = [@"https://image.tmdb.org/t/p/w500" stringByAppendingString:self.actorDetails[@"profile_path"]];
        [self.profileImageView setImageWithURL:[NSURL URLWithString:urlString]];
     }
    
    self.nameLabel.text = self.actorDetails[@"name"];
    
    if(![self.actorDetails[@"known_for_department"] isEqual:[NSNull null]]){
        self.knownForLabel.text = [@"Known for " stringByAppendingString:self.actorDetails[@"known_for_department"]];
    }
    
    if(![self.actorDetails[@"birthday"] isEqual: [NSNull null]]){
        self.birthdayLabel.text = self.actorDetails[@"birthday"];
    }
    else{
        self.birthdayLabel.text = @"Unknown birthday";
    }
    
    if(![self.actorDetails[@"place_of_birth"] isEqual: [NSNull null]]){
        self.birthplaceLabel.text = self.actorDetails[@"place_of_birth"];
    }
    else{
        self.birthplaceLabel.text = @"Unknown birthplace";
    }
    
    if(![self.actorDetails[@"biography"] isEqual:[NSNull null]]){
        self.bioLabel.text = self.actorDetails[@"biography"];
    }
    else{
        self.bioLabel.text = @"No biography information.";
        self.bioButton.hidden = YES;
    }
}

- (IBAction)didTapBio:(id)sender {
    [self performSegueWithIdentifier:@"actorDetailsToBio" sender:self];
}
@end
