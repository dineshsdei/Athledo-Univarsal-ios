//
//  AddCalendarEvent.m
//  Athledo
//
//  Created by Smartdata on 10/16/14.
//  Copyright (c) 2014 Athledo Inc. All rights reserved.
//

#import "AddCalendarEvent.h"
#import "CalendarMonthViewController.h"
#import "MJGeocoder.h"
#import "RepeatCalendarEvent.h"
#import "CalendarDayViewController.h"
#import "WeekViewController.h"

@interface AddCalendarEvent ()
{
    
    UITextField *currentText;
    WebServiceClass *webservice;
    NSString *strLat;
    NSString *strLong;
    NSString *strAddBeforeTag;
    NSString *strNaveegatorStatus;
    BOOL isDate;
    UIToolbar *toolBar;
    BOOL SaveWithoutChange;
    UIDeviceOrientation CurrentOrientation;
}
@end
@implementation AddCalendarEvent
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)WebserviceResponse:(NSMutableDictionary *)MyResults :(int)Tag
{
    [SingletonClass RemoveActivityIndicator:self.view];
    switch (Tag)
    {
        case AddEventTag:
        {
            if([[MyResults objectForKey:STATUS] isEqualToString:SUCCESS])
            {// Now we Need to decrypt data
                self.navigationItem.rightBarButtonItem.enabled=YES;
                [SingletonClass ShareInstance].isCalendarUpdate=TRUE;
                [SingletonClass initWithTitle:EMPTYSTRING message:@"Event has been saved successfully" delegate:self btn1:@"Ok"];
            }else {
                self.navigationItem.rightBarButtonItem.enabled=YES;
                [SingletonClass initWithTitle:EMPTYSTRING message:@"Event have not saved" delegate:nil btn1:@"Ok"];
            }
            break;
        } case DeleteEventTag:
        {
            if([[MyResults objectForKey:STATUS] isEqualToString:SUCCESS])
            {// Now we Need to decrypt data
                self.navigationItem.rightBarButtonItem.enabled=YES;
                [SingletonClass ShareInstance].isCalendarUpdate=TRUE;
                [SingletonClass initWithTitle:EMPTYSTRING message:@"Event delete successfully" delegate:self btn1:@"Ok"];
            }else {
                self.navigationItem.rightBarButtonItem.enabled=YES;
                [SingletonClass initWithTitle:EMPTYSTRING message:@"Event didn't delete" delegate:nil btn1:@"Ok"];
            }
            break;
        }
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [SingletonClass RemoveActivityIndicator:self.view];
    if (alertView.tag==10) {
        
        if (buttonIndex==0) {
            [self deleteEvent];
        }
        
        
    }else{
        
        if (buttonIndex == 0) {
            NSArray *arrController=[self.navigationController viewControllers];
            BOOL Status=FALSE;
            for (id object in arrController)
            {
                if ([_strMoveControllerName isEqualToString:@"CalendarMonthViewController"]) {
                    
                    if ([object isKindOfClass:[CalendarMonthViewController class]])
                    {
                        Status=TRUE;
                        [self.navigationController popToViewController:object animated:NO];
                        return;
                    }
                }else   if ([_strMoveControllerName isEqualToString:@"CalendarDayViewController"])
                {
                    for (int i=0; i< arrController.count; i++) {
                        
                        if ([[arrController objectAtIndex:i] isKindOfClass:[CalendarDayViewController class]])
                        {
                            CalendarDayViewController *annView=[[CalendarDayViewController alloc] init];
                            NSArray *vCs=[[self navigationController] viewControllers];
                            NSMutableArray *nvCs=nil;
                            //remove the view controller before the current view controller
                            nvCs=[[NSMutableArray alloc]initWithArray:vCs];
                            [nvCs replaceObjectAtIndex:i withObject:annView];
                            [[self navigationController] setViewControllers:nvCs];
                            [self.navigationController popToViewController:annView animated:NO];
                            Status=TRUE;
                            return;
                        }
                    }
                }else   if ([_strMoveControllerName isEqualToString:@"WeekViewController"])
                {
                    if ([object isKindOfClass:[WeekViewController class]])
                    {
                        Status=TRUE;
                        [self.navigationController popToViewController:object animated:NO];
                        return;
                    }
                }
            }
            if (Status==FALSE)
            {
                if ([_strMoveControllerName isEqualToString:@"CalendarMonthViewController"])
                {
                    CalendarMonthViewController *annView=[[CalendarMonthViewController alloc] initWithNibName:@"CalendarMonthView" bundle:nil];
                    [self.navigationController pushViewController:annView animated:NO];
                    
                }else if ([_strMoveControllerName isEqualToString:@"CalendarDayViewController"])
                {
                    CalendarDayViewController *annView=[[CalendarDayViewController alloc] init];
                    [self.navigationController pushViewController:annView animated:NO];
                    
                }else if ([_strMoveControllerName isEqualToString:@"WeekViewController"]) {
                    
                    WeekViewController *annView=[[WeekViewController alloc] init];
                    [self.navigationController pushViewController:annView animated:NO];
                }
            }
            
        }else{
        }
    }
}
-(void)getLatLong:(NSString *)CityName
{
    MJGeocoder *forwardGeocoder = [[MJGeocoder alloc] init];
    forwardGeocoder.delegate = self;
    //show network indicator
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [forwardGeocoder findLocationsWithAddress:[NSString stringWithFormat:@"%@",CityName] title:nil];//
}

- (void)geocoder:(MJGeocoder *)geocoder didFindLocations:(NSArray *)locations{
    //hide network indicator
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    Address *addressModel =locations.count > 0 ? [locations objectAtIndex:0] : EMPTYSTRING;
    strLat= [NSString stringWithFormat:@"%f", addressModel.coordinate.latitude];
    strLong= [NSString stringWithFormat:@"%f",  addressModel.coordinate.longitude];
}
- (void)geocoder:(MJGeocoder *)geocoder didFailWithError:(NSError *)error
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    if([error code] == 1)
    {
        [SingletonClass initWithTitle:EMPTYSTRING message:@"Please enter valid city name" delegate:nil btn1:@"Ok"];
    }
}
-(int)CalculateTimeInterval :(NSString *)ActualstartDate :(NSString *)startDate
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat =DATE_FORMAT_Y_M_D_H_M_S;
    NSArray *ActualstartDatecomponenets=[ActualstartDate componentsSeparatedByString:STR_SPACE];
    NSArray *startDateDatecomponenets=[startDate componentsSeparatedByString:STR_SPACE];
    NSString *strFinalDate=[[startDateDatecomponenets objectAtIndex:0] stringByAppendingFormat:@" %@",[ActualstartDatecomponenets objectAtIndex:1]];
    NSDate *date=[df dateFromString:strFinalDate];
    double TotalStartDate=[date timeIntervalSince1970];
    //double timeAfterSubstract=TotalStartDate-((5*60*60)+(30*60));
    return (TotalStartDate);
}
-(void)DeleteEventAlert:(id)sender
{
    [SingletonClass initWithTitle:EMPTYSTRING message:@"Event will be deleted permanently, are you sure?" delegate:self btn1:@"YES" btn2:@"NO" tagNumber:10];
}
-(void)deleteEvent
{
    if ([SingletonClass  CheckConnectivity])
    {
        NSString *strAddBeforeParameter=EMPTYSTRING;
        NSString *strStatus=EMPTYSTRING;
        NSMutableDictionary* dicttemp = [[NSMutableDictionary alloc] init];
        if (_eventDetailsDic)
        {
            NSString *strValue=[_eventDetailsDic valueForKey:@"rec_type"] ? [_eventDetailsDic valueForKey:@"rec_type"] : EMPTYSTRING ;
            int deleteEventType=(strValue.length) > 0 ? ([[CalendarEvent ShareInstance].strEventEditBy isEqualToString:@"Edit Series"] ? 1 :2 ) : 3;
            
            switch (deleteEventType) {
                case 3:
                {
                    // Delete simple event
                    if ([[_eventDetailsDic valueForKey:@"event_pid"] intValue]==0) {
                        strAddBeforeParameter=[NSString stringWithFormat:@"%@_",[_eventDetailsDic valueForKey:@"event_id"]];
                        strStatus=@"delete";
                    }
                    else
                    {
                    }
                    [dicttemp setObject:strStatus forKey:[NSString stringWithFormat:@"%@%@", strAddBeforeParameter,@"!nativeeditor_status"]];
                    [dicttemp setObject:[_eventDetailsDic valueForKey:@"end_date"] forKey:[NSString stringWithFormat:@"%@%@",strAddBeforeParameter,@"end_date"]];
                    [dicttemp setObject:[_eventDetailsDic valueForKey:@"start_date"] forKey:[NSString stringWithFormat:@"%@%@",strAddBeforeParameter,@"start_date"]];
                    [dicttemp setObject:[_eventDetailsDic valueForKey:@"event_length"] forKey:[NSString stringWithFormat:@"%@%@",strAddBeforeParameter,@"event_length"]];
                    [dicttemp setObject:EMPTYSTRING forKey:[NSString stringWithFormat:@"%@%@",strAddBeforeParameter,@"event_pid"]];
                    [dicttemp setObject:[_eventDetailsDic valueForKey:@"event_id"] forKey:[NSString stringWithFormat:@"%@%@",strAddBeforeParameter,@"id"]];
                    [dicttemp setObject:[_eventDetailsDic valueForKey:@"location"] forKey:[NSString stringWithFormat:@"%@%@",strAddBeforeParameter,@"location"]];
                    [dicttemp setObject:[_eventDetailsDic valueForKey:Key_name] forKey:[NSString stringWithFormat:@"%@%@",strAddBeforeParameter,Key_name]];
                    [dicttemp setObject:EMPTYSTRING forKey:[NSString stringWithFormat:@"%@%@",strAddBeforeParameter,@"rec_pattern"]];
                    [dicttemp setObject:EMPTYSTRING forKey:[NSString stringWithFormat:@"%@%@",strAddBeforeParameter,@"rec_type"]];
                    [dicttemp setObject:[_eventDetailsDic valueForKey:@"text"] forKey:[NSString stringWithFormat:@"%@%@",strAddBeforeParameter,@"text"]];
                    [dicttemp setObject:[_eventDetailsDic valueForKey:@"event_id"] forKey:@"ids"];
                    break;
                }
                case 1:
                {
                    // Delete repeat type event of type Edit by series
                    
                    if ([[_eventDetailsDic valueForKey:@"event_pid"] intValue]==0) {
                        strAddBeforeParameter=[NSString stringWithFormat:@"%@_",[_eventDetailsDic valueForKey:@"event_id"]];
                        strStatus=@"delete";
                    }
                    [dicttemp setObject:strStatus forKey:[NSString stringWithFormat:@"%@%@", strAddBeforeParameter,@"!nativeeditor_status"]];
                    [dicttemp setObject:[_eventDetailsDic valueForKey:@"end_date"] forKey:[NSString stringWithFormat:@"%@%@",strAddBeforeParameter,@"end_date"]];
                    [dicttemp setObject:[_eventDetailsDic valueForKey:@"start_date"] forKey:[NSString stringWithFormat:@"%@%@",strAddBeforeParameter,@"start_date"]];
                    [dicttemp setObject:[_eventDetailsDic valueForKey:@"event_length"] forKey:[NSString stringWithFormat:@"%@%@",strAddBeforeParameter,@"event_length"]];
                    [dicttemp setObject:@"0" forKey:[NSString stringWithFormat:@"%@%@",strAddBeforeParameter,@"event_pid"]];
                    [dicttemp setObject:[_eventDetailsDic valueForKey:@"event_id"] forKey:[NSString stringWithFormat:@"%@%@",strAddBeforeParameter,@"id"]];
                    [dicttemp setObject:[_eventDetailsDic valueForKey:@"location"] forKey:[NSString stringWithFormat:@"%@%@",strAddBeforeParameter,@"location"]];
                    [dicttemp setObject:[_eventDetailsDic valueForKey:Key_name] forKey:[NSString stringWithFormat:@"%@%@",strAddBeforeParameter,Key_name]];
                    [dicttemp setObject:[[[_eventDetailsDic valueForKey:@"rec_type"] componentsSeparatedByString:@"#"] objectAtIndex:0] forKey:[NSString stringWithFormat:@"%@%@",strAddBeforeParameter,@"rec_pattern"]];
                    [dicttemp setObject:[_eventDetailsDic valueForKey:@"rec_type"] forKey:[NSString stringWithFormat:@"%@%@",strAddBeforeParameter,@"rec_type"]];
                    [dicttemp setObject:[_eventDetailsDic valueForKey:@"text"] forKey:[NSString stringWithFormat:@"%@%@",strAddBeforeParameter,@"text"]];
                    [dicttemp setObject:[strAddBeforeParameter stringByReplacingOccurrencesOfString:@"_" withString:EMPTYSTRING] forKey:@"ids"];
                    break;
                }
                case 2:
                {
                    // Delete repeat type event of type Edit by Occurrence
                    
                    if ([[_eventDetailsDic valueForKey:@"event_pid"] intValue]==0) {
                        
                        strAddBeforeParameter=@"1418618715293_";
                        strStatus=@"inserted";
                    }
                    [dicttemp setObject:strStatus forKey:[NSString stringWithFormat:@"%@%@", strAddBeforeParameter,@"!nativeeditor_status"]];
                    [dicttemp setObject:[_eventDetailsDic valueForKey:@"end_date"] forKey:[NSString stringWithFormat:@"%@%@",strAddBeforeParameter,@"end_date"]];
                    [dicttemp setObject:[_eventDetailsDic valueForKey:@"start_date"] forKey:[NSString stringWithFormat:@"%@%@",strAddBeforeParameter,@"start_date"]];
                    
                    [dicttemp setObject:[NSString stringWithFormat:@"%d",[self CalculateTimeInterval:[_eventDetailsDic valueForKey:@"actual_start_date"] :[_eventDetailsDic valueForKey:@"start_date"]]]  forKey:[NSString stringWithFormat:@"%@%@",strAddBeforeParameter,@"event_length"]];
                    
                    [dicttemp setObject:[_eventDetailsDic valueForKey:@"event_id"] forKey:[NSString stringWithFormat:@"%@%@",strAddBeforeParameter,@"event_pid"]];
                    [dicttemp setObject:[strAddBeforeParameter stringByReplacingOccurrencesOfString:@"_" withString:EMPTYSTRING] forKey:[NSString stringWithFormat:@"%@%@",strAddBeforeParameter,@"id"]];
                    [dicttemp setObject:[_eventDetailsDic valueForKey:@"location"] forKey:[NSString stringWithFormat:@"%@%@",strAddBeforeParameter,@"location"]];
                    [dicttemp setObject:[_eventDetailsDic valueForKey:@"lat"] forKey:[NSString stringWithFormat:@"%@%@",strAddBeforeParameter,@"lat"]];
                    [dicttemp setObject:[_eventDetailsDic valueForKey:@"lng"] forKey:[NSString stringWithFormat:@"%@%@",strAddBeforeParameter,@"lng"]];
                    [dicttemp setObject:[_eventDetailsDic valueForKey:Key_name] forKey:[NSString stringWithFormat:@"%@%@",strAddBeforeParameter,Key_name]];
                    [dicttemp setObject:@"none" forKey:[NSString stringWithFormat:@"%@%@",strAddBeforeParameter,@"rec_pattern"]];
                    [dicttemp setObject:@"none" forKey:[NSString stringWithFormat:@"%@%@",strAddBeforeParameter,@"rec_type"]];
                    [dicttemp setObject:[_eventDetailsDic valueForKey:@"text"] forKey:[NSString stringWithFormat:@"%@%@",strAddBeforeParameter,@"text"]];
                    [dicttemp setObject:[strAddBeforeParameter stringByReplacingOccurrencesOfString:@"_" withString:EMPTYSTRING] forKey:@"ids"];
                    break;
                }
                default:
                    break;
            }
        }
        [dicttemp setObject:@"mobile" forKey:@"interface"];
        [dicttemp setObject:[NSString stringWithFormat:@"%d",[UserInformation shareInstance].userType] forKey:@"type"];
        [dicttemp setObject:[NSString stringWithFormat:@"%d",[UserInformation shareInstance].userId] forKey:KEY_USER_ID];
        [dicttemp setObject:[NSString stringWithFormat:@"%d",[UserInformation shareInstance].userSelectedTeamid] forKey:KEY_TEAM_ID];
        [SingletonClass addActivityIndicator:self.view];
        [webservice WebserviceCallwithDic:dicttemp :webServiceAddEvents :DeleteEventTag];
    }else{
        self.navigationItem.rightBarButtonItem.enabled=YES;
        [SingletonClass initWithTitle:EMPTYSTRING message:INTERNET_NOT_AVAILABLE delegate:nil btn1:@"Ok"];
    }
}
-(void)CheckUserValueChange
{
    if ([CalendarEvent ShareInstance].CalendarRepeatStatus==TRUE)
    {
        if ([CalendarEvent ShareInstance].strRepeatSting.length==0) {
            
            SaveWithoutChange=TRUE;
        }else{
            
            SaveWithoutChange=FALSE;
        }
        [CalendarEvent ShareInstance].strStartDate=[CalendarEvent ShareInstance].strStartDate.length==0 ? [_eventDetailsDic valueForKey:@"start_date"] :[CalendarEvent ShareInstance].strStartDate;
        [CalendarEvent ShareInstance].strRepeatSting=[CalendarEvent ShareInstance].strRepeatSting.length==0 ? [_eventDetailsDic valueForKey:@"rec_type"] :[CalendarEvent ShareInstance].strRepeatSting;
    }
    
}
-(void)SaveEvent
{
    // Create startdate first because start time used in end date time
    [self CheckUserValueChange];
    if ([SingletonClass  CheckConnectivity])
    {
        self.navigationItem.rightBarButtonItem.enabled=NO;
        NSString *strError = EMPTYSTRING;
        if(_tfTitle.text.length < 1 )
        {
            strError = @"Please enter event title";
        }
        else if(_tfLocation.text.length < 1 )
        {
            //Not Mendatory
            //strError = @"Please enter event location";
        } else if(_texviewDescription.text.length < 1 )
        {
            //Not Mendatory
            
            // strError = @"Please enter event description";
        }else if(_tfStartTime.text.length < 1 )
        {
            strError = @"Please enter envent start date";
        }else if(_tfEndTime.text.length < 1 )
        {
            strError = @"Please enter end date";
        }
        if(strError.length>2)
        {
            self.navigationItem.rightBarButtonItem.enabled=YES;
            [SingletonClass initWithTitle:EMPTYSTRING message:strError delegate:nil btn1:@"Ok"];
            return;
            
        }
        if ([SingletonClass  CheckConnectivity])
        {
            UserInformation *userInfo=[UserInformation shareInstance];
            NSMutableDictionary* dicttemp = [[NSMutableDictionary alloc] init];
            
            if (_eventDetailsDic)
            {
                //Edit repeat or non repeat event
                if ([[_eventDetailsDic valueForKey:@"event_pid"] intValue]==0) {
                    
                    strAddBeforeTag=[NSString stringWithFormat:@"%@_",[_eventDetailsDic valueForKey:@"event_id"]];
                    strNaveegatorStatus=@"updated";
                }
                else
                {
                    strAddBeforeTag=[NSString stringWithFormat:@"%@_",[_eventDetailsDic valueForKey:@"event_id"]];
                    strNaveegatorStatus=@"updated";
                }
                [dicttemp setObject:[NSString stringWithFormat:@"%@",[_eventDetailsDic valueForKey:@"event_id"]] forKey:@"id"];
                // Edit repeat event two type edit by series or edit by occurrence
                if ([[CalendarEvent ShareInstance].strEventEditBy isEqualToString:@"Edit Series"]) {
                    
                    if([[CalendarEvent ShareInstance].strRepeatSting isEqualToString:EMPTYSTRING])
                    {
                        [CalendarEvent ShareInstance].strRepeatSting=[_eventDetailsDic valueForKey:@"rec_type"];
                    }
                    [dicttemp setObject:@"0" forKey:[NSString stringWithFormat:@"%@%@",strAddBeforeTag,@"event_pid"]];
                    [dicttemp setObject:[NSString stringWithFormat:@"%f",(endTime-startTime)] forKey:[NSString stringWithFormat:@"%@%@", strAddBeforeTag,@"event_length"]];
                }
                else if ([[CalendarEvent ShareInstance].strEventEditBy isEqualToString:@"Edit Occurrence"]){
                    
                    if([[CalendarEvent ShareInstance].strRepeatSting isEqualToString:EMPTYSTRING])
                    {
                        [CalendarEvent ShareInstance].strRepeatSting=[_eventDetailsDic valueForKey:@"rec_type"];
                    }
                    if ([[_eventDetailsDic valueForKey:@"event_pid"] intValue]==0) {
                        
                        strAddBeforeTag=@"1416899535876_";
                        strNaveegatorStatus=@"inserted";
                        [dicttemp setObject:[_eventDetailsDic valueForKey:@"event_id"] forKey:[NSString stringWithFormat:@"%@%@",strAddBeforeTag,@"event_pid"]];
                    }else{
                        strAddBeforeTag=[NSString stringWithFormat:@"%@_",[_eventDetailsDic valueForKey:@"event_id"]];
                        strNaveegatorStatus=@"updated";
                        [dicttemp setObject:[_eventDetailsDic valueForKey:@"event_pid"] forKey:[NSString stringWithFormat:@"%@%@",strAddBeforeTag,@"event_pid"]];
                    }
                    [dicttemp setObject:[NSString stringWithFormat:@"%d",[self CalculateTimeInterval:[_eventDetailsDic valueForKey:@"actual_start_date"] :[_eventDetailsDic valueForKey:@"start_date"] ]] forKey:[NSString stringWithFormat:@"%@%@", strAddBeforeTag,@"event_length"]];
                    
                }else{
                    // Edit simple event
                    strAddBeforeTag=[NSString stringWithFormat:@"%@_",[_eventDetailsDic valueForKey:@"event_id"]];
                    strNaveegatorStatus=@"updated";
                    [dicttemp setObject:[NSString stringWithFormat:@"%f",(endTime-startTime)] forKey:[NSString stringWithFormat:@"%@%@", strAddBeforeTag,@"event_length"]];
                }
                
            }else{
                
                // Add Simple or repeat event
                strAddBeforeTag=@"1416899535876_";
                strNaveegatorStatus=@"inserted";
                [dicttemp setObject:[NSString stringWithFormat:@"%f",(endTime-startTime)] forKey:[NSString stringWithFormat:@"%@%@", strAddBeforeTag,@"event_length"]];
                [dicttemp setObject:EMPTYSTRING forKey:[NSString stringWithFormat:@"%@%@", strAddBeforeTag,@"id"]];
            }
            //  Comman code
            
            [dicttemp setObject:[NSString stringWithFormat:@"%d",userInfo.userType] forKey:@"type"];
            [dicttemp setObject:[NSString stringWithFormat:@"%d",userInfo.userId] forKey:KEY_USER_ID];
            [dicttemp setObject:[NSString stringWithFormat:@"%d",userInfo.userSelectedTeamid] forKey:KEY_TEAM_ID];
            [dicttemp setObject:strNaveegatorStatus forKey:[NSString stringWithFormat:@"%@%@", strAddBeforeTag,@"!nativeeditor_status"]];
            [dicttemp setObject:@"mobile" forKey:@"interface"];
            [dicttemp setObject:[NSString stringWithFormat:@"%@",_tfLocation.text] forKey:[NSString stringWithFormat:@"%@%@", strAddBeforeTag,@"location"]];
            strLat.length > 0 ? [dicttemp setObject:strLat forKey:[NSString stringWithFormat:@"%@%@", strAddBeforeTag,@"lat"]] : [dicttemp setObject:EMPTYSTRING forKey:[NSString stringWithFormat:@"%@%@", strAddBeforeTag,@"lat"]] ;
            strLong.length > 0 ? [dicttemp setObject:strLong forKey:[NSString stringWithFormat:@"%@%@", strAddBeforeTag,@"lng"]] :[dicttemp setObject:EMPTYSTRING forKey:[NSString stringWithFormat:@"%@%@", strAddBeforeTag,@"lng"]] ;
            [dicttemp setObject:[NSString stringWithFormat:@"%@",_tfTitle.text] forKey:[NSString stringWithFormat:@"%@%@", strAddBeforeTag,@"text"]];
            [dicttemp setObject:[NSString stringWithFormat:@"%@",_texviewDescription.text] forKey:[NSString stringWithFormat:@"%@%@", strAddBeforeTag,Key_name]];
            [dicttemp setObject:[self CalculateStartdate] forKey:[NSString stringWithFormat:@"%@%@", strAddBeforeTag,@"start_date"]];
            [dicttemp setObject:[strAddBeforeTag stringByReplacingOccurrencesOfString:@"_" withString:EMPTYSTRING] forKey:[NSString stringWithFormat:@"%@",@"ids"]];
            
            if ([CalendarEvent ShareInstance].CalendarRepeatStatus==TRUE)
            {
                // Event Add or edit repeat case
                
                [dicttemp setObject:[self CalculateEventEndDate] forKey:[NSString stringWithFormat:@"%@%@", strAddBeforeTag,@"end_date"]];
                // In case Occurrence Add or edit rec_pattern and rec_type set black
                
                if (![[CalendarEvent ShareInstance].strEventEditBy isEqualToString:@"Edit Occurrence"]){
                    
                    NSArray *arrComponents=[[CalendarEvent ShareInstance].strRepeatSting componentsSeparatedByString:@"#"];
                    // if user not change reccurrence then [CalendarEvent ShareInstance].strRepeatSting is nil then get value from _eventDetailDic
                    if (!arrComponents) {
                        arrComponents=[[_eventDetailsDic valueForKey:@"rec_type"] componentsSeparatedByString:@"#"];
                        [CalendarEvent ShareInstance].strRepeatSting=[_eventDetailsDic valueForKey:@"rec_type"];
                    }
                    if (arrComponents.count > 0) {
                        [dicttemp setObject:[arrComponents objectAtIndex:0] forKey:[NSString stringWithFormat:@"%@%@", strAddBeforeTag,@"rec_pattern"]];
                    }else{
                        [dicttemp setObject:EMPTYSTRING forKey:[NSString stringWithFormat:@"%@%@", strAddBeforeTag,@"rec_pattern"]];
                    }
                    [dicttemp setObject:[NSString stringWithFormat:@"%@",[CalendarEvent ShareInstance].strRepeatSting] forKey:[NSString stringWithFormat:@"%@%@", strAddBeforeTag,@"rec_type"]];
                }else{
                    
                    [dicttemp setObject:EMPTYSTRING forKey:[NSString stringWithFormat:@"%@%@", strAddBeforeTag,@"rec_pattern"]];
                    [dicttemp setObject:EMPTYSTRING forKey:[NSString stringWithFormat:@"%@%@", strAddBeforeTag,@"rec_type"]];
                }
                
            }else{
                // Event Add or edit non repeat case
                [dicttemp setObject:[self DateINY_M_D_H_M_S:_tfEndTime.text] forKey:[NSString stringWithFormat:@"%@%@", strAddBeforeTag,@"end_date"]];
                [dicttemp setObject:EMPTYSTRING forKey:[NSString stringWithFormat:@"%@%@", strAddBeforeTag,@"rec_pattern"]];
                [dicttemp setObject:EMPTYSTRING forKey:[NSString stringWithFormat:@"%@%@", strAddBeforeTag,@"rec_type"]];
                [dicttemp setObject:[NSString stringWithFormat:@"%@",EMPTYSTRING] forKey:[NSString stringWithFormat:@"%@%@", strAddBeforeTag,@"event_length"]];
            }
            isDate=FALSE;
            [SingletonClass addActivityIndicator:self.view];
            [webservice WebserviceCallwithDic:dicttemp :webServiceAddEvents :AddEventTag];
        }else{
            self.navigationItem.rightBarButtonItem.enabled=YES;
            [SingletonClass initWithTitle:EMPTYSTRING message:INTERNET_NOT_AVAILABLE delegate:nil btn1:@"Ok"];
        }
    }
}
-(NSString *)CalculateStartdate
{
    NSString *strDate;
    if ([[CalendarEvent ShareInstance].strEventType isEqualToString:EVENTTYPE_WEEKLY]) {
        // when weekly event then pass start om monday date of the week
        [self CalculateStartDate_of_Monday_of_Given_Month];
        strDate=[[[CalendarEvent ShareInstance].strStartDate componentsSeparatedByString:STR_SPACE] objectAtIndex:0];
        NSString *strTime=[[[self DateINY_M_D_H_M_S: _tfStartTime.text ] componentsSeparatedByString:STR_SPACE] objectAtIndex:1];
        strDate=[strDate stringByAppendingFormat:@" %@",strTime];
        [CalendarEvent ShareInstance].strStartDate=strDate;
        
    }else{
        
        strDate=[[[CalendarEvent ShareInstance].strStartDate componentsSeparatedByString:STR_SPACE] objectAtIndex:0];
        NSString *strTime=[[[self DateINY_M_D_H_M_S: _tfStartTime.text ] componentsSeparatedByString:STR_SPACE] objectAtIndex:1];
        strDate=[strDate stringByAppendingFormat:@" %@",strTime];
        [CalendarEvent ShareInstance].strStartDate=strDate;
    }
    return strDate;
}
-(void)CalculateStartDate_of_Monday_of_Given_Month{
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:DATE_FORMAT_Y_M_D_H_M_S];
    NSDate *date=[formatter dateFromString:[CalendarEvent ShareInstance].strStartDate];
    NSCalendar *gregorianCalendar = [[NSCalendar alloc]  initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorianCalendar setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    NSDateComponents *components = [gregorianCalendar components:(NSYearCalendarUnit| NSMonthCalendarUnit
                                                                  | NSDayCalendarUnit| NSWeekdayCalendarUnit|NSWeekCalendarUnit)  fromDate:date];
    NSDateComponents *dt=[[NSDateComponents alloc]init];
    [dt setWeek:[components week]];
    [dt setWeekday:2];
    [dt setMonth:[components month]];
    [dt setYear:[components year]];
    NSDate *monday=[gregorianCalendar dateFromComponents:dt];
    [CalendarEvent ShareInstance].strStartDate = [formatter stringFromDate:monday];
}
-(NSString *)CalculateEventEndDate
{
    if (SaveWithoutChange==TRUE) {
        if (([[CalendarEvent ShareInstance].strEventEditBy isEqualToString:@"Edit Series"]))
        {
            return [_eventDetailsDic valueForKey:@"actual_end_date"];
        }else  if (([[CalendarEvent ShareInstance].strEventEditBy isEqualToString:@"Edit Occurrence"])){
            return [_eventDetailsDic valueForKey:@"actual_end_date"];
        }
        else{
            return [_eventDetailsDic valueForKey:@"end_date"];
        }
    }
    else
    {
        NSString *enddate=EMPTYSTRING;
        NSDateFormatter *locFormater=[[NSDateFormatter alloc] init];
        locFormater.dateFormat =DATE_FORMAT_Y_M_D_H_M_S;
        NSString *strStartdate=[CalendarEvent ShareInstance].strStartDate;
        
        NSDate *dateStartDateDay = [locFormater dateFromString:strStartdate];
        locFormater.dateFormat =DATE_FORMAT_D;
        NSString *strday=[locFormater stringFromDate:dateStartDateDay];
        
        if ([[CalendarEvent ShareInstance].strEventType isEqualToString:EVENTTYPE_DAILY] || [[CalendarEvent ShareInstance].strEventType isEqualToString:EVENTTYPE_WEEKLY]) {
            
            if ([[CalendarEvent ShareInstance].strEndDate isEqualToString:INFINITE_DATE])
            {
                // End date in case of infinite date
                
                [CalendarEvent ShareInstance].strEndDate=INFINITE_DATE;
                enddate=INFINITE_DATE;
                
            }else if ([CalendarEvent ShareInstance].NoOfDay != 0 && [CalendarEvent ShareInstance].NoOfOccurrence != 0)
            {
                if ([[CalendarEvent ShareInstance].strEventType isEqualToString:EVENTTYPE_DAILY]) {
                    // Daily event Calculate end date , End date after startdate of (Occurrance multiply by no of days)
                    
                    enddate=[self CalculateEndDateIn_Daily_WorkingDay_Case];
                    //locFormater=nil;
                    
                }else
                {
                    // Weekly event Calculate end date
                    
                    int endDateAfter;
                    locFormater.dateFormat =DATE_FORMAT_Y_M_D_H_M_S;
                    NSArray *arrSelectedDays=[[CalendarEvent ShareInstance].strNoOfDaysWeekCase componentsSeparatedByString:@","];
                    if((arrSelectedDays.count) < ([CalendarEvent ShareInstance].NoOfOccurrence))
                    {
                        endDateAfter= [strday intValue]+[CalendarEvent ShareInstance].NoOfOccurrence*7;
                        
                    }else if((arrSelectedDays.count) > ([CalendarEvent ShareInstance].NoOfOccurrence)){
                        
                        endDateAfter=[[arrSelectedDays objectAtIndex:arrSelectedDays.count-1] intValue];
                        
                    }else{
                        endDateAfter=[strday intValue]+(([CalendarEvent ShareInstance].NoOfDay) * (7));
                    }
                    
                    NSDate *date=[locFormater dateFromString:strStartdate];
                    NSDate *newDate1 = [date dateByAddingTimeInterval:60*60*24*endDateAfter];
                    [CalendarEvent ShareInstance].strEndDate =[locFormater stringFromDate:newDate1];
                    enddate=[CalendarEvent ShareInstance].strEndDate;
                    locFormater=nil;
                }
                
            }
            else
            {
                // End date selected by user from repeate screen
                enddate=[[[[CalendarEvent ShareInstance].strEndDate componentsSeparatedByString:STR_SPACE] objectAtIndex:0] stringByAppendingFormat:STR_00_00_00];
            }
            
        }else if ([[CalendarEvent ShareInstance].strEventType isEqualToString:EVENTTYPE_MONTHLY])
        {
            if ([[CalendarEvent ShareInstance].strEndDate isEqualToString:INFINITE_DATE]) {
                
                [CalendarEvent ShareInstance].strEndDate=INFINITE_DATE;
                enddate=INFINITE_DATE;
                
            }else if ([CalendarEvent ShareInstance].NoOfDay != 0 && [CalendarEvent ShareInstance].NoOfOccurrence != 0)
            {
                NSString *strDate=[[[CalendarEvent ShareInstance].strEndDate componentsSeparatedByString:STR_SPACE] objectAtIndex:0];
                NSString *strTime=[[[CalendarEvent ShareInstance].strStartDate componentsSeparatedByString:STR_SPACE] objectAtIndex:1];
                enddate=[strDate stringByAppendingFormat:@" %@",strTime];
                
            }else{
                
                // enddate=[CalendarEvent ShareInstance].strEndDate;
                enddate=[[[[CalendarEvent ShareInstance].strEndDate componentsSeparatedByString:STR_SPACE] objectAtIndex:0] stringByAppendingFormat:STR_00_00_00];
            }
        }
        else if ([[CalendarEvent ShareInstance].strEventType isEqualToString:EVENTTYPE_YEARLY])
        {
            // End date in yearly Case
            
            if ([[CalendarEvent ShareInstance].strEndDate isEqualToString:INFINITE_DATE]) {
                
                // Infinite case
                [CalendarEvent ShareInstance].strEndDate=INFINITE_DATE;
                enddate=INFINITE_DATE;
                
            }else if ([CalendarEvent ShareInstance].NoOfDay != 0 && [CalendarEvent ShareInstance].NoOfOccurrence != 0)
            {
                // No of occurrance- > end date will be startdate
                
                NSString *strDate=[[[CalendarEvent ShareInstance].strEndDate componentsSeparatedByString:STR_SPACE] objectAtIndex:0];
                NSString *strTime=[[[CalendarEvent ShareInstance].strStartDate componentsSeparatedByString:STR_SPACE] objectAtIndex:1];
                
                enddate=[strDate stringByAppendingFormat:@" %@",strTime];
                
            }else{
                // End by perticular date
                
                // enddate=[CalendarEvent ShareInstance].strEndDate;
                enddate=[[[[CalendarEvent ShareInstance].strEndDate componentsSeparatedByString:STR_SPACE] objectAtIndex:0] stringByAppendingFormat:STR_00_00_00];
            }
        }
        return enddate;
    }
}

