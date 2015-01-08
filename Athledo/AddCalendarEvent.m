//
//  AddCalendarEvent.m
//  Athledo
//
//  Created by Dinesh Kumar on 10/16/14.
//  Copyright (c) 2014 Dinesh. All rights reserved.
//

#import "AddCalendarEvent.h"
#import "CalendarMonthViewController.h"
#import "MJGeocoder.h"
#import "RepeatCalendarEvent.h"
#import "CalendarDayViewController.h"
#import "WeekViewController.h"
#define  AddEventTag 510
#define  DeleteEventTag 520


@interface AddCalendarEvent ()
{
    
    UITextField *currentText;
    WebServiceClass *webservice;

    NSString *strLat;
    NSString *strLong;

    NSString *strAddBeforeTag;
    NSString *strNaveegatorStatus;

    BOOL isDate;
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
//     ActiveIndicator *acti = (ActiveIndicator *)[self.view viewWithTag:50];
//    [acti removeFromSuperview];
//    acti=nil;
    [SingaltonClass RemoveActivityIndicator:self.view];
    
    
    
    switch (Tag)
    {
    case AddEventTag:
    {

    if([[MyResults objectForKey:@"status"] isEqualToString:@"success"])
    {// Now we Need to decrypt data
         self.navigationItem.rightBarButtonItem.enabled=YES;
        [SingaltonClass ShareInstance].isCalendarUpdate=TRUE;
        [SingaltonClass initWithTitle:@"" message:@"Event saved successfully" delegate:self btn1:@"Ok"];
    }else {
        
        self.navigationItem.rightBarButtonItem.enabled=YES;
        [SingaltonClass initWithTitle:@"" message:@"Event have not saved" delegate:nil btn1:@"Ok"];

    }

    break;
    } case DeleteEventTag:
    {

    if([[MyResults objectForKey:@"status"] isEqualToString:@"success"])
    {// Now we Need to decrypt data
        self.navigationItem.rightBarButtonItem.enabled=YES;
        [SingaltonClass ShareInstance].isCalendarUpdate=TRUE;
        [SingaltonClass initWithTitle:@"" message:@"Event delete successfully" delegate:self btn1:@"Ok"];
    }else {
        
        self.navigationItem.rightBarButtonItem.enabled=YES;
        [SingaltonClass initWithTitle:@"" message:@"Event didn't delete" delegate:nil btn1:@"Ok"];
        
    }

    break;
    }
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
     [SingaltonClass RemoveActivityIndicator:self.view];
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
        
        if ([object isKindOfClass:[_strMoveControllerName class]])
        {
            Status=TRUE;
            [self.navigationController popToViewController:object animated:NO];
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
    
    
    Address *addressModel =locations.count > 0 ? [locations objectAtIndex:0] : @"";
  
    if([addressModel title])
    {
        ///  NSLog(@"Title is = %@",[addressModel title]);
    }else{
        NSLog(@"Title is = %@", [addressModel fullAddress]);
    }
    /////NSLog(@"Addrs = %@ ",[NSString stringWithFormat:@"%f,%f", addressModel.coordinate.latitude, addressModel.coordinate.longitude]);
   // NSString *strLatLong = [NSString stringWithFormat:@"%f,%f", addressModel.coordinate.latitude, addressModel.coordinate.longitude];
    
    strLat= [NSString stringWithFormat:@"%f", addressModel.coordinate.latitude];
    strLong= [NSString stringWithFormat:@"%f",  addressModel.coordinate.longitude];

}
- (void)geocoder:(MJGeocoder *)geocoder didFailWithError:(NSError *)error
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    NSLog(@"GEOCODE ERROR CODE: %ld", (long)[error code]);
    
    
    if([error code] == 1)
    {
        
            [SingaltonClass initWithTitle:@"" message:@"Please enter valid city name" delegate:nil btn1:@"Ok"];
        
    }
}
-(int)CalculateTimeInterval :(NSString *)ActualstartDate :(NSString *)startDate
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat =DATE_FORMAT_Y_M_D_H_M_S;
    
    NSArray *ActualstartDatecomponenets=[ActualstartDate componentsSeparatedByString:@" "];
    NSArray *startDateDatecomponenets=[startDate componentsSeparatedByString:@" "];
    
    NSString *strFinalDate=[[startDateDatecomponenets objectAtIndex:0] stringByAppendingFormat:@" %@",[ActualstartDatecomponenets objectAtIndex:1]];
    
    NSDate *date=[df dateFromString:strFinalDate];
    
    double TotalStartDate=[date timeIntervalSince1970];
    //double timeAfterSubstract=TotalStartDate-((5*60*60)+(30*60));
  
