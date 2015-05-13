
#import "TKCalendarMonthViewController.h"
#import "TKCalendarMonthView.h"


@interface TKCalendarMonthViewController ()

@property (nonatomic,strong) NSTimeZone *timeZone;
@property (nonatomic,assign) BOOL sundayFirst;
@end

@implementation TKCalendarMonthViewController

- (instancetype) init{
	self = [self initWithSunday:YES];
	return self;
}
- (instancetype) initWithSunday:(BOOL)sundayFirst{
	self = [self initWithSunday:sundayFirst timeZone:[NSTimeZone defaultTimeZone]];
	return self;
}
- (instancetype) initWithTimeZone:(NSTimeZone *)timeZone{
	self = [self initWithSunday:YES timeZone:self.timeZone];
	return self;
}
- (instancetype) initWithSunday:(BOOL)sundayFirst timeZone:(NSTimeZone *)timeZone{
	if(!(self = [super init])) return nil;
	self.timeZone = timeZone;
	self.sundayFirst = sundayFirst;
	return self;
}
- (instancetype) initWithCoder:(NSCoder *)decoder {
    if(!(self=[super initWithCoder:decoder])) return nil;
	self.timeZone = [NSTimeZone defaultTimeZone];
	self.sundayFirst = YES;
    return self;
}
- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return NO;
}
- (void) loadView{
	[super loadView];
	self.view.backgroundColor = [UIColor whiteColor];
	
	if([self respondsToSelector:@selector(edgesForExtendedLayout)])
		self.edgesForExtendedLayout = UIRectEdgeNone;
	
	self.monthView = [[TKCalendarMonthView alloc] initWithSundayAsFirst:self.sundayFirst timeZone:self.timeZone];
	self.monthView.dataSource = self;
	self.monthView.delegate = self;
    self.monthView.controller=self;
	[self.view addSubview:self.monthView];
}

- (NSArray*) calendarMonthView:(TKCalendarMonthView*)monthView marksFromDate:(NSDate*)startDate toDate:(NSDate*)lastDate{
	return nil;
}


@end