-(NSString *)CalculateEndDateIn_Daily_WorkingDay_Case
{
    //IN case end date will be after working NoOfOccurrence days (Mon, Tue , Wed , Thu , Fri , ) from startdate
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:DATE_FORMAT_Y_M_D_H_M_S];
    NSDate *date=[formatter dateFromString:[CalendarEvent ShareInstance].strStartDate];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekdayOrdinalCalendarUnit | NSDayCalendarUnit) fromDate:date];
    
    if ([[CalendarEvent ShareInstance].strDailyEventSubType isEqualToString:DAILY_TYPE_NONWORKINGDAY ]) {
        components.day=components.day+([CalendarEvent ShareInstance].NoOfOccurrence * [CalendarEvent ShareInstance].NoOfDay);
        NSDate *dayOneInCurrentMonth = [gregorian dateFromComponents:components];
        NSString *enddate=[formatter stringFromDate:dayOneInCurrentMonth];
        return enddate;
    }else{
        int loopEnd=[CalendarEvent ShareInstance].NoOfOccurrence ;
        for (int i=1; i <= loopEnd; i++) {
            if (((components.day%7) == 6) || ((components.day%7) == 0) ) {
                loopEnd=loopEnd+1;
                components.day=components.day+1;
            }else{
                components.day=components.day+1;
            }
        }
        NSDate *dayOneInCurrentMonth = [gregorian dateFromComponents:components];
        NSString *enddate=[formatter stringFromDate:dayOneInCurrentMonth];
        return enddate;
    }
}