    return (TotalStartDate);
}
-(void)DeleteEventAlert:(id)sender
{
     [SingaltonClass initWithTitle:@"" message:@"Event will be deleted permanently, are you sure?" delegate:self btn1:@"YES" btn2:@"NO" tagNumber:10];
}
-(void)deleteEvent
{
    if ([SingaltonClass  CheckConnectivity])
    {
    NSString *strAddBeforeParameter=@"";
    NSString *strStatus=@"";

    NSMutableDictionary* dicttemp = [[NSMutableDictionary alloc] init];

    if (_eventDetailsDic)
    {
        NSString *strValue=[_eventDetailsDic valueForKey:@"rec_type"] ? [_eventDetailsDic valueForKey:@"rec_type"] : @"" ;
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
            [dicttemp setObject:@"" forKey:[NSString stringWithFormat:@"%@%@",strAddBeforeParameter,@"event_pid"]];
            [dicttemp setObject:[_eventDetailsDic valueForKey:@"event_id"] forKey:[NSString stringWithFormat:@"%@%@",strAddBeforeParameter,@"id"]];
            [dicttemp setObject:[_eventDetailsDic valueForKey:@"location"] forKey:[NSString stringWithFormat:@"%@%@",strAddBeforeParameter,@"location"]];
             [dicttemp setObject:[_eventDetailsDic valueForKey:@"name"] forKey:[NSString stringWithFormat:@"%@%@",strAddBeforeParameter,@"name"]];
             [dicttemp setObject:@"" forKey:[NSString stringWithFormat:@"%@%@",strAddBeforeParameter,@"rec_pattern"]];
             [dicttemp setObject:@"" forKey:[NSString stringWithFormat:@"%@%@",strAddBeforeParameter,@"rec_type"]];
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
            else
            {
            }
            
            [dicttemp setObject:strStatus forKey:[NSString stringWithFormat:@"%@%@", strAddBeforeParameter,@"!nativeeditor_status"]];
            [dicttemp setObject:[_eventDetailsDic valueForKey:@"end_date"] forKey:[NSString stringWithFormat:@"%@%@",strAddBeforeParameter,@"end_date"]];
            [dicttemp setObject:[_eventDetailsDic valueForKey:@"start_date"] forKey:[NSString stringWithFormat:@"%@%@",strAddBeforeParameter,@"start_date"]];
            [dicttemp setObject:[_eventDetailsDic valueForKey:@"event_length"] forKey:[NSString stringWithFormat:@"%@%@",strAddBeforeParameter,@"event_length"]];
            [dicttemp setObject:@"0" forKey:[NSString stringWithFormat:@"%@%@",strAddBeforeParameter,@"event_pid"]];
            [dicttemp setObject:[_eventDetailsDic valueForKey:@"event_id"] forKey:[NSString stringWithFormat:@"%@%@",strAddBeforeParameter,@"id"]];
            [dicttemp setObject:[_eventDetailsDic valueForKey:@"location"] forKey:[NSString stringWithFormat:@"%@%@",strAddBeforeParameter,@"location"]];
            [dicttemp setObject:[_eventDetailsDic valueForKey:@"name"] forKey:[NSString stringWithFormat:@"%@%@",strAddBeforeParameter,@"name"]];
            [dicttemp setObject:[[[_eventDetailsDic valueForKey:@"rec_type"] componentsSeparatedByString:@"#"] objectAtIndex:0] forKey:[NSString stringWithFormat:@"%@%@",strAddBeforeParameter,@"rec_pattern"]];
            [dicttemp setObject:[_eventDetailsDic valueForKey:@"rec_type"] forKey:[NSString stringWithFormat:@"%@%@",strAddBeforeParameter,@"rec_type"]];
            [dicttemp setObject:[_eventDetailsDic valueForKey:@"text"] forKey:[NSString stringWithFormat:@"%@%@",strAddBeforeParameter,@"text"]];
            [dicttemp setObject:[strAddBeforeParameter stringByReplacingOccurrencesOfString:@"_" withString:@""] forKey:@"ids"];
           
            
            break;
        }
        case 2:
        {
         // Delete repeat type event of type Edit by Occurrence
            
            if ([[_eventDetailsDic valueForKey:@"event_pid"] intValue]==0) {
                
                strAddBeforeParameter=@"1418618715293_";
                strStatus=@"inserted";
            }
            else
            {
            }
            
            [dicttemp setObject:strStatus forKey:[NSString stringWithFormat:@"%@%@", strAddBeforeParameter,@"!nativeeditor_status"]];
            [dicttemp setObject:[_eventDetailsDic valueForKey:@"end_date"] forKey:[NSString stringWithFormat:@"%@%@",strAddBeforeParameter,@"end_date"]];
            [dicttemp setObject:[_eventDetailsDic valueForKey:@"start_date"] forKey:[NSString stringWithFormat:@"%@%@",strAddBeforeParameter,@"start_date"]];
            
            [dicttemp setObject:[NSString stringWithFormat:@"%d",[self CalculateTimeInterval:[_eventDetailsDic valueForKey:@"actual_start_date"] :[_eventDetailsDic valueForKey:@"start_date"]]]  forKey:[NSString stringWithFormat:@"%@%@",strAddBeforeParameter,@"event_length"]];
            
            [dicttemp setObject:[_eventDetailsDic valueForKey:@"event_id"] forKey:[NSString stringWithFormat:@"%@%@",strAddBeforeParameter,@"event_pid"]];
            [dicttemp setObject:[strAddBeforeParameter stringByReplacingOccurrencesOfString:@"_" withString:@""] forKey:[NSString stringWithFormat:@"%@%@",strAddBeforeParameter,@"id"]];
            [dicttemp setObject:[_eventDetailsDic valueForKey:@"location"] forKey:[NSString stringWithFormat:@"%@%@",strAddBeforeParameter,@"location"]];
            [dicttemp setObject:[_eventDetailsDic valueForKey:@"lat"] forKey:[NSString stringWithFormat:@"%@%@",strAddBeforeParameter,@"lat"]];
            [dicttemp setObject:[_eventDetailsDic valueForKey:@"lng"] forKey:[NSString stringWithFormat:@"%@%@",strAddBeforeParameter,@"lng"]];
            [dicttemp setObject:[_eventDetailsDic valueForKey:@"name"] forKey:[NSString stringWithFormat:@"%@%@",strAddBeforeParameter,@"name"]];
            [dicttemp setObject:@"none" forKey:[NSString stringWithFormat:@"%@%@",strAddBeforeParameter,@"rec_pattern"]];
            [dicttemp setObject:@"none" forKey:[NSString stringWithFormat:@"%@%@",strAddBeforeParameter,@"rec_type"]];
            [dicttemp setObject:[_eventDetailsDic valueForKey:@"text"] forKey:[NSString stringWithFormat:@"%@%@",strAddBeforeParameter,@"text"]];
            [dicttemp setObject:[strAddBeforeParameter stringByReplacingOccurrencesOfString:@"_" withString:@""] forKey:@"ids"];
            
            
            break;
        }
        default:
            break;
    }

    }
        [dicttemp setObject:@"mobile" forKey:@"interface"];
        [dicttemp setObject:[NSString stringWithFormat:@"%d",[UserInformation shareInstance].userType] forKey:@"type"];
        [dicttemp setObject:[NSString stringWithFormat:@"%d",[UserInformation shareInstance].userId] forKey:@"user_id"];
        [dicttemp setObject:[NSString stringWithFormat:@"%d",[UserInformation shareInstance].userSelectedTeamid] forKey:@"team_id"];

    [SingaltonClass addActivityIndicator:self.view];

    [webservice WebserviceCallwithDic:dicttemp :webServiceAddEvents :DeleteEventTag];


    }else{
        self.navigationItem.rightBarButtonItem.enabled=YES;
        [SingaltonClass initWithTitle:@"" message:@"Internet connection is not available" delegate:nil btn1:@"Ok"];
        
    }

    
}

