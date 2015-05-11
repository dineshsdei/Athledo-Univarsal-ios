//
//  History.m
//  Athledo
//
//  Created by Dinesh Kumar on 4/1/15.
//  Copyright (c) 2015 Dinesh. All rights reserved.
//

#import "History.h"
#import "SMSCustomCell.h"

@interface History ()
{
    NSArray *historyDic;
    NSMutableArray *arrFilterdData;
}

@end

@implementation History
#pragma mark UIViewController life cycle Method
- (void)viewDidLoad {
    self.title = @"SMS History";
    arrFilterdData = [[NSMutableArray alloc] init];
    self.navigationController.navigationBar.titleTextAttributes= [NSDictionary dictionaryWithObjectsAndKeys:
                                                                  NAVIGATION_COMPONENT_COLOR,NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:NavFontSize],NSFontAttributeName,nil];
    self.navigationController.navigationBar.tintColor=NAVIGATION_COMPONENT_COLOR;
    [self getSMSHistoryData];
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark SearchBar Delegate
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
    [arrFilterdData addObjectsFromArray:historyDic];
    [_tableView reloadData];
    [SingletonClass deleteUnUsedLableFromTable:_tableView];
    searchBar.showsCancelButton=NO;
    [searchBar resignFirstResponder];
}
- (void)searchBarSearchButtonClicked:(UISearchBar*)theSearchBar
{
    @try {
        if (arrFilterdData.count == 0) {
            arrFilterdData.count == 0 ? [_tableView addSubview:[SingletonClass ShowEmptyMessage:@"No SMS history"]] :[SingletonClass deleteUnUsedLableFromTable:_tableView];
        }
        if(theSearchBar.text.length>0)
        {
            if ([SingletonClass  CheckConnectivity]) {
                //Check for empty Text box
                NSString *strError = EMPTYSTRING;
                if(theSearchBar.text.length < 1 )
                {
                    strError = @"Please enter searching text";
                }
                if(strError.length > 1)
                {
                    [SingletonClass initWithTitle:EMPTYSTRING message:strError delegate:nil btn1:@"Ok"];
                    return;
                }else{
                    [arrFilterdData removeAllObjects];
                    [self PrepareSearchPredicate:theSearchBar.text];
                    [_tableView reloadData];
                    [theSearchBar endEditing:YES];
                    arrFilterdData.count == 0 ? [_tableView addSubview:[SingletonClass ShowEmptyMessage:@"No SMS history"]] :[SingletonClass deleteUnUsedLableFromTable:_tableView];
                }
            }else{
                [SingletonClass initWithTitle:EMPTYSTRING message:INTERNET_NOT_AVAILABLE delegate:nil btn1:@"Ok"];
            }
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
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
    static NSString *CellIdentifier = @"SMShistoryCell";
    static NSString *CellNib = @"SMSHistoryCell";
    SMSHistoryCell *cell = (SMSHistoryCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellNib owner:self options:nil];
        cell = (SMSHistoryCell *)[nib objectAtIndex:0];
        cell.lblSenderName.text = [[arrFilterdData objectAtIndex:indexPath.row]valueForKey:@"reciever"] ?   [[arrFilterdData objectAtIndex:indexPath.row]valueForKey:@"reciever"] : EMPTYSTRING;
        cell.lblDate.text = [self dateFormate:[[arrFilterdData objectAtIndex:indexPath.row]valueForKey:@"sentTime"]];
        cell.txtViewMessage.text = [[arrFilterdData objectAtIndex:indexPath.row]valueForKey:@"message"] ?   [[arrFilterdData objectAtIndex:indexPath.row] valueForKey:@"message"] : EMPTYSTRING;
        
        cell.lblSenderName.font = Textfont;
        cell.txtViewMessage.font = SmallTextfont;
        cell.txtViewMessage.textColor = LightGrayColor ;
        cell.lblDate.font = SmallTextfont;
    }
    @try {
        
    }
    @catch (NSException *exception) {
    }
    @finally {
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   return CELLHEIGHT;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
#pragma mark WebService Comunication Method
-(void)getSMSHistoryData{
    
    if ([SingletonClass  CheckConnectivity]) {
        WebServiceClass *webservice =[WebServiceClass shareInstance];
        webservice.delegate=self;
        UserInformation *userInfo=[UserInformation shareInstance];
        NSString *strURL = [NSString stringWithFormat:@"{\"team_id\":\"%d\",\"sport_id\":\"%d\"}",userInfo.userSelectedTeamid,userInfo.userSelectedSportid];
        [SingletonClass addActivityIndicator:self.view];
        [webservice WebserviceCall:webServiceGetSmsHistory :strURL :GetSmsHistoryData];
    }else{
        [SingletonClass initWithTitle:EMPTYSTRING message:INTERNET_NOT_AVAILABLE delegate:nil btn1:@"Ok"];
    }
}
-(void)WebserviceResponse:(NSMutableDictionary *)MyResults :(int)Tag
{
    [SingletonClass RemoveActivityIndicator:self.view];
    switch (Tag)
    {
        case GetSmsHistoryData :
        {
            if([[MyResults objectForKey:STATUS] isEqualToString:SUCCESS])
            {
                historyDic = [MyResults valueForKey:@"historyData"];
                [arrFilterdData addObjectsFromArray:historyDic];
                [_tableView reloadData];
                arrFilterdData.count == 0 ? [_tableView addSubview:[SingletonClass ShowEmptyMessage:@"No SMS history"]] :[SingletonClass deleteUnUsedLableFromTable:_tableView];
            }else{
                arrFilterdData.count == 0 ? [_tableView addSubview:[SingletonClass ShowEmptyMessage:@"No SMS history"]] :[SingletonClass deleteUnUsedLableFromTable:_tableView];
            }
            break;
        }
    }
}
#pragma mark Class Utility
-(void)PrepareSearchPredicate:(NSString *)theSearchBarText
{
    NSPredicate *lowerCase= [NSPredicate predicateWithFormat:
                             [@"SELF['reciever'] CONTAINS " stringByAppendingFormat:@"\'%@\'",[theSearchBarText lowercaseString]]];
    NSPredicate *orginaltext = [NSPredicate predicateWithFormat:
                                [@"SELF['reciever'] CONTAINS " stringByAppendingFormat:@"\'%@\'",[[[theSearchBarText substringToIndex:1] uppercaseString] stringByAppendingString:[theSearchBarText substringFromIndex:1] ]]];
    NSPredicate *messageLowerCase= [NSPredicate predicateWithFormat:
                                    [@"SELF['message'] CONTAINS " stringByAppendingFormat:@"\'%@\'",[theSearchBarText lowercaseString]]];
    NSPredicate *messageOrginaltext = [NSPredicate predicateWithFormat:
                                       [@"SELF['message'] CONTAINS " stringByAppendingFormat:@"\'%@\'",[[[theSearchBarText substringToIndex:1] uppercaseString] stringByAppendingString:[theSearchBarText substringFromIndex:1] ]]];
    
    [arrFilterdData addObjectsFromArray:[historyDic filteredArrayUsingPredicate:lowerCase]] ;
    [arrFilterdData addObjectsFromArray:[historyDic filteredArrayUsingPredicate:orginaltext]] ;
    [arrFilterdData addObjectsFromArray:[historyDic filteredArrayUsingPredicate:messageLowerCase]] ;
    [arrFilterdData addObjectsFromArray:[historyDic filteredArrayUsingPredicate:messageOrginaltext]] ;
}
-(NSString *)dateFormate : (NSString *)strdate
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:DATE_FORMAT_Y_M_D_H_M_S];
    NSDate *date=[df dateFromString:strdate];
    [df setDateFormat:DATE_FORMAT_M_D_Y_H_M];
    if(date==nil)
    {
        return EMPTYSTRING;
    }else{
        return [NSString stringWithFormat:@"%@", [df stringFromDate:date]];
    }
}
@end