// append time of startdate in end date time in only repeat occurrence case
-(NSString *)endDateWithStartTime :(NSString *)strTime
{
    NSString *strStartdate=[self DateINY_M_D_H_M_S:[CalendarEvent ShareInstance].strStartDate];
    NSString *strEnddate=[self DateINY_M_D_H_M_S:strTime];
    
    NSArray *arrStartComponents=[strStartdate componentsSeparatedByString:STR_SPACE];
    NSArray *arrEndComponents=[strEnddate componentsSeparatedByString:STR_SPACE];
    
    NSString *finalDate=[[arrStartComponents objectAtIndex:1] stringByAppendingString:[NSString stringWithFormat:@" %@", [arrEndComponents objectAtIndex:0] ]];
    
    
    return finalDate;
}
-(NSString *)DateIND_M_Y_H_M_S :(NSString *)strdate
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat =DATE_FORMAT_Y_M_D_H_M_S;
    NSDate *date=[df dateFromString:strdate];
    df.dateFormat = DATE_FORMAT_AddEvent;
    NSString *strTempDate=[df stringFromDate:date];
    df=nil;
    
    return strTempDate;
}

-(NSString *)DateINY_M_D_H_M_S :(NSString *)strdate
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat =DATE_FORMAT_AddEvent;
    NSDate *date=[df dateFromString:strdate];
    df.dateFormat = DATE_FORMAT_Y_M_D_H_M_S;
    NSString *strTempDate=[df stringFromDate:date];
    df=nil;
    
    return strTempDate;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (isIPAD)
    {
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(orientationChanged)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil];
    }
    
    if(_eventDetailsDic)
    {
        // In Case Edit, show delete and save button
        UIButton *btnDelete = [[UIButton alloc] initWithFrame:CGRectMake(110, 5, 44, 44)];
        UIImage *imageDelete=[UIImage imageNamed:@"navDeleteBtn.png"];
        [btnDelete addTarget:self action:@selector(DeleteEventAlert:) forControlEvents:UIControlEventTouchUpInside];
        [btnDelete setImage:imageDelete forState:UIControlStateNormal];
        UIBarButtonItem *ButtonItemDelete = [[UIBarButtonItem alloc] initWithCustomView:btnDelete];
        
        UIButton *btnSave = [[UIButton alloc] initWithFrame:CGRectMake(160, 0, 50, 30)];
        
        [btnSave addTarget:self action:@selector(SaveEvent) forControlEvents:UIControlEventTouchUpInside];
        // [btnSave setBackgroundImage:imageEdit forState:UIControlStateNormal];
        [btnSave setTitle:@"Save" forState:UIControlStateNormal];
        [btnSave setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        UIBarButtonItem *ButtonItemSave = [[UIBarButtonItem alloc] initWithCustomView:btnSave];
        
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:ButtonItemSave,ButtonItemDelete, nil];
    }else{
        // In Case Add, show only save button
        UIButton *btnSave = [[UIButton alloc] initWithFrame:CGRectMake(160, 0, 50, 30)];
        
        [btnSave addTarget:self action:@selector(SaveEvent) forControlEvents:UIControlEventTouchUpInside];
        // [btnSave setBackgroundImage:imageEdit forState:UIControlStateNormal];
        [btnSave setTitle:@"Save" forState:UIControlStateNormal];
        [btnSave setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        UIBarButtonItem *ButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnSave];
        self.navigationItem.rightBarButtonItem = ButtonItem;
    }
    
    isDate=FALSE;
    if ([CalendarEvent ShareInstance].strEventType.length > 0) {
        
        _tfRepeat.text=[CalendarEvent ShareInstance].strEventType;
        if (![[CalendarEvent ShareInstance].strEventEditBy isEqualToString:@"Edit Occurrence"])
        {
            [_EnableDesableBtn setImage:BTNEnableImage];
            
        }else{
            [_EnableDesableBtn setImage:BTNDisableImage];
        }
        
    }else
    {
        _tfRepeat.text=@"Never";
        [_EnableDesableBtn setImage:BTNDisableImage];
    }
    
    self.keyboardAppear = [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillShowNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        // message received
        
        NSDictionary* info = [note userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
        
        [SingletonClass setListPickerDatePickerMultipickerVisible:NO :_datePicker :toolBar];
        
        [UIView animateKeyframesWithDuration:.27f delay:0 options:UIViewKeyframeAnimationOptionBeginFromCurrentState | UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            
            if (iosVersion < 8) {
                [SingletonClass setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height-((kbSize.height > 310 ? kbSize.width : kbSize.height)+22)):toolBar];
                scrollHeight=kbSize.height > 310 ? kbSize.width : kbSize.height ;
            }else{
                
                [SingletonClass setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height-((kbSize.height > 310 ? kbSize.height : kbSize.height)+22)):toolBar];
                scrollHeight=kbSize.height > 310 ? kbSize.height : kbSize.height ;
            }
        }completion:^(BOOL finished){
            
        }];
    }];
    
    self.keyboardHide = [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        // message received
        NSDictionary* info = [note userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
        
        // [self setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height+(kbSize.height+22))];
        [UIView animateKeyframesWithDuration:.27f delay:0 options:UIViewKeyframeAnimationOptionBeginFromCurrentState | UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            [SingletonClass setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height+(kbSize.height > 310 ? kbSize.width : kbSize.height+22)) :toolBar];
            
        }completion:^(BOOL finished){
            
        }];
    }];
    
    UIImageView *imageview1=[[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-3, self.view.frame.size.width, 3)];
    
    imageview1.image=[UIImage imageNamed:@"bottomBorder.png"];
    scrollHeight=0;
    
}