-(void)SaveEvent
{
    // Create startdate first because start time used in end date time
    
    [SingaltonClass ShareInstance].isCalendarUpdate=TRUE;
    if ([SingaltonClass  CheckConnectivity])
    {
        self.navigationItem.rightBarButtonItem.enabled=NO;
        NSString *strError = @"";
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
            [SingaltonClass initWithTitle:@"" message:strError delegate:nil btn1:@"Ok"];
            return;
       
        }else{
            
          
        }
        
    if ([SingaltonClass  CheckConnectivity])
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
            
            if([[CalendarEvent ShareInstance].strRepeatSting isEqualToString:@""])
            {
                [CalendarEvent ShareInstance].strRepeatSting=[_eventDetailsDic valueForKey:@"rec_type"];
            }else{
                
                
            }
            
            [dicttemp setObject:@"0" forKey:[NSString stringWithFormat:@"%@%@",strAddBeforeTag,@"event_pid"]];
            
            [dicttemp setObject:[NSString stringWithFormat:@"%f",(endTime-startTime)] forKey:[NSString stringWithFormat:@"%@%@", strAddBeforeTag,@"event_length"]];

      
        
        }
        else if ([[CalendarEvent ShareInstance].strEventEditBy isEqualToString:@"Edit Occurrence"]){
            
            if([[CalendarEvent ShareInstance].strRepeatSting isEqualToString:@""])
            {
                [CalendarEvent ShareInstance].strRepeatSting=[_eventDetailsDic valueForKey:@"rec_type"];
            }else{
                
                
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

       }
        else{
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

    [dicttemp setObject:@"" forKey:[NSString stringWithFormat:@"%@%@", strAddBeforeTag,@"id"]];
    }
    //  Comman code

    [dicttemp setObject:[NSString stringWithFormat:@"%d",userInfo.userType] forKey:@"type"];
    [dicttemp setObject:[NSString stringWithFormat:@"%d",userInfo.userId] forKey:@"user_id"];
    [dicttemp setObject:[NSString stringWithFormat:@"%d",userInfo.userSelectedTeamid] forKey:@"team_id"];
    [dicttemp setObject:strNaveegatorStatus forKey:[NSString stringWithFormat:@"%@%@", strAddBeforeTag,@"!nativeeditor_status"]];
    [dicttemp setObject:@"mobile" forKey:@"interface"];
    [dicttemp setObject:[NSString stringWithFormat:@"%@",_tfLocation.text] forKey:[NSString stringWithFormat:@"%@%@", strAddBeforeTag,@"location"]];
    [dicttemp setObject:strLat forKey:[NSString stringWithFormat:@"%@%@", strAddBeforeTag,@"lat"]];
    [dicttemp setObject:strLong forKey:[NSString stringWithFormat:@"%@%@", strAddBeforeTag,@"lng"]];
    [dicttemp setObject:[NSString stringWithFormat:@"%@",_tfTitle.text] forKey:[NSString stringWithFormat:@"%@%@", strAddBeforeTag,@"text"]];
    [dicttemp setObject:[NSString stringWithFormat:@"%@",_texviewDescription.text] forKey:[NSString stringWithFormat:@"%@%@", strAddBeforeTag,@"name"]];
    [dicttemp setObject:[self CalculateStartdate] forKey:[NSString stringWithFormat:@"%@%@", strAddBeforeTag,@"start_date"]];
    [dicttemp setObject:[strAddBeforeTag stringByReplacingOccurrencesOfString:@"_" withString:@""] forKey:[NSString stringWithFormat:@"%@",@"ids"]];

    if ([CalendarEvent ShareInstance].CalendarRepeatStatus==TRUE)
    {
    // Event Add or edit repeat case

    [dicttemp setObject:[self CalculateEventEndDate] forKey:[NSString stringWithFormat:@"%@%@", strAddBeforeTag,@"end_date"]];

    NSArray *arrComponents=[[CalendarEvent ShareInstance].strRepeatSting componentsSeparatedByString:@"#"];

    // In case Occurrence Add or edit rec_pattern and rec_type set black 

    if (![[CalendarEvent ShareInstance].strEventEditBy isEqualToString:@"Edit Occurrence"]){

    if (arrComponents.count > 0) {
          [dicttemp setObject:[arrComponents objectAtIndex:0] forKey:[NSString stringWithFormat:@"%@%@", strAddBeforeTag,@"rec_pattern"]];
    }else{
         [dicttemp setObject:@"" forKey:[NSString stringWithFormat:@"%@%@", strAddBeforeTag,@"rec_pattern"]];
    }
    [dicttemp setObject:[NSString stringWithFormat:@"%@",[CalendarEvent ShareInstance].strRepeatSting] forKey:[NSString stringWithFormat:@"%@%@", strAddBeforeTag,@"rec_type"]];
    }else{

    [dicttemp setObject:@"" forKey:[NSString stringWithFormat:@"%@%@", strAddBeforeTag,@"rec_pattern"]];
    [dicttemp setObject:@"" forKey:[NSString stringWithFormat:@"%@%@", strAddBeforeTag,@"rec_type"]];
    }

    }else{
    // Event Add or edit non repeat case
    [dicttemp setObject:[self DateINY_M_D_H_M_S:_tfEndTime.text] forKey:[NSString stringWithFormat:@"%@%@", strAddBeforeTag,@"end_date"]];
    [dicttemp setObject:@"" forKey:[NSString stringWithFormat:@"%@%@", strAddBeforeTag,@"rec_pattern"]];
    [dicttemp setObject:@"" forKey:[NSString stringWithFormat:@"%@%@", strAddBeforeTag,@"rec_type"]];
    [dicttemp setObject:[NSString stringWithFormat:@"%@",@""] forKey:[NSString stringWithFormat:@"%@%@", strAddBeforeTag,@"event_length"]];
    }

    isDate=FALSE;


   [SingaltonClass addActivityIndicator:self.view];

    [webservice WebserviceCallwithDic:dicttemp :webServiceAddEvents :AddEventTag];


    }else{
    self.navigationItem.rightBarButtonItem.enabled=YES;
    [SingaltonClass initWithTitle:@"" message:@"Internet connection is not available" delegate:nil btn1:@"Ok"];

    }

    }

}

