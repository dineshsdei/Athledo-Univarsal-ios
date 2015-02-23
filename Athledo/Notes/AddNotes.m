//
//  AddNotes.m
//  Athledo
//
//  Created by Dinesh Kumar on 2/23/15.
//  Copyright (c) 2015 Dinesh. All rights reserved.
//

#import "AddNotes.h"

@interface AddNotes ()

@end

@implementation AddNotes

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Add Notes";
    self.navigationController.navigationBar.titleTextAttributes= [NSDictionary dictionaryWithObjectsAndKeys:
                                                                  [UIColor lightGrayColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:NavFontSize],NSFontAttributeName,nil];
    self.navigationController.navigationBar.tintColor=[UIColor lightGrayColor];
    UIButton *btnShare = [[UIButton alloc] initWithFrame:CGRectMake(150, 5, 44, 44)];
    UIImage *imageHistory=[UIImage imageNamed:@"add.png"];
    [btnShare addTarget:self action:@selector(AddNote) forControlEvents:UIControlEventTouchUpInside];
    [btnShare setImage:imageHistory forState:UIControlStateNormal];
    
    UIBarButtonItem *BarItemHistory = [[UIBarButtonItem alloc] initWithCustomView:btnShare];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:BarItemHistory, nil];
    self.navigationItem.rightBarButtonItem.tintColor=[UIColor lightGrayColor];
}
-(void)AddNote
{
    
}
#pragma mark- TableviewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    
    
    return 1;
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 2;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"NotesCell";
    static NSString *CellNib = @"AddNoteCell";
    
    AddNoteCell *cell = (AddNoteCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellNib owner:self options:nil];
        cell = (AddNoteCell *)[nib objectAtIndex:0];
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isIPAD)
        return 120;
    else
        return 80;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