-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (isIPAD)
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self.keyboardAppear];
    [[NSNotificationCenter defaultCenter] removeObserver:self.keyboardHide];
}

- (void)orientationChanged
{
    if (CurrentOrientation == [[SingletonClass ShareInstance] CurrentOrientation:self]) {
        return;
    }
    CurrentOrientation =[SingletonClass ShareInstance].GloableOreintation;
    
    if (isIPAD) {
        
        [SingletonClass setListPickerDatePickerMultipickerVisible:NO :_datePicker :toolBar];
        [SingletonClass setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height+350):toolBar];
    }
}

- (void)viewDidLoad
{
    webservice =[WebServiceClass shareInstance];
    webservice.delegate=self;
    _texviewDescription.textColor=[UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1];
    self.title=NSLocalizedString(_screentitle, EMPTYSTRING);
    [self.navigationController.navigationItem setHidesBackButton:YES];
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 22, 55)];
    _tfTitle.leftView = paddingView;
    _tfTitle.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingViewOne = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 22, 55)];
    _tfLocation.leftView = paddingViewOne;
    _tfLocation.leftViewMode = UITextFieldViewModeAlways;
    
    // To move left decrease y and move up decrease x
    _texviewDescription.textContainerInset = UIEdgeInsetsMake(15, 5, 0, 20);
    UIView *paddingViewFour = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 22, 55)];
    _tfStartTime.rightView = paddingViewFour;
    _tfStartTime.rightViewMode = UITextFieldViewModeAlways;
    UIView *paddingViewFive = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 22, 55)];
    _tfEndTime.rightView = paddingViewFive;
    _tfEndTime.rightViewMode = UITextFieldViewModeAlways;
    _tfEndTime.font=Textfont;
    _tfLocation.font=Textfont;
    _tfRepeat.font=Textfont;
    _tfTitle.font=Textfont;
    _tfStartTime.font=Textfont;
    tempView.layer.borderWidth=1.0;
    tempView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _tfTitle.layer.borderWidth=1.0;
    _tfTitle.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _tfLocation.layer.borderWidth=1.0;
    _tfLocation.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _tfRepeat.text=@"Never";
    // In Edit mode
    if (_eventDetailsDic) {
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        df.dateFormat =DATE_FORMAT_Y_M_D_H_M_S;
        _tfTitle.text=[_eventDetailsDic valueForKey:@"text"];
        _tfLocation.text=[_eventDetailsDic valueForKey:@"location"];
        _texviewDescription.text=[_eventDetailsDic valueForKey:Key_name];
        _texviewDescription.textColor=[UIColor grayColor];
        
        NSString *str=[_eventDetailsDic valueForKey:@"rec_type"] ?[_eventDetailsDic valueForKey:@"rec_type"] : EMPTYSTRING;
        int RepeatIndex=0;
        if (str.length > 0) {
            // If event repeat type
            const char *c = str.length > 0 ? [str UTF8String] : [EMPTYSTRING  UTF8String];
            if (c[0]=='d') {
                _tfRepeat.text=EVENTTYPE_DAILY;
                RepeatIndex=1;
            }else  if (c[0]=='w') {
                _tfRepeat.text=EVENTTYPE_WEEKLY;
                RepeatIndex=2;
            }else  if (c[0]=='m') {
                _tfRepeat.text=EVENTTYPE_MONTHLY;
                RepeatIndex=3;
            }else  if (c[0]=='y') {
                RepeatIndex=4;
                _tfRepeat.text=EVENTTYPE_YEARLY;
            }
            
            [CalendarEvent ShareInstance].strEventType=_tfRepeat.text;
            
            switch (RepeatIndex)
            {
                case 1:
                {         //Daily  event
                    if ([[CalendarEvent ShareInstance].strEventEditBy isEqualToString:@"Edit Series"])
                    {
                        NSDate *startdate=[df dateFromString:[_eventDetailsDic valueForKey:@"actual_start_date"]];
                        // NSDate *enddate=[df dateFromString:[_eventDetailsDic valueForKey:@"actual_end_date"]];
                        [df setDateFormat:DATE_FORMAT_AddEvent];
                        _tfStartTime.text=[df stringFromDate:startdate ];
                        int event_length=[[_eventDetailsDic valueForKey:@"event_length"] intValue];
                        NSDate *enddate=[startdate dateByAddingTimeInterval:event_length];
                        _tfEndTime.text=[df stringFromDate:enddate];
                        [CalendarEvent ShareInstance].strEndDate=_tfEndTime.text;
                        [CalendarEvent ShareInstance].strEndDate=_tfEndTime.text;
                        NSString *timestampOne = [NSString stringWithFormat:@"%f", [startdate timeIntervalSince1970]];
                        startTime = [timestampOne doubleValue];
                        NSString *timestampTwo = [NSString stringWithFormat:@"%f", [enddate timeIntervalSince1970]];
                        endTime = [timestampTwo doubleValue];
                        
                        [df setDateFormat:DATE_FORMAT_Y_M_D_H_M_S];
                        if ([df stringFromDate:startdate] !=nil && [df stringFromDate:enddate] != nil)
                        {
                            [CalendarEvent ShareInstance].strActualStartDate=EMPTYSTRING;
                            [CalendarEvent ShareInstance].strStartDate=[df stringFromDate:startdate];
                            [CalendarEvent ShareInstance].strActualStartDate=[_eventDetailsDic valueForKey:@"actual_start_date"];
                            [CalendarEvent ShareInstance].strEndDate=[df stringFromDate:enddate];
                        }
                        
                    }else
                    {
                        NSDate *startdate=[df dateFromString:[_eventDetailsDic valueForKey:@"start_date"]];
                        NSDate *enddate=[df dateFromString:[_eventDetailsDic valueForKey:@"end_date"]];
                        [df setDateFormat:DATE_FORMAT_AddEvent];
                        _tfStartTime.text=[df stringFromDate:startdate ];
                        _tfEndTime.text=[df stringFromDate:enddate];
                        
                        NSString *timestampOne = [NSString stringWithFormat:@"%f", [startdate timeIntervalSince1970]];
                        startTime = [timestampOne doubleValue];
                        NSString *timestampTwo = [NSString stringWithFormat:@"%f", [enddate timeIntervalSince1970]];
                        endTime = [timestampTwo doubleValue];
                        
                        [df setDateFormat:DATE_FORMAT_Y_M_D_H_M_S];
                        if ([df stringFromDate:startdate] !=nil && [df stringFromDate:enddate] != nil)
                        {
                            [CalendarEvent ShareInstance].strActualStartDate=EMPTYSTRING;
                            [CalendarEvent ShareInstance].strStartDate=[df stringFromDate:startdate];
                            [CalendarEvent ShareInstance].strActualStartDate=[_eventDetailsDic valueForKey:@"actual_start_date"];
                            [CalendarEvent ShareInstance].strEndDate=[df stringFromDate:enddate];
                        }
                    }
                    
                    break;
                }
                case 2:
                {
                    //weekly  event
                    if ([[CalendarEvent ShareInstance].strEventEditBy isEqualToString:@"Edit Series"])
                    {
                        NSDate *startdate=[df dateFromString:[_eventDetailsDic valueForKey:@"actual_start_date"]];
                        
                        [df setDateFormat:DATE_FORMAT_AddEvent];
                        _tfStartTime.text=[df stringFromDate:startdate ];
                        int event_length=[[_eventDetailsDic valueForKey:@"event_length"] intValue];
                        NSDate *enddate=[startdate dateByAddingTimeInterval:event_length];
                        _tfEndTime.text=[df stringFromDate:enddate];
                        [CalendarEvent ShareInstance].strEndDate=_tfEndTime.text;
                        NSString *timestampOne = [NSString stringWithFormat:@"%f", [startdate timeIntervalSince1970]];
                        startTime = [timestampOne doubleValue];
                        NSString *timestampTwo = [NSString stringWithFormat:@"%f", [enddate timeIntervalSince1970]];
                        endTime = [timestampTwo doubleValue];
                        
                        [df setDateFormat:DATE_FORMAT_Y_M_D_H_M_S];
                        if ([df stringFromDate:startdate] !=nil && [df stringFromDate:enddate] != nil) {
                            [CalendarEvent ShareInstance].strActualStartDate=EMPTYSTRING;
                            [CalendarEvent ShareInstance].strStartDate=[df stringFromDate:startdate];
                            [CalendarEvent ShareInstance].strActualStartDate=[_eventDetailsDic valueForKey:@"actual_start_date"];
                            [CalendarEvent ShareInstance].strEndDate=[df stringFromDate:enddate];
                        }
                        
                    }else
                    {
                        NSDate *startdate=[df dateFromString:[_eventDetailsDic valueForKey:@"start_date"]];
                        NSDate *enddate=[df dateFromString:[_eventDetailsDic valueForKey:@"end_date"]];
                        [df setDateFormat:DATE_FORMAT_AddEvent];
                        _tfStartTime.text=[df stringFromDate:startdate ];
                        _tfEndTime.text=[df stringFromDate:enddate];
                        // [CalendarEvent ShareInstance].strEndDate=_tfEndTime.text;
                        
                        NSString *timestampOne = [NSString stringWithFormat:@"%f", [startdate timeIntervalSince1970]];
                        startTime = [timestampOne doubleValue];
                        NSString *timestampTwo = [NSString stringWithFormat:@"%f", [enddate timeIntervalSince1970]];
                        endTime = [timestampTwo doubleValue];
                        
                        [df setDateFormat:DATE_FORMAT_Y_M_D_H_M_S];
                        if ([df stringFromDate:startdate] !=nil && [df stringFromDate:enddate] != nil) {
                            [CalendarEvent ShareInstance].strActualStartDate=EMPTYSTRING;
                            [CalendarEvent ShareInstance].strStartDate=[df stringFromDate:startdate];
                            [CalendarEvent ShareInstance].strActualStartDate=[_eventDetailsDic valueForKey:@"actual_start_date"];
                            [CalendarEvent ShareInstance].strEndDate=[df stringFromDate:enddate];
                        }
                        
                    }
                    
                    break;
                }
                case 3:
                {
                    //Monthly  event
                    if ([[CalendarEvent ShareInstance].strEventEditBy isEqualToString:@"Edit Series"])
                    {
                        NSDate *startdate=[df dateFromString:[_eventDetailsDic valueForKey:@"actual_start_date"]];
                        [df setDateFormat:DATE_FORMAT_AddEvent];
                        _tfStartTime.text=[df stringFromDate:startdate ];
                        int event_length=[[_eventDetailsDic valueForKey:@"event_length"] intValue];
                        NSDate *enddate=[startdate dateByAddingTimeInterval:event_length];
                        _tfEndTime.text=[df stringFromDate:enddate];
                        [CalendarEvent ShareInstance].strEndDate=_tfEndTime.text;
                        [CalendarEvent ShareInstance].strEndDate=_tfEndTime.text;
                        NSString *timestampOne = [NSString stringWithFormat:@"%f", [startdate timeIntervalSince1970]];
                        startTime = [timestampOne doubleValue];
                        NSString *timestampTwo = [NSString stringWithFormat:@"%f", [enddate timeIntervalSince1970]];
                        endTime = [timestampTwo doubleValue];
                        
                        [df setDateFormat:DATE_FORMAT_Y_M_D_H_M_S];
                        if ([df stringFromDate:startdate] !=nil && [df stringFromDate:enddate] != nil) {
                            [CalendarEvent ShareInstance].strActualStartDate=EMPTYSTRING;
                            [CalendarEvent ShareInstance].strStartDate=[df stringFromDate:startdate];
                            [CalendarEvent ShareInstance].strActualStartDate=[_eventDetailsDic valueForKey:@"actual_start_date"];
                            [CalendarEvent ShareInstance].strEndDate=[df stringFromDate:enddate];
                        }
                        
                    }else
                    {
                        NSDate *startdate=[df dateFromString:[_eventDetailsDic valueForKey:@"start_date"]];
                        NSDate *enddate=[df dateFromString:[_eventDetailsDic valueForKey:@"end_date"]];
                        [df setDateFormat:DATE_FORMAT_AddEvent];
                        _tfStartTime.text=[df stringFromDate:startdate ];
                        _tfEndTime.text=[df stringFromDate:enddate];
                        // [CalendarEvent ShareInstance].strEndDate=_tfEndTime.text;
                        
                        NSString *timestampOne = [NSString stringWithFormat:@"%f", [startdate timeIntervalSince1970]];
                        startTime = [timestampOne doubleValue];
                        NSString *timestampTwo = [NSString stringWithFormat:@"%f", [enddate timeIntervalSince1970]];
                        endTime = [timestampTwo doubleValue];
                        
                        [df setDateFormat:DATE_FORMAT_Y_M_D_H_M_S];
                        if ([df stringFromDate:startdate] !=nil && [df stringFromDate:enddate] != nil) {
                            [CalendarEvent ShareInstance].strActualStartDate=EMPTYSTRING;
                            [CalendarEvent ShareInstance].strStartDate=[df stringFromDate:startdate];
                            [CalendarEvent ShareInstance].strActualStartDate=[_eventDetailsDic valueForKey:@"actual_start_date"];
                            [CalendarEvent ShareInstance].strEndDate=[df stringFromDate:enddate];
                        }
                    }
                    break;
                }
                    
                case 4:
                {
                    //Monthly  event
                    if ([[CalendarEvent ShareInstance].strEventEditBy isEqualToString:@"Edit Series"])
                    {
                        NSDate *startdate=[df dateFromString:[_eventDetailsDic valueForKey:@"actual_start_date"]];
                        [df setDateFormat:DATE_FORMAT_AddEvent];
                        _tfStartTime.text=[df stringFromDate:startdate ];
                        
                        int event_length=[[_eventDetailsDic valueForKey:@"event_length"] intValue];
                        
                        NSDate *enddate=[startdate dateByAddingTimeInterval:event_length];
                        
                        _tfEndTime.text=[df stringFromDate:enddate];
                        [CalendarEvent ShareInstance].strEndDate=_tfEndTime.text;
                        
                        [CalendarEvent ShareInstance].strEndDate=_tfEndTime.text;
                        
                        NSString *timestampOne = [NSString stringWithFormat:@"%f", [startdate timeIntervalSince1970]];
                        startTime = [timestampOne doubleValue];
                        NSString *timestampTwo = [NSString stringWithFormat:@"%f", [enddate timeIntervalSince1970]];
                        endTime = [timestampTwo doubleValue];
                        
                        [df setDateFormat:DATE_FORMAT_Y_M_D_H_M_S];
                        
                        if ([df stringFromDate:startdate] !=nil && [df stringFromDate:enddate] != nil) {
                            [CalendarEvent ShareInstance].strActualStartDate=EMPTYSTRING;
                            [CalendarEvent ShareInstance].strStartDate=[df stringFromDate:startdate];
                            [CalendarEvent ShareInstance].strActualStartDate=[_eventDetailsDic valueForKey:@"actual_start_date"];
                            [CalendarEvent ShareInstance].strEndDate=[df stringFromDate:enddate];
                        }
                        
                    }else
                    {
                        NSDate *startdate=[df dateFromString:[_eventDetailsDic valueForKey:@"start_date"]];
                        NSDate *enddate=[df dateFromString:[_eventDetailsDic valueForKey:@"end_date"]];
                        [df setDateFormat:DATE_FORMAT_AddEvent];
                        _tfStartTime.text=[df stringFromDate:startdate ];
                        _tfEndTime.text=[df stringFromDate:enddate];
                        // [CalendarEvent ShareInstance].strEndDate=_tfEndTime.text;
                        
                        NSString *timestampOne = [NSString stringWithFormat:@"%f", [startdate timeIntervalSince1970]];
                        startTime = [timestampOne doubleValue];
                        NSString *timestampTwo = [NSString stringWithFormat:@"%f", [enddate timeIntervalSince1970]];
                        endTime = [timestampTwo doubleValue];
                        
                        [df setDateFormat:DATE_FORMAT_Y_M_D_H_M_S];
                        if ([df stringFromDate:startdate] !=nil && [df stringFromDate:enddate] != nil) {
                            [CalendarEvent ShareInstance].strActualStartDate=EMPTYSTRING;
                            [CalendarEvent ShareInstance].strStartDate=[df stringFromDate:startdate];
                            [CalendarEvent ShareInstance].strActualStartDate=[_eventDetailsDic valueForKey:@"actual_start_date"];
                            [CalendarEvent ShareInstance].strEndDate=[df stringFromDate:enddate];
                        }
                    }
                    break;
                    
                    break;
                }
                    
                default:
                    break;
            }
        }else{
            ////Simple event
            NSDate *startdate=[df dateFromString:[_eventDetailsDic valueForKey:@"actual_start_date"]];
            NSDate *enddate=[df dateFromString:[_eventDetailsDic valueForKey:@"actual_end_date"]];
            df.dateFormat =DATE_FORMAT_AddEvent;
            _tfStartTime.text=[df stringFromDate:startdate ];
            _tfEndTime.text=[df stringFromDate:enddate];
            NSString *timestampOne = [NSString stringWithFormat:@"%f", [startdate timeIntervalSince1970]];
            startTime = [timestampOne doubleValue];
            
            NSString *timestampTwo = [NSString stringWithFormat:@"%f", [enddate timeIntervalSince1970]];
            endTime = [timestampTwo doubleValue];
            df.dateFormat=DATE_FORMAT_Y_M_D_H_M_S;
            [CalendarEvent ShareInstance].strActualStartDate=EMPTYSTRING;
            [CalendarEvent ShareInstance].strStartDate=[df stringFromDate:startdate];
            [CalendarEvent ShareInstance].strActualStartDate=[_eventDetailsDic valueForKey:@"actual_start_date"];
            [CalendarEvent ShareInstance].strEndDate=[df stringFromDate:enddate];
        }
        
        strLat=[_eventDetailsDic valueForKey:@"lat"];
        strLong=[_eventDetailsDic valueForKey:@"lng"];
        
        df=nil;
    }else
    {
        [CalendarEvent ShareInstance].strEventType=EMPTYSTRING;
        [CalendarEvent ShareInstance].strEndDate=EMPTYSTRING;
        [CalendarEvent ShareInstance].strRepeatSting=EMPTYSTRING;
    }
    self.navigationController.navigationBar.titleTextAttributes= [NSDictionary dictionaryWithObjectsAndKeys:
                                                                  NAVIGATION_COMPONENT_COLOR,NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:NavFontSize],NSFontAttributeName,nil];
    self.navigationController.navigationBar.tintColor=NAVIGATION_COMPONENT_COLOR;
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneClicked)];
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height+50, self.view.frame.size.width, 44)];
    toolBar.tag = 40;
    toolBar.items = [NSArray arrayWithObjects:flex,flex,btnDone,nil];
    [self.view addSubview:toolBar];
    
    //Set the Date picker view
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height+350, self.view.frame.size.width, 216)];
    _datePicker.date = [NSDate date];
    _datePicker.tag=70;
    //[datePicker setHidden:YES];
    _datePicker.backgroundColor=[UIColor whiteColor];
    [_datePicker addTarget:self action:@selector(dateChange) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_datePicker];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(RepeatClick:)];
    tapGesture.numberOfTouchesRequired = 1;
    tapGesture.numberOfTouchesRequired=1;
    [_EnableDesableBtn addGestureRecognizer:tapGesture];
    _EnableDesableBtn.userInteractionEnabled=YES;
    _EnableDesableBtn.multipleTouchEnabled=YES;
    
    [tempView bringSubviewToFront:_EnableDesableBtn];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidLayoutSubviews {
    
    if ( isDate==TRUE) {
        //[self.view viewWithTag:70].center = CGPointMake(160, visiblePicker);
    }
}