-(NSString *)CalculateStartdate
{
    NSString *strDate=[[[CalendarEvent ShareInstance].strStartDate componentsSeparatedByString:@" "] objectAtIndex:0];
    NSString *strTime=[[[self DateINY_M_D_H_M_S: _tfStartTime.text ] componentsSeparatedByString:@" "] objectAtIndex:1];
    
    strDate=[strDate stringByAppendingFormat:@" %@",strTime];
    [CalendarEvent ShareInstance].strStartDate=strDate;
    
    return strDate;
}

-(NSString *)CalculateEventEndDate
{
    NSString *enddate=@"";

    NSString *strStartdate=[CalendarEvent ShareInstance].strStartDate;

    if ([[CalendarEvent ShareInstance].strEventType isEqualToString:@"Daily"] || [[CalendarEvent ShareInstance].strEventType isEqualToString:@"Weekly"]) {

    if ([[CalendarEvent ShareInstance].strEndDate isEqualToString:@"9999-02-01 00:00:00"])
    {
         // End date in case of infinite date

        [CalendarEvent ShareInstance].strEndDate=@"9999-02-01 00:00:00";
        enddate=@"9999-02-01 00:00:00";

    }else if ([CalendarEvent ShareInstance].NoOfDay != 0 && [CalendarEvent ShareInstance].NoOfOccurrence != 0)
    {
            if ([[CalendarEvent ShareInstance].strEventType isEqualToString:@"Daily"]) {
                // Daily event Calculate end date , End date after startdate of (Occurrance multiply by no of days)
                /*
                int endDateAfter;
                NSDateFormatter *locFormater=[[NSDateFormatter alloc] init];
                locFormater.dateFormat =DATE_FORMAT_Y_M_D_H_M_S;
                endDateAfter=[CalendarEvent ShareInstance].NoOfOccurrence*[CalendarEvent ShareInstance].NoOfDay;
                NSDate *date=[locFormater dateFromString:strStartdate];
                NSDate *newDate1 = [date dateByAddingTimeInterval:60*60*24*endDateAfter];
                [CalendarEvent ShareInstance].strEndDate =[locFormater stringFromDate:newDate1];
                
                */
                enddate=[self CalculateEndDateIn_Daily_WorkingDay_Case];
                //locFormater=nil;
                
            }else
            {
                // Weekly event Calculate end date

                int endDateAfter;
                NSDateFormatter *locFormater=[[NSDateFormatter alloc] init];
                locFormater.dateFormat =DATE_FORMAT_Y_M_D_H_M_S;
                NSArray *arrSelectedDays=[[CalendarEvent ShareInstance].strNoOfDaysWeekCase componentsSeparatedByString:@","];

                if((arrSelectedDays.count) < ([CalendarEvent ShareInstance].NoOfOccurrence))
                {
                    endDateAfter=[CalendarEvent ShareInstance].NoOfOccurrence;
                    
                }else if((arrSelectedDays.count) > ([CalendarEvent ShareInstance].NoOfOccurrence)){
                    
                    endDateAfter=[[arrSelectedDays objectAtIndex:arrSelectedDays.count-1] intValue];
                    
                }else{
                    
                     endDateAfter=([CalendarEvent ShareInstance].NoOfDay) * (7);
                    
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

        enddate=[[[[CalendarEvent ShareInstance].strEndDate componentsSeparatedByString:@" "] objectAtIndex:0] stringByAppendingFormat:@" 00:00:00"];
    }

    }else if ([[CalendarEvent ShareInstance].strEventType isEqualToString:@"Monthly"])
    {
        if ([[CalendarEvent ShareInstance].strEndDate isEqualToString:@"9999-02-01 00:00:00"]) {
            
            [CalendarEvent ShareInstance].strEndDate=@"9999-02-01 00:00:00";
            enddate=@"9999-02-01 00:00:00";
            
        }else if ([CalendarEvent ShareInstance].NoOfDay != 0 && [CalendarEvent ShareInstance].NoOfOccurrence != 0)
        {
            
            NSString *strDate=[[[CalendarEvent ShareInstance].strEndDate componentsSeparatedByString:@" "] objectAtIndex:0];
            NSString *strTime=[[[CalendarEvent ShareInstance].strStartDate componentsSeparatedByString:@" "] objectAtIndex:1];
            
            enddate=[strDate stringByAppendingFormat:@" %@",strTime];
            
        }else{

           // enddate=[CalendarEvent ShareInstance].strEndDate;
             enddate=[[[[CalendarEvent ShareInstance].strEndDate componentsSeparatedByString:@" "] objectAtIndex:0] stringByAppendingFormat:@" 00:00:00"];
        }

        
        }
    else if ([[CalendarEvent ShareInstance].strEventType isEqualToString:@"Yearly"])
    {
        // End date in yearly Case
        
        if ([[CalendarEvent ShareInstance].strEndDate isEqualToString:@"9999-02-01 00:00:00"]) {
        
            // Infinite case
            
            [CalendarEvent ShareInstance].strEndDate=@"9999-02-01 00:00:00";
            enddate=@"9999-02-01 00:00:00";
            
        }else if ([CalendarEvent ShareInstance].NoOfDay != 0 && [CalendarEvent ShareInstance].NoOfOccurrence != 0)
        {
             // No of occurrance- > end date will be startdate
            
            NSString *strDate=[[[CalendarEvent ShareInstance].strEndDate componentsSeparatedByString:@" "] objectAtIndex:0];
            NSString *strTime=[[[CalendarEvent ShareInstance].strStartDate componentsSeparatedByString:@" "] objectAtIndex:1];
            
            enddate=[strDate stringByAppendingFormat:@" %@",strTime];
            
        }else{
               // End by perticular date
            
           // enddate=[CalendarEvent ShareInstance].strEndDate;
             enddate=[[[[CalendarEvent ShareInstance].strEndDate componentsSeparatedByString:@" "] objectAtIndex:0] stringByAppendingFormat:@" 00:00:00"];
        }
    }

    return enddate;
}

-(NSString *)CalculateEndDateIn_Daily_WorkingDay_Case
{
    
    //IN case end date will be after working NoOfOccurrence days (Mon, Tue , Wed , Thu , Fri , ) from startdate
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:DATE_FORMAT_Y_M_D_H_M_S];

    NSDate *date=[formatter dateFromString:[CalendarEvent ShareInstance].strStartDate];

    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekdayOrdinalCalendarUnit | NSDayCalendarUnit) fromDate:date];

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

