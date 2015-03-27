//
//  SMSView.m
//  Athledo
//
//  Created by Dinesh Kumar on 3/26/15.
//  Copyright (c) 2015 Dinesh. All rights reserved.
//

#import "SMSView.h"
#import "SWRevealViewController.h"
#import "MessageInboxCell.h"
#import "SMSCustomCell.h"

@interface SMSView ()
{
    NSArray *arrSmsListData;
    NSArray *arrNUmber;
    NSMutableArray *arrFilterdData;
    UIToolbar *toolBar;
}

@end

@implementation SMSView

#pragma mark UIViewController life cyle

- (void)viewDidLoad {
    [super viewDidLoad];
    toolBar = [[SingletonClass ShareInstance] toolBarWithDoneButton:self.view];
    self.title = @"Send sms";
    arrSmsListData = [[NSArray alloc] initWithObjects:[NSDictionary dictionaryWithObject:@"Dinesh kumar" forKey:@"name"],[NSDictionary dictionaryWithObject:@"Nishant kumar" forKey:@"name"],[NSDictionary dictionaryWithObject:@"Varsha" forKey:@"name"], nil];
    
    arrFilterdData = [[NSMutableArray alloc] init];
    [arrFilterdData addObjectsFromArray:arrSmsListData];
    _textview.layer.borderWidth = .5;
    _textview.layer.cornerRadius = 9;
    _textview.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.navigationController.navigationBar.titleTextAttributes= [NSDictionary dictionaryWithObjectsAndKeys:
                                                                  [UIColor lightGrayColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:NavFontSize],NSFontAttributeName,nil];
    self.navigationController.navigationBar.tintColor=[UIColor lightGrayColor];
    
    SWRevealViewController *revealController = [self revealViewController];
    
    [self.navigationController.navigationBar addGestureRecognizer:revealController.panGestureRecognizer];
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    [self.view addGestureRecognizer:revealController.tapGestureRecognizer];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                         style:UIBarButtonItemStyleBordered target:revealController action:@selector(revealToggle:)];
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    self.navigationItem.leftBarButtonItem.tintColor=[UIColor lightGrayColor];
    self.navigationItem.rightBarButtonItem.tintColor=[UIColor whiteColor];
    self.navigationController.navigationBar.tintColor=[UIColor lightGrayColor];
    
    UIButton *btnSave = [[UIButton alloc] initWithFrame:CGRectMake(160, 0, 50, 30)];
    [btnSave addTarget:self action:@selector(SendSMS:) forControlEvents:UIControlEventTouchUpInside];
    [btnSave setTitle:@"Send" forState:UIControlStateNormal];
    [btnSave setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UIBarButtonItem *ButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnSave];
    self.navigationItem.rightBarButtonItem = ButtonItem;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark CellDelegate
-(void)CheckBoxEvent:(id)sender
{
    UIButton *btn = sender;
    NSLog(@"check box index %i",btn.tag);
    
    if (btn.state== UIControlStateSelected) {
        
        [btn setImage:[UIImage imageNamed:@"btnDissable.png"] forState:UIControlStateNormal];
    }else
    {
        [btn setImage:[UIImage imageNamed:@"btnEnable.png"] forState:UIControlStateSelected];

    }
}

#pragma mark- UITableview Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrFilterdData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SMScustomCell";
    static NSString *CellNib = @"SMSCustomCell";
    SMSCustomCell *cell = (SMSCustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellNib owner:self options:nil];
        cell = (SMSCustomCell *)[nib objectAtIndex:0];
    }
    @try {
        
        cell.lblName.text=[[arrFilterdData objectAtIndex:indexPath.row] valueForKey:@"name"];
        cell.lblName.textColor = [UIColor darkGrayColor];
        cell.lblName.font = Textfont;
        cell.lblPhoneNumber.text=@"9718937613";
        cell.lblPhoneNumber.textColor = [UIColor lightGrayColor];
        cell.lblPhoneNumber.font = Textfont;
        cell.btnSelectContact.tag = indexPath.row;
        cell.cellDelegate=self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.btnSelectContact setImage:[UIImage imageNamed:@"btnDissable.png"] forState:UIControlStateNormal];
        
    }
    @catch (NSException *exception) {
    }
    @finally {
        
    }

    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.selected) {
        
    }
}
#pragma mark SearchBar Delegate
#pragma SearchBar Delegate
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton=NO;
    [searchBar resignFirstResponder];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton=YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [arrFilterdData removeAllObjects];
    [_tableview reloadData];
    searchBar.showsCancelButton=NO;
    [searchBar resignFirstResponder];
}
- (void)searchBarSearchButtonClicked:(UISearchBar*)theSearchBar
{
    @try {
        if (arrFilterdData.count == 0) {
            [SingletonClass initWithTitle:@"" message:@"No Notes" delegate:nil btn1:@"Ok"];
        }
        if(theSearchBar.text.length>0)
        {
            if ([SingletonClass  CheckConnectivity]) {
                //Check for empty Text box
                NSString *strError = @"";
                if(theSearchBar.text.length < 1 )
                {
                    strError = @"Please enter searching text";
                }
                if(strError.length > 1)
                {
                    [SingletonClass initWithTitle:@"" message:strError delegate:nil btn1:@"Ok"];
                    return;
                }else{
                    [arrFilterdData removeAllObjects];
                    NSPredicate *lowerCase= [NSPredicate predicateWithFormat:
                                             [@"SELF['name'] CONTAINS " stringByAppendingFormat:@"\'%@\'",[theSearchBar.text lowercaseString]]];
                    NSPredicate *orginaltext = [NSPredicate predicateWithFormat:
                                                [@"SELF['phone'] CONTAINS " stringByAppendingFormat:@"\'%@\'",[[[theSearchBar.text substringToIndex:1] uppercaseString] stringByAppendingString:[theSearchBar.text substringFromIndex:1] ]]];
                    NSArray *res = [arrSmsListData  valueForKey:@"UserProfile"];
                    [arrFilterdData addObjectsFromArray:[res filteredArrayUsingPredicate:lowerCase]] ;
                    [arrFilterdData addObjectsFromArray:[res filteredArrayUsingPredicate:orginaltext]] ;
                    [_tableview reloadData];
                    [theSearchBar endEditing:YES];
                }
            }else{
                [SingletonClass initWithTitle:@"" message:@"Internet connection is not available" delegate:nil btn1:@"Ok"];
            }
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}
#pragma UITextview Delegate 
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    textView.text = @"";
    
    return YES;
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    
}


#pragma mark Class Utility
-(void)SendSMS:(id)sender
{
    
}

@end
