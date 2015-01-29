//
//  ALPickerView.m
//
//  Created by Alex Leutgöb on 11.11.11.
//  Copyright 2011 alexleutgoeb.com. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "ALPickerView.h"
#import "ALPickerViewCell.h"


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


@implementation ALPickerView

@synthesize delegate = delegate_;
@synthesize allOptionTitle;


#pragma mark - NSObject stuff

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)init {
	return [self initWithFrame:CGRectMake(0, 0, 320, 200)];
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithFrame:(CGRect)frame {
	// Set fix width and height
	if ((self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)])) {
        self.backgroundColor = [UIColor blackColor];
        self.clipsToBounds = YES;
        self.allOptionTitle = NSLocalizedString(@"All", @"All option title");
        
        internalTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, -2, frame.size.width-20, frame.size.height+18) style:UITableViewStylePlain];
        internalTableView.delegate = self;
        internalTableView.dataSource = self;
        internalTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        internalTableView.showsVerticalScrollIndicator = NO;
        internalTableView.scrollsToTop = NO;
        UIImage *backgroundImage = [[UIImage imageNamed:@"wheel_bg"] stretchableImageWithLeftCapWidth:4 topCapHeight:0];
        
        internalTableView.backgroundView = [[UIImageView alloc] initWithImage:backgroundImage];
        [self addSubview:internalTableView];
        
        // Add shadow to wheel
        UIImageView *shadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wheel_shadow"]];
        shadow.frame = internalTableView.frame;
        [self addSubview:shadow];
        
        // Add border images
        UIImageView *leftBorder = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"frame_left"]];
        leftBorder.frame = CGRectMake(0, 0, 15, frame.size.height);
        [self addSubview:leftBorder];
        UIImageView *rightBorder = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"frame_right"]];
        rightBorder.frame = CGRectMake(self.frame.size.width - 15, 0, 15, frame.size.height);
        [self addSubview:rightBorder];
        UIImageView *middleBorder = [[UIImageView alloc] initWithImage:
                                      [[UIImage imageNamed:@"frame_middle"]
                                       stretchableImageWithLeftCapWidth:0 topCapHeight:10]];
        middleBorder.frame = CGRectMake(15, 0, self.frame.size.width - 30, frame.size.height);
        [self addSubview:middleBorder];
    }
    return self;
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Custom methods

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)reloadAllComponents {
    [internalTableView reloadData];
}


#pragma mark - UITableView

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Add 4 additional rows for whitespace on top and bottom
    if (allOptionTitle)
        return [delegate_ numberOfRowsForPickerView:self] ? [delegate_ numberOfRowsForPickerView:self] + 5 : 0;
    else
        return [delegate_ numberOfRowsForPickerView:self] ? [delegate_ numberOfRowsForPickerView:self] + 4 : 0;
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ALPVCell";
    
    ALPickerViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ALPickerViewCell alloc] initWithReuseIdentifier:CellIdentifier] ;
    }
    
    if (indexPath.row < 2 || indexPath.row >= ([delegate_ numberOfRowsForPickerView:self] + (allOptionTitle ? 3 : 2))) {
        // Whitespace cell
        cell.textLabel.text = nil;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else {
        if (allOptionTitle && indexPath.row == 2) {
            cell.textLabel.text = allOptionTitle;
            BOOL allSelected = YES;
            for (int i = 0; i < [self.delegate numberOfRowsForPickerView:self]; i++) {
                if ([delegate_ pickerView:self selectionGroupForRow:i] == NO) {
                    allSelected = NO;
                    break;
                }
            }
            cell.selectionGroup = allSelected;
        }
        else {
            int actualRow = (int)(indexPath.row - (allOptionTitle ? 3 : 2));
            cell.textLabel.text = [delegate_ pickerView:self textForRow:actualRow];
            cell.selectionGroup = [delegate_ pickerView:self selectionGroupForRow:actualRow];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    return cell;
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row > 1 && indexPath.row < ([delegate_ numberOfRowsForPickerView:self] + (allOptionTitle ? 3 : 2))) {
        // Set selection state
        ALPickerViewCell *cell = (ALPickerViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        cell.selectionGroup = !cell.selectionGroup;
        
        // Inform delegate
        int actualRow = (int)(indexPath.row - (allOptionTitle ? 3 : 2));
        
        if (cell.selectionGroup != NO) {
            if ([self.delegate respondsToSelector:@selector(pickerView:didCheckRow:)])
                [delegate_ pickerView:self didCheckRow:actualRow];
        }
        else {
            if ([self.delegate respondsToSelector:@selector(pickerView:didUncheckRow:)])
                [delegate_ pickerView:self didUncheckRow:actualRow];
        }
        
        // Iterate visible cells and update them too
        for (ALPickerViewCell *aCell in tableView.visibleCells) {
            int iterateRow = (int)([tableView indexPathForCell:aCell].row - (allOptionTitle ? 3 : 2));
            
            if (allOptionTitle && iterateRow == -1) {
                BOOL allSelected = YES;
                for (int i = 0; i < [self.delegate numberOfRowsForPickerView:self]; i++) {
                    if ([delegate_ pickerView:self selectionGroupForRow:i] == NO) {
                        allSelected = NO;
                        break;
                    }
                }
                aCell.selectionGroup = allSelected;
            }
            else if (iterateRow >= 0 && iterateRow < [delegate_ numberOfRowsForPickerView:self]) {
                if (iterateRow == actualRow)
                    continue;
                aCell.selectionGroup = [delegate_ pickerView:self selectionGroupForRow:iterateRow];
            }
        }
        
        // Scroll the cell cell to the middle of the tableview
       // [tableView setContentOffset:CGPointMake(0, tableView.rowHeight * (indexPath.row - 2)) animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - ScrollView

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)scrollViewDidEndDecelerating:(UITableView *)tableView {
    int co = ((int)tableView.contentOffset.y % (int)tableView.rowHeight);
    if (co < tableView.rowHeight / 2)
        [tableView setContentOffset:CGPointMake(0, tableView.contentOffset.y - co) animated:YES];
    else
        [tableView setContentOffset:CGPointMake(0, tableView.contentOffset.y + (tableView.rowHeight - co)) animated:YES];
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)scrollViewDidEndDragging:(UITableView *)scrollView willDecelerate:(BOOL)decelerate {
    if(decelerate)
        return;
    [self scrollViewDidEndDecelerating:scrollView];
}

@end