// append time of startdate in end date time in only repeat occurrence case
-(NSString *)endDateWithStartTime :(NSString *)strTime
{
    NSString *strStartdate=[self DateINY_M_D_H_M_S:[CalendarEvent ShareInstance].strStartDate];
    NSString *strEnddate=[self DateINY_M_D_H_M_S:strTime];

    NSArray *arrStartComponents=[strStartdate componentsSeparatedByString:@" "];
    NSArray *arrEndComponents=[strEnddate componentsSeparatedByString:@" "];

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
    
    
    if(_eventDetailsDic)
    {
        // In Case Edit, show delete and save button
        UIButton *btnDelete = [[UIButton alloc] initWithFrame:CGRectMake(110, 5, 44, 44)];
        UIImage *imageDelete=[UIImage imageNamed:@"deleteBtn.png"];
        [btnDelete addTarget:self action:@selector(DeleteEventAlert:) forControlEvents:UIControlEventTouchUpInside];
        [btnDelete setImage:imageDelete forState:UIControlStateNormal];
        UIBarButtonItem *ButtonItemDelete = [[UIBarButtonItem alloc] initWithCustomView:btnDelete];
        
//        CGRect applicationFrame = CGRectMake(100, 0, 220, 50);
//        UIView * newView = [[UIView alloc] initWithFrame:applicationFrame] ;
//        [newView addSubview:btnDelete];
//        
//        self.navigationItem.titleView=newView;
        
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
        [_EnableDesableBtn setImage:[UIImage imageNamed:@"btnEnable.png"]];
            
    }else{
        [_EnableDesableBtn setImage:[UIImage imageNamed:@"btnDissable.png"]];
    }


    }else
    {
    _tfRepeat.text=@"Never";
    [_EnableDesableBtn setImage:[UIImage imageNamed:@"btnDissable.png"]];
    }

    self.keyboardAppear = [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillShowNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
    // message received

    NSDictionary* info = [note userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    [self setDatePickerVisibleAt:NO];
    [self setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height-(kbSize.height+22))];
    scrollHeight=kbSize.height;


    }];
    
    self.keyboardHide = [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        // message received
        NSDictionary* info = [note userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
        
        [self setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height+(kbSize.height+22))];
        
    }];

    UIImageView *imageview1=[[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-3, self.view.frame.size.width, 3)];

    imageview1.image=[UIImage imageNamed:@"bottomBorder.png"];

    [self.view addSubview:imageview1];

    scrollHeight=0;


    [super viewWillAppear:animated];
}