-(void)dateChange
{
    //isDate=TRUE;
    dformate = [[NSDateFormatter alloc] init];
    dformate.dateFormat =DATE_FORMAT_AddEvent;
    
    dateIs = [NSString stringWithFormat:@"%@", [dformate stringFromDate:_datePicker.date]];
    currentText.text = dateIs;
    
    if (currentText.tag==1003) {
        NSString *timestamp = [NSString stringWithFormat:@"%f", [[_datePicker date] timeIntervalSince1970]];
        startTime = [timestamp doubleValue];
        dformate.dateFormat =DATE_FORMAT_Y_M_D_H_M_S;
        [CalendarEvent ShareInstance].strStartDate= [dformate stringFromDate:_datePicker.date];
        [CalendarEvent ShareInstance].strActualStartDate=[dformate stringFromDate:_datePicker.date];
        
    }else  if (currentText.tag==1004) {
        NSString *timestamp = [NSString stringWithFormat:@"%f", [[_datePicker date] timeIntervalSince1970]];
        endTime = [timestamp doubleValue];
        dformate.dateFormat =DATE_FORMAT_Y_M_D_H_M_S;
        
        [CalendarEvent ShareInstance].strEndDate= [dformate stringFromDate:_datePicker.date];
    }
    [self CalculateStartDate_of_Monday_of_Given_Month];
}

