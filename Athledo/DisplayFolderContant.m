//
//  DisplayFolderContant.m
//  Athledo
//
//  Created by Dinesh Kumar on 12/18/14.
//  Copyright (c) 2014 Dinesh. All rights reserved.
//

#import "DisplayFolderContant.h"
#import "MultimediaCell.h"
#import "UIImageView+WebCache.h"

@interface DisplayFolderContant ()
{
    NSMutableArray *multimediaData;
}

@end

@implementation DisplayFolderContant

- (void)viewDidLoad {
    
    self.navigationController.navigationBar.titleTextAttributes= [NSDictionary dictionaryWithObjectsAndKeys:
                                                                  [UIColor lightGrayColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:18],NSFontAttributeName,nil];
    self.navigationController.navigationBar.tintColor=[UIColor lightGrayColor];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title=_screenTitle;
    
    multimediaData=(NSMutableArray *)_picData;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
    
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int noOfRow=(int)multimediaData.count/2;
    
    if (noOfRow==0) {
        
        if (multimediaData.count==1) {
            return (multimediaData.count/2+1);
        }else
            return (multimediaData.count/2);
    }else{
        return (multimediaData.count/2+1);
    }
    
    return (multimediaData.count/2);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"MultimediaCell_%d_%d",(int)indexPath.section,(int)indexPath.row ];
    static NSString *CellNib = @"MultimediaCell";
    MultimediaCell *cell;
    cell = (MultimediaCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellNib owner:self options:nil];
        cell = (MultimediaCell *)[nib objectAtIndex:0];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.First_imageview.layer.borderWidth=1.0;
        cell.Second_imageview.layer.borderWidth=1.0;
        cell.First_imageview.layer.borderColor=[UIColor lightGrayColor].CGColor;
        cell.Second_imageview.layer.borderColor=[UIColor lightGrayColor].CGColor;
        
    }
    
    
    if (multimediaData.count > 2*indexPath.row ) {
        [cell.First_imageview setImageWithURL:[[multimediaData valueForKey:@"img"] objectAtIndex:(2*indexPath.row)] placeholderImage:[UIImage imageNamed:@"profile_icon.png"]];
        [cell.First_lblName setText:[[multimediaData valueForKey:@"name"] objectAtIndex:(2*indexPath.row)]];
        [cell.First_textViewDes setText:[[multimediaData valueForKey:@"description"] objectAtIndex:(2*indexPath.row)]];
    }else
    {
        cell.First_imageview.hidden=YES;
        cell.First_lblName.hidden=YES;
        cell.First_textViewDes.hidden=YES;
    }
    
    
    if (multimediaData.count > 2*indexPath.row+1) {
        
        [cell.Second_imageview setImageWithURL:[[multimediaData valueForKey:@"img"] objectAtIndex:(2*indexPath.row+1)] placeholderImage:[UIImage imageNamed:@"profile_icon.png"]];
        [cell.Second_lblName setText:[[multimediaData valueForKey:@"name"] objectAtIndex:indexPath.row+1]];
        [cell.SecondTextviewDes setText:[[multimediaData valueForKey:@"description"] objectAtIndex:(2*indexPath.row+1)]];
        
    }else
    {
        
        cell.Second_imageview.hidden=YES;
        cell.Second_lblName.hidden=YES;
        cell.SecondTextviewDes.hidden=YES;
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (isIPAD) ? 240 :190;
    
}



@end
