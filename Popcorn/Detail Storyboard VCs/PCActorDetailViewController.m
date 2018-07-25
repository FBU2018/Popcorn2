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
#import "ActorCreditsCollectionViewCell.h"
#import "APIManager.h"

@interface PCActorDetailViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) NSDictionary *actorDetails;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *knownForLabel;
@property (weak, nonatomic) IBOutlet UILabel *birthdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *birthplaceLabel;
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;
@property (weak, nonatomic) IBOutlet UIButton *bioButton;
@property (weak, nonatomic) IBOutlet UICollectionView *creditsCollectionView;
- (IBAction)didTapBio:(id)sender;
@end

@implementation PCActorDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.creditsCollectionView.delegate = self;
    self.creditsCollectionView.dataSource = self;
    
    //format collection view to be horizontal
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.creditsCollectionView.collectionViewLayout;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 2;
    
    [self fetchActorDetails];
    [self fetchCredits];
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
    
    if(![self.actorDetails[@"biography"] isEqualToString:@""]){
        self.bioLabel.text = self.actorDetails[@"biography"];
    }
    else{
        self.bioLabel.text = @"No biography information.";
        self.bioButton.hidden = YES;
        [self.bioLabel setUserInteractionEnabled:NO];
    }
}


- (IBAction)didTapBio:(id)sender {
    [self performSegueWithIdentifier:@"actorDetailsToBio" sender:self];
}



- (void)fetchCredits{
    [[APIManager shared] getCredits:[self.actorID stringValue] completion:^(NSArray *credits, NSError *error) {
        if(error == nil){
            self.actorCredits = credits;
            //NSLog(@"%@", credits);
        }
    [self.creditsCollectionView reloadData];
    }];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ActorCreditsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"actorCreditsCollectionViewCell" forIndexPath:indexPath];
    [cell configureCell:self.actorCredits atIndexPath:indexPath];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.actorCredits.count;
}

- (void)fetchActorDetails{
    [[APIManager shared]getActorDetails:[self.actorID stringValue] completion:^(NSDictionary *results, NSError *error) {
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

@end