-(void)setDatePickerVisibleAt :(BOOL)ShowHide
{
    [UIView beginAnimations:@"tblViewMove" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.27f];
    CGPoint Point;
    Point.x=self.view.frame.size.width/2;
    
    if (ShowHide) {
        
        Point.y=self.view.frame.size.height-(_datePicker.frame.size.height/2);
        [self setToolbarVisibleAt:CGPointMake(Point.x,Point.y-(_datePicker.frame.size.height/2)-22)];
        
    }else{
        // [self setToolbarVisibleAt:CGPointMake(point.x,self.view.frame.size.height+50)];
        Point.y=self.view.frame.size.height+(_datePicker.frame.size.height/2);
    }
    [self.view viewWithTag:70].center = Point;
    [UIView commitAnimations];
}

-(void)setToolbarVisibleAt:(CGPoint)point
{
    [UIView animateWithDuration:0.27f
                     animations:^{
                         [self.view viewWithTag:40].center = point;
                     }
                     completion:^(BOOL finished){
                     }];
    
}
-(void)doneClicked
{
    [_scrollview setContentOffset:CGPointMake(0,0) animated: NO];
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    [SingletonClass setListPickerDatePickerMultipickerVisible:NO :_datePicker :toolBar];
    [SingletonClass setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height+350) :toolBar];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark setcontent offset
