//
//  FBCommunication.m
//  LoyalAZ
//

#import "FBCommunication.h"

@implementation FBCommunication
@synthesize delegate = _delegate;

-(NSString *)SendGraphRequest:(NSString *)pageName
{
    
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    nodeContent = [[NSMutableString alloc]init];
    
    
    NSString *urlString = [NSString stringWithFormat:@"https://graph.facebook.com/%@",pageName];
    NSURL *locationOfWebService = [NSURL URLWithString:urlString];
    
    
    NSMutableURLRequest *theRequest = [[[NSMutableURLRequest alloc]initWithURL:locationOfWebService]autorelease];
    
    NSError *error = nil;
    NSURLResponse *response;

    
//    NSURLConnection *connect = [[NSURLConnection alloc]initWithRequest:theRequest delegate:self];
    
    NSData *urlData=[NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error];
    NSString *data=[[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
    NSLog(@"RES=%@",data);
    
    SBJsonParser* parser = [[[SBJsonParser alloc] init] autorelease];
    // assuming jsonString is your JSON string...
    NSDictionary* myDict = [parser objectWithString:data];
    
    NSString *page_id = [myDict objectForKey:@"id"];
    return page_id;
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
    convertToStringData = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
    [self.delegate communicationManagerDidFinish:convertToStringData];
}


@end
