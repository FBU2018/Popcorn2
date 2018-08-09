
//
//  PCMovieDiscussionViewController.m
//  Popcorn
//
//  Created by Ernest Omondi on 7/31/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import "PCMovieDiscussionViewController.h"
#import "UIImageView+AFNetworking.h"
#import "Chat.h"
#import "ChatCell.h"
#import "myChatCell.h"

@interface PCMovieDiscussionViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *discussionPosterImageView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *chatMessageTextField;
@property (weak, nonatomic) IBOutlet UILabel *movieTitleLabel;
@property (strong, nonatomic) NSArray *chatsArray;
@property (weak, nonatomic) IBOutlet UIImageView *backdropImageView;
@end

@implementation PCMovieDiscussionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    // Remove table view row outlines
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // Set tableview delegate and datasource
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.chatMessageTextField.delegate = self;
    
    // Set Poster image at the top Screen
    [self.discussionPosterImageView setImageWithURL:self.movie.posterUrl placeholderImage:[UIImage imageNamed:@"poster-placeholder.png"]];
    // Set Movie Title
    self.movieTitleLabel.text = self.movie.title;
    // Set Backdrop Image
    [self.backdropImageView setImageWithURL:self.movie.backdropUrl];
    
    // refresh the chats every second
    //[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshChats) userInfo:nil repeats:true];
    [self refreshChats];
}

-(void)dismissKeyboard {
    [self.chatMessageTextField resignFirstResponder];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.3];
    [UIView setAnimationBeginsFromCurrentState:TRUE];
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y -200., self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
    
    
}


-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.3];
    [UIView setAnimationBeginsFromCurrentState:TRUE];
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y +200., self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
    
}

-(void)refreshChats{
    // Get chats
    PFQuery *chatQuery = [PFQuery queryWithClassName:@"Chat"];
    
    // Sort by descending order
    [chatQuery orderByAscending:@"createdAt"];
    [chatQuery whereKey:@"movieID" equalTo:self.movie.movieID];
    
    // Fetch chats asynchronously
    [chatQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable chats, NSError * _Nullable error) {
        if(error == nil){
            // Add returned chat objects that are not in the local array
            NSMutableArray *array = [[NSMutableArray alloc] initWithArray:self.chatsArray];
            for(int i = 0; i < [chats count]; i++){
                if(i < [array count] && [array count] != 0){
                    Chat *chatElement = [chats objectAtIndex:i];
                    Chat *arrayElement = [array objectAtIndex:i];
                    if(![chatElement.message isEqualToString:arrayElement.message]){
                        [array addObject:chatElement];
                    }
                }
                else{
                    Chat *object = [chats objectAtIndex:i];
                    [array addObject:object];
                }
            }
            self.chatsArray = [NSArray arrayWithArray:array];
            [self.tableView reloadData];
        }
        else {
            NSLog(@"Error querying chats: %@", error.localizedDescription);
        }
    }];
}

// User taps send to send a chat message
- (IBAction)didTapSend:(id)sender {
    // Create a chat object and store the message, the user's object id and the movie they are talking about
    
    if([self.chatMessageTextField.text isEqualToString:@""]){
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Chat Message Cannot Be Empty" message: nil preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else{
        Chat *chat = [Chat object];
        chat.message = self.chatMessageTextField.text;
        chat.userObjectId = PFUser.currentUser.objectId;
        chat.username = PFUser.currentUser.username;
        chat.movieID = self.movie.movieID;
        
        // Store the time the chat was created
        NSDate *now = [NSDate date];
        NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
        [outputFormatter setDateFormat:@"E MMM d HH:mm:ss Z y"];
        chat.createdAtString = [outputFormatter stringFromDate:now];
        
        // Save chat in Parse server
        [chat saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if(succeeded){
                NSLog(@"Chat successfully sent!");
            }
            else{
                NSLog(@"Problem sending chat : %@", error.localizedDescription);
            }
        }];
        // Clear text in the textfield
        self.chatMessageTextField.text = @"";
        
        // refresh table view and chats
        [self refreshChats];
    }
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSString *currentUsername = PFUser.currentUser.username;
    Chat *currentChat = self.chatsArray[indexPath.row];
    if([currentChat.username isEqualToString:currentUsername]){
        myChatCell *newCell = [tableView dequeueReusableCellWithIdentifier:@"myChatCell"];
        [newCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [newCell configureCellWithChat:currentChat];
        return newCell;
    }
    else{
        ChatCell *newCell = [tableView dequeueReusableCellWithIdentifier:@"chatCell"];
        [newCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [newCell configureCell:currentChat withUserObjectId:currentChat.userObjectId andIndexPath: indexPath andCurrentUsername:currentUsername];
        return newCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Chat *currentChat = self.chatsArray[indexPath.row];
    if([currentChat.username isEqualToString:PFUser.currentUser.username]){
        // My Chats
        NSString *cellText = currentChat.message;
        UIFont *cellFont = [UIFont systemFontOfSize:16.0];
        CGSize constraintSize = CGSizeMake(263, MAXFLOAT);
        UIColor *color = [UIColor colorWithRed:48.0f/255.0f
                                         green:48.0f/255.0f
                                          blue:48.0f/255.0f
                                         alpha:1.0f];
        NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                              cellFont, NSFontAttributeName,
                                              color, NSForegroundColorAttributeName,
                                              nil];
        CGSize labelSize2 = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
        CGRect labelSize = [cellText boundingRectWithSize:constraintSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributesDictionary context:nil];
        
        
        return labelSize2.height + 30;
    }
    else{
        // Other Chats
        NSString *cellText = currentChat.message;
        UIFont *cellFont = [UIFont systemFontOfSize:16.0];
        CGSize constraintSize = CGSizeMake(263, MAXFLOAT);
        UIColor *color = [UIColor colorWithRed:48.0f/255.0f
                                         green:48.0f/255.0f
                                          blue:48.0f/255.0f
                                         alpha:1.0f];
        NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                              cellFont, NSFontAttributeName,
                                              color, NSForegroundColorAttributeName,
                                              nil];
        CGSize labelSize2 = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByCharWrapping];
        CGRect labelSize = [cellText boundingRectWithSize:constraintSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributesDictionary context:nil];
        
        if([cellText length] <= 90){
            return labelSize2.height + 50;
        }
        else{
            return labelSize2.height + 80;
        }
    }
    
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.chatsArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */



@end