-(void)setContentOffset:(id)textField table:(UIScrollView*)m_ScrollView {
    UIView* txt = textField;
    // Scroll to cell
    // int position=self.view.frame.size.height-(txt.frame.origin.y+txt.frame.size.height);
    
    scrollHeight= scrollHeight ==0 ? [@"216" intValue]:scrollHeight;
    [_scrollview setContentOffset:CGPointMake(0,2*(txt.frame.size.height+30)) animated: YES];
}
#pragma mark- UITextfield Delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    if ([textField isEqual:_tfRepeat]) {
        
        return NO;
    }
    
    isDate=FALSE;
    currentText=textField;
    if (textField.tag > 1001) {
        [self setContentOffset:textField table:_scrollview];
    }
    
    if (textField.tag==1003 || textField.tag==1004) {
        
        isDate=TRUE;
        
        [[[UIApplication sharedApplication]keyWindow] endEditing:YES];
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        df.dateFormat =DATE_FORMAT_AddEvent;
        
        
        if (currentText.text.length > 0) {
            
            NSDate *date=[df dateFromString:currentText.text];
            
            date !=nil ? [_datePicker setDate:date] : @"";
            
        }else{
            
            // Default case when no date is selected
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            df.dateFormat =DATE_FORMAT_AddEvent;
            if (currentText.tag==1003) {
                
                // Automatic set current date and time in text field
                dateIs = [NSString stringWithFormat:@"%@", [df stringFromDate:[NSDate date]]];
                currentText.text = dateIs;
                [_datePicker setDate:[NSDate date]];
                NSString *timestamp = [NSString stringWithFormat:@"%f", [[_datePicker date] timeIntervalSince1970]];
                startTime = [timestamp doubleValue];
                df.dateFormat =DATE_FORMAT_Y_M_D_H_M_S;
                
                [CalendarEvent ShareInstance].strStartDate= [df stringFromDate:_datePicker.date];
                [CalendarEvent ShareInstance].strActualStartDate=[df stringFromDate:_datePicker.date];
                
            }else  if (currentText.tag==1004) {
                
                // Automatic set date and time After one hour of start time in text field
                NSDate *enddate=[[_datePicker date] dateByAddingTimeInterval:(60*60)];
                enddate !=nil ?  [_datePicker setDate:enddate] :@"";
                
                dateIs = [NSString stringWithFormat:@"%@", [df stringFromDate:[_datePicker date]]];
                currentText.text = dateIs;
                NSString *timestamp = [NSString stringWithFormat:@"%f", [[_datePicker date] timeIntervalSince1970]];
                endTime = [timestamp doubleValue];
                df.dateFormat =DATE_FORMAT_Y_M_D_H_M_S;
                [CalendarEvent ShareInstance].strEndDate= [df stringFromDate:_datePicker.date];
            }
            df=nil;
        }
        [SingletonClass setListPickerDatePickerMultipickerVisible:YES :_datePicker :toolBar];
        return NO;
    }else
    {
        
    }
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField.tag==1001 && textField.text.length > 2) {
        [self getLatLong:textField.text];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self doneClicked];
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark- UITextView Delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    textView.textColor=[UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1];
    CGPoint p;
    p.x=160;
    p.y=invisiblePosition;
    [self.view viewWithTag:70].center =p ;
    [self setContentOffset:textView table:_scrollview];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    // to manage placeholder text
    if (textView.text.length==0)
    {
        // textView.text=KEY_DESCRIPTION;
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    // to manage placeholder text
    if ([textView.text isEqualToString:KEY_DESCRIPTION])
    {
        //textView.text=EMPTYSTRING;
    }
    
    return YES;
}
- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    textView.autocorrectionType = UITextAutocorrectionTypeNo;
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)RepeatClick:(id)sender {
    
    [self doneClicked];
    
    if ([CalendarEvent ShareInstance].strStartDate.length==0 || [CalendarEvent ShareInstance].strEndDate.length==0 ) {
        [SingletonClass initWithTitle:EMPTYSTRING message:@"Please select event start & end date " delegate:nil btn1:@"Ok"];
    }else{
        if([CalendarEvent ShareInstance].strRepeatSting.length > 0)
        {
            [CalendarEvent ShareInstance].strEventAddOrEdit=@"Edit";
        }
        
        if (![[CalendarEvent ShareInstance].strEventEditBy isEqualToString:@"Edit Occurrence"]){
            
            [_EnableDesableBtn setImage:BTNEnableImage];
            NSArray *arrController=[self.navigationController viewControllers];
            BOOL Status=FALSE;
            for (id object in arrController)
            {
                if ([object isKindOfClass:[RepeatCalendarEvent class]])
                {
                    Status=TRUE;
                    RepeatCalendarEvent *repeatEvent=(RepeatCalendarEvent *)(object);
                    repeatEvent.obj=_eventDetailsDic;
                    [self.navigationController popToViewController:repeatEvent animated:NO];
                }
            }
            if (Status==FALSE)
            {
                RepeatCalendarEvent *repeatEvent=[[RepeatCalendarEvent alloc] initWithNibName:@"RepeatCalendarEvent" bundle:nil];
                repeatEvent.obj=_eventDetailsDic;
                [self.navigationController pushViewController:repeatEvent animated:NO];
            }
            
        }else
        {
            
        }
    }
    
    
}
@end
