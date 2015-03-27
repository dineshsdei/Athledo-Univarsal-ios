

#import "MJGeocoder.h"
#import "JSON.h"

@implementation MJGeocoder

@synthesize delegate, results;

/*
 *	Opens a URL Connection and calls Google's JSON geocoding service
 *
 *  address: address to geocode
 *  title: custom title for location (useful for passing an annotation title on through the AddressComponents object)
 */
- (void)findLocationsWithAddress:(NSString *)address title:(NSString *)title{
    
    if(title) pinTitle = title;
    
    //build url string using address query
	NSString *urlString = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=true", address];
	
	//build request URL
	NSURL *requestURL = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    //build NSURLRequest
    NSURLRequest *geocodingRequest=[NSURLRequest requestWithURL:requestURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    //create connection and start downloading data
    NSURLConnection *connection=[[NSURLConnection alloc] initWithRequest:geocodingRequest delegate:self];
    if(connection){
        //connection valid, so init data holder
        receivedData = [[NSMutableData data] retain];
    }else{        
        //connection failed, tell delegate
        NSError *error = [NSError errorWithDomain:@"MJGeocoderError" code:5 userInfo:nil];
        [delegate geocoder:self didFailWithError:error];
    }
    
}

/*
 *  Reset data when a new response is received
 */
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [receivedData setLength:0];
}


/*
 *  Append received data
 */
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    
    [connection release];
    [receivedData release];
}

/*
 *  Called when done downloading response from Google. Builds a table of AddressComponents objects
 *	and tells the delegate that it was successful or informs the delegate of a failure.
 */
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	//get response
	NSString *geocodingResponse = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    
    [connection release];
    [receivedData release];
    
	//result as dictionary dictionary
	NSDictionary *resultDict = [geocodingResponse JSONValue];
    [geocodingResponse release];
    
	NSString *status = [resultDict valueForKey:@"status"];
	if([status isEqualToString:@"OK"]){
		//if successful, build results array
		NSArray *foundLocations = [resultDict objectForKey:@"results"];
		results = [NSMutableArray arrayWithCapacity:[foundLocations count]];
		
		for (NSDictionary *location in foundLocations) {
		
            double lat = [[[[location objectForKey:@"geometry"] objectForKey:@"location"] valueForKey:@"lat"] doubleValue];
            double lng = [[[[location objectForKey:@"geometry"] objectForKey:@"location"] valueForKey:@"lng"] doubleValue];
            
            CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(lat, lng);
			Address *resultAddress = [[[Address alloc] initWithCoordinate:coord] autorelease];
          
            // Crashing in ios 8 so comment it and required only lat and long
            
            /*
            
			resultAddress.name = pinTitle;
			resultAddress.fullAddress = [location valueForKey:@"formatted_address"];
			resultAddress.streetNumber = [Address addressComponent:@"street_number" inAddressArray:firstResultAddress ofType:@"long_name"];
			resultAddress.route = [Address addressComponent:@"route" inAddressArray:firstResultAddress ofType:@"long_name"];
			resultAddress.city = [Address addressComponent:@"locality" inAddressArray:firstResultAddress ofType:@"long_name"];
			resultAddress.stateCode = [Address addressComponent:@"administrative_area_level_1" inAddressArray:firstResultAddress ofType:@"short_name"];
			resultAddress.postalCode = [Address addressComponent:@"postal_code" inAddressArray:firstResultAddress ofType:@"short_name"];
			resultAddress.countryName = [Address addressComponent:@"country" inAddressArray:firstResultAddress ofType:@"long_name"];
             */
			
			[results addObject:resultAddress];
		}
		
		[delegate geocoder:self didFindLocations:results];
	}else{
		//if status code is not OK
		NSError *error = nil;
		
		if([status isEqualToString:@"ZERO_RESULTS"])
		{
			error = [NSError errorWithDomain:@"MJGeocoderError" code:1 userInfo:nil];
		}
		else if([status isEqualToString:@"OVER_QUERY_LIMIT"])
		{
			error = [NSError errorWithDomain:@"MJGeocoderError" code:2 userInfo:nil];
		}
		else if([status isEqualToString:@"REQUEST_DENIED"])
		{
			error = [NSError errorWithDomain:@"MJGeocoderError" code:3 userInfo:nil];
		}
		else if([status isEqualToString:@"INVALID_REQUEST"])
		{
			error = [NSError errorWithDomain:@"MJGeocoderError" code:4 userInfo:nil];
		}
		
		[delegate geocoder:self didFailWithError:error];
	}
}


@end
