//
//  CommunicationManager.m
//  LoyalAZ
//

#import "CommunicationManager.h"

@implementation CommunicationManager
@synthesize delegate = _delegate;

-(void)MakeHTTPPost:(NSString*)urlToPost postData:(NSString *)post
{
    //NSString *postStr = [NSString stringWithFormat:@"post_xml=%@",post];
    //NSString *postStr = [NSString stringWithFormat:@"fname=%@",@"aabbaa"];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:urlToPost]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    
    NSError *error = nil;
    NSURLResponse *response;
    NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *data=[[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
    //NSLog(@"RESPONSE=%@",data);
    [data release];
}

-(void)SendSOAPRequest:(NSString *)SOAPEnvelopeString
{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    nodeContent = [[NSMutableString alloc]init];
    
    NSString *urlString;
    Application *appObj = [Application applicationManager];
    
    if(appObj.BaseURLSet==NO)
    {
        BaseURL *bURL = [[BaseURL alloc]init];
        [bURL GetBaseURL];
    }
    
    urlString = appObj.SOAPURL;
    //NSLog(@"URL_HIT=%@",urlString);
    //NSURL *locationOfWebService = [NSURL URLWithString:@"http://www.loyalaz.com/setup/"];
    NSURL *locationOfWebService = [NSURL URLWithString:urlString];

    //NSLog(@"web url = %@",locationOfWebService);

    NSMutableURLRequest *theRequest = [[[NSMutableURLRequest alloc]initWithURL:locationOfWebService]autorelease];

    NSString *msgLength = [NSString stringWithFormat:@"%d",[SOAPEnvelopeString length]];


    [theRequest addValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue:@"http://schemas.microsoft.com/sharepoint/soap/GetListCollection" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    //the below encoding is used to send data over the net
    [theRequest setHTTPBody:[SOAPEnvelopeString dataUsingEncoding:NSUTF8StringEncoding]];


    NSURLConnection *connect = [[NSURLConnection alloc]initWithRequest:theRequest delegate:self];

    if (connect) {
        webData = [[NSMutableData alloc]init];
    }
    else {
        //NSLog(@"No Connection established");
    }
    //[webData release];

}


//NSURLConnection delegate method

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	[webData setLength: 0];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[webData appendData:data];
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
    [self.delegate communicationManagerErrorOccurred:error];
    //[self.delegate communicationManagerDidFinish:@"HEHEHEHEHEH"];
    
	//NSLog(@"ERROR with theConenction");
	//[connection release];
	[webData release];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

-(BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return YES;
}

-(void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    NSURLCredential *credential = [NSURLCredential credentialWithUser:@"username" password:@"password" persistence:NSURLCredentialPersistenceForSession];
	[[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
}


-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	//NSLog(@"DATA RECD===%@",theXML);
    convertToStringData = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
    [self.delegate communicationManagerDidFinish:convertToStringData];
	//[connection release];
}


@end
