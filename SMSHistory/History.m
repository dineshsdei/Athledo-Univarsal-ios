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

@end

@implementation History

#pragma mark UIViewController life cycle Method 

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark- UITableview Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SMShistoryCell";
    static NSString *CellNib = @"SMSHistoryCell";
    SMSHistoryCell *cell = (SMSHistoryCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellNib owner:self options:nil];
        cell = (SMSHistoryCell *)[nib objectAtIndex:0];
        // [cell.contentView setUserInteractionEnabled:NO];
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
    if (isIPAD) {
        return 70;
    }else
    {
        return 70;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}

@end
