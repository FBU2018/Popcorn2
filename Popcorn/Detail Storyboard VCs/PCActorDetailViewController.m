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
#import "PCMovieDetailViewController.h"
#import "Movie.h"
#import "JGProgressHUD.h"
#import "ShadowButton.h"

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
@property (strong, nonatomic) JGProgressHUD *HUD;
@property (weak, nonatomic) IBOutlet UILabel *bioHeaderLabel;
@property (weak, nonatomic) IBOutlet UILabel *filmographyHeaderLabel;
//@property (weak, nonatomic) IBOutlet ShadowButton *bioButton;
@end

@implementation PCActorDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.creditsCollectionView.delegate = self;
    self.creditsCollectionView.dataSource = self;
    
    self.HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    self.HUD.textLabel.text = @"Loading";
    [self.HUD showInView:self.view];
    
    //format collection view to be horizontal
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.creditsCollectionView.collectionViewLayout;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 2;
    
    self.nameLabel.text = @"";
    self.knownForLabel.text = @"";
    self.birthdayLabel.text = @"";
    self.birthplaceLabel.text = @"";
    self.bioLabel.text = @"";
    self.bioHeaderLabel.text = @"";
    self.filmographyHeaderLabel.text = @"";
    self.bioButton.hidden = YES;
    
    [self fetchActorDetails];
    [self fetchCredits];
    [self.HUD dismissAnimated:YES];
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
    if([segue.identifier isEqualToString:@"filmographyToMovieDetail"]){
        UICollectionViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.creditsCollectionView indexPathForCell:tappedCell];
        PCMovieDetailViewController *receiver = [segue destinationViewController];
        Movie *movie = [[Movie alloc]initWithDictionary:self.actorCredits[indexPath.item]]; 
        receiver.movie = movie;
    }
}




-(void) configureDetails{
    [self.profileImageView setImage:[UIImage imageNamed:@"person placeholder.png"]];
    self.bioHeaderLabel.text = @"Biography";
    self.filmographyHeaderLabel.text = @"Filmography";
    
    if(![self.actorDetails[@"profile_path"] isEqual:[NSNull null]]){
        NSString *urlString = [@"https://image.tmdb.org/t/p/w500" stringByAppendingString:self.actorDetails[@"profile_path"]];
        [self.profileImageView setImageWithURL:[NSURL URLWithString:urlString]];
     }
    
    self.nameLabel.text = self.actorDetails[@"name"];
    
    if(![self.actorDetails[@"known_for_department"] isEqual:[NSNull null]]){
        self.knownForLabel.text = [@"Department: " stringByAppendingString:self.actorDetails[@"known_for_department"]];
    }
    else{
        self.knownForLabel.text = @"Unknown department";
    }
    
    if(![self.actorDetails[@"birthday"] isEqual: [NSNull null]]){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *dateFromString = [dateFormatter dateFromString:self.actorDetails[@"birthday"]];
        [dateFormatter setDateFormat:@"MMM dd, yyyy"];
        self.birthdayLabel.text = [@"Birthday: " stringByAppendingString: [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:dateFromString]]];
    }
    else{
        self.birthdayLabel.text = @"Unknown birthday";
    }
    
    if(![self.actorDetails[@"place_of_birth"] isEqual: [NSNull null]]){
        self.birthplaceLabel.text = [@"Birthplace: " stringByAppendingString: self.actorDetails[@"place_of_birth"]];
    }
    else{
        self.birthplaceLabel.text = @"Unknown birthplace";
    }
    
    if(![self.actorDetails[@"biography"] isEqualToString:@""]){
        self.bioLabel.text = self.actorDetails[@"biography"];
        self.bioButton.hidden = NO;
    }
    else{
        self.bioLabel.text = @"No biography information.";
        self.bioButton.hidden = YES;
        [self.bioLabel setUserInteractionEnabled:NO];
    }
}


//- (IBAction)didTapArrow:(id)sender {
//    [self performSegueWithIdentifier:@"actorDetailsToBio" sender:self];
//}

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
         //   NSLog(@"%@", self.actorDetails);
            [self configureDetails];
            
        }
    }];
    
}

@end