-(void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self.keyboardAppear];
    [[NSNotificationCenter defaultCenter] removeObserver:self.keyboardHide];
    if (_eventDetailsDic) {

    //[_eventDetailsDic setValue:_tfTitle.text forKey:@"text"];
   // [_eventDetailsDic setValue:_tfLocation.text forKey:@"location"];
   // [_eventDetailsDic setValue:_texviewDescription.text forKey:@"name"];
    //[_eventDetailsDic setValue:_tfStartTime.text forKey:@"start_date"];
   // [_eventDetailsDic setValue:_tfEndTime.text forKey:@"end_date"];

    }

}

- (void)viewDidLoad
{
    webservice =[WebServiceClass shareInstance];
    webservice.delegate=self;

    _texviewDescription.textColor=[UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1];
    self.title=NSLocalizedString(_screentitle, @"");
    [self.navigationController.navigationItem setHidesBackButton:YES];

    NSLog(@"datta %@",_eventDetailsDic);

    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 22, 55)];
    _tfTitle.leftView = paddingView;
    _tfTitle.leftViewMode = UITextFieldViewModeAlways;

    UIView *paddingViewOne = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 22, 55)];
    _tfLocation.leftView = paddingViewOne;
    _tfLocation.leftViewMode = UITextFieldViewModeAlways;

    // To move left decrease y and move up decrease x

    //_texviewDescription.textContainerInset = UIEdgeInsetsMake(15, 18, 0, 0);
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
    _texviewDescription.text=[_eventDetailsDic valueForKey:@"name"];
    _texviewDescription.textColor=[UIColor grayColor];

    NSString *str=[_eventDetailsDic valueForKey:@"rec_type"] ?[_eventDetailsDic valueForKey:@"rec_type"] : @"";

        int RepeatIndex=0;
    if (str.length > 0) {
        
        // If event repeat type
        
        const char *c = str.length > 0 ? [str UTF8String] : [@""  UTF8String];
        if (c[0]=='d') {
        _tfRepeat.text=@"Daily";
            RepeatIndex=1;
        }else  if (c[0]=='w') {
        _tfRepeat.text=@"Weekly";
            RepeatIndex=2;
        }else  if (c[0]=='m') {
        _tfRepeat.text=@"Monthly";
            RepeatIndex=3;
        }else  if (c[0]=='y') {
            RepeatIndex=4;
        _tfRepeat.text=@"Yearly";
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
            
        [CalendarEvent ShareInstance].strActualStartDate=@"";
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
        if ([df stringFromDate:startdate] !=nil && [df stringFromDate:enddate] != nil)
        {
            
        [CalendarEvent ShareInstance].strActualStartDate=@"";
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
                if ([df stringFromDate:startdate] !=nil && [df stringFromDate:enddate] != nil) {
                    [CalendarEvent ShareInstance].strActualStartDate=@"";
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
                    [CalendarEvent ShareInstance].strActualStartDate=@"";
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
                if ([df stringFromDate:startdate] !=nil && [df stringFromDate:enddate] != nil) {
                    [CalendarEvent ShareInstance].strActualStartDate=@"";
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
                    [CalendarEvent ShareInstance].strActualStartDate=@"";
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
                
                if ([df stringFromDate:startdate] !=nil && [df stringFromDate:enddate] != nil) {
                    [CalendarEvent ShareInstance].strActualStartDate=@"";
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
                    [CalendarEvent ShareInstance].strActualStartDate=@"";
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
            [CalendarEvent ShareInstance].strActualStartDate=@"";
        [CalendarEvent ShareInstance].strStartDate=[df stringFromDate:startdate];
        [CalendarEvent ShareInstance].strActualStartDate=[_eventDetailsDic valueForKey:@"actual_start_date"];
        [CalendarEvent ShareInstance].strEndDate=[df stringFromDate:enddate];
    }

    strLat=[_eventDetailsDic valueForKey:@"lat"];
    strLong=[_eventDetailsDic valueForKey:@"lng"];

    df=nil;
    }else
    {
    [CalendarEvent ShareInstance].strEventType=@"";
    [CalendarEvent ShareInstance].strEndDate=@"";
    [CalendarEvent ShareInstance].strRepeatSting=@"";
    }
    
   
   // self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:btnDelete,ButtonItem, nil];

    self.navigationController.navigationBar.titleTextAttributes= [NSDictionary dictionaryWithObjectsAndKeys:
                                  [UIColor lightGrayColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:NavFontSize],NSFontAttributeName,nil];
    self.navigationController.navigationBar.tintColor=[UIColor lightGrayColor];



    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneClicked)];


    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];

    //UIBarButtonItem *rightButton = [[[UIBarButtonItem alloc] initWithTitle:@"Item" style:UIBarButtonItemStyleBordered target:self action:@selector(btnItem2Pressed:)] autorelease];


    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height+50, self.view.frame.size.width, 44)];
    toolBar.tag = 40;
    toolBar.items = [NSArray arrayWithObjects:flex,flex,btnDone,nil];
    [self.view addSubview:toolBar];

    //Set the Date picker view
    _datePicker.frame=CGRectMake(0, self.view.frame.size.height+50, self.view.frame.size.width, pickerHeight);

    _datePicker.date = [NSDate date];
    _datePicker.tag=70;
    //[datePicker setHidden:YES];
    _datePicker.backgroundColor=[UIColor whiteColor];
    [_datePicker addTarget:self action:@selector(dateChange) forControlEvents:UIControlEventValueChanged];

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
//-(IBAction)EnableDisableBtnRepeat:(UIGestureRecognizer*) recognizer
//{
//    NSData *data1 = UIImagePNGRepresentation(_EnableDesableBtn.image);
//    if (![[CalendarEvent ShareInstance].strEventEditBy isEqualToString:@"Edit Occurrence"])
//    {
//        
//    }
//    
//   }
//
//-(void)ClickOnReapt:(UIGestureRecognizer*) recognizer
//{
//    [_EnableDesableBtn setImage:[UIImage imageNamed:@"btnEnable.png"]];
//    [self doneClicked];
//    RepeatCalendarEvent *repeatEvent=[[RepeatCalendarEvent alloc] init];
//    repeatEvent.obj=_eventDetailsDic;
//    [self.navigationController pushViewController:repeatEvent animated:NO];
//}
- (void)viewDidLayoutSubviews {
    
    if ( isDate==TRUE) {
         [self.view viewWithTag:70].center = CGPointMake(160, visiblePicker);
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
                         NSLog(@"completion block");
                     }];
    
}
-(void)doneClicked
{
     [_scrollview setContentOffset:CGPointMake(0,0) animated: NO];
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
     [self setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height+50)];
    [self setDatePickerVisibleAt:NO];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark setcontent offset
