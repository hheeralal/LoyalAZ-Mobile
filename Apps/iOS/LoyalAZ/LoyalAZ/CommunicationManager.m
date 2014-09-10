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

//    NSString *xmlContents = [Helper GetEmptySchema];
//
//    NSLog(@"XML=%@",xmlContents);
//    NSData *data = [xmlContents dataUsingEncoding:NSUTF8StringEncoding];
//
//    NSString *xml64 = [NSStringUtil base64StringFromData:data length:data.length];

    /* NSString *soapFormat = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\n"
     "<SOAP-ENV:Envelope SOAP-ENV:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\"\n"
     "xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\"\n"
     "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\">\n"
     "<SOAP-ENV:Body>\n"
     "<register_user>\n"
     "<country xsi:type=\"xsd:string\">Philippines</country>\n"
     "<firstname xsi:type=\"xsd:string\">Juan</firstname>\n"
     "<lastname xsi:type=\"xsd:string\">Dela Cruz</lastname>\n"
     "<mobile xsi:type=\"xsd:string\">09108019161</mobile>\n"
     "<street xsi:type=\"xsd:string\">Sample Street</street>\n"
     "<suburb xsi:type=\"xsd:string\">Sample Suburb</suburb>\n"
     "<city xsi:type=\"xsd:string\">Sample City</city>\n"
     "<st xsi:type=\"xsd:string\">FHS7-29OW</st>\n"
     "</register_user>"
     "</SOAP-ENV:Body>"
     "</SOAP-ENV:Envelope>\n"
     ];
     */
//    NSString *soapFormat = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\n"
//                            "<SOAP-ENV:Envelope SOAP-ENV:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\"\n"
//                            "xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\"\n"
//                            "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\">\n"
//                            "<SOAP-ENV:Body>\n"
//                            "<write_xml>\n"
//                            "<xml_base64 xsi:type=\"xsd:string\">%@</xml_base64>\n"
//                            "</write_xml>\n"
//                            "</SOAP-ENV:Body>\n"
//                            "</SOAP-ENV:Envelope>\n",xml64
//                            ];

    //NSLog(@"The request format is %@",SOAPEnvelopeString);
    //http://loyalaz.com/test/p/server.php

    //NSURL *locationOfWebService = [NSURL URLWithString:@"http://loyalaz.com/test/p/server.php"]; //only used for testing.
    
    
    
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