-(void)setContentOffset:(id)textField table:(UIScrollView*)m_ScrollView {
   
    UIView* txt = textField;
    
    UIScrollView *theTextFieldCell = (UIScrollView *)[textField superview];
    
    // Get the text fields location
    CGPoint point = [theTextFieldCell convertPoint:theTextFieldCell.frame.origin toView:m_ScrollView];
    
    NSLog(@"%f",point.y + (txt.frame.origin.y));
    NSLog(@"%f",(txt.frame.origin.y));
    NSLog(@"%d",(scrollHeight));
    
    NSLog(@"%f",(txt.frame.origin.y));
    
    // Scroll to cell
    int position=self.view.frame.size.height-(txt.frame.origin.y+txt.frame.size.height);
    
    NSLog(@"%d",position);
    scrollHeight= scrollHeight ==0 ? [@"216" intValue]:scrollHeight;
    
    //if ((position < scrollHeight )) {
        [_scrollview setContentOffset:CGPointMake(0,2*(txt.frame.size.height+30)) animated: YES];
    //}
    
}


#pragma mark- UITextfield Delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
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

    [_datePicker setDate:date];

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
        [_datePicker setDate:enddate];

        dateIs = [NSString stringWithFormat:@"%@", [df stringFromDate:[_datePicker date]]];
        currentText.text = dateIs;
        NSString *timestamp = [NSString stringWithFormat:@"%f", [[_datePicker date] timeIntervalSince1970]];
        endTime = [timestamp doubleValue];
        df.dateFormat =DATE_FORMAT_Y_M_D_H_M_S;
        
        [CalendarEvent ShareInstance].strEndDate= [df stringFromDate:_datePicker.date];
        
        
    }
    df=nil;
    }
    
   [self setDatePickerVisibleAt:YES];

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
    if (textView.text.length==0)
    {
        //textView.textColor=[UIColor lightGrayColor];
        textView.text=@"Description";
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([textView.text isEqualToString:@"Description"])
    {
        
        textView.text=@"";
    }
    
    return YES;
}
- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
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

    [SingaltonClass initWithTitle:@"" message:@"Please select event start & end date " delegate:nil btn1:@"Ok"];

    }else{
    if([CalendarEvent ShareInstance].strRepeatSting.length > 0)
    {
    [CalendarEvent ShareInstance].strEventAddOrEdit=@"Edit";
    }

    if (![[CalendarEvent ShareInstance].strEventEditBy isEqualToString:@"Edit Occurrence"]){

    [_EnableDesableBtn setImage:[UIImage imageNamed:@"btnEnable.png"]];
   
        
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

    NSLog(@"repeat click");
    }
    
   
}
@end
