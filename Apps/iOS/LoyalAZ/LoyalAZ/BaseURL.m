//
//  BaseURL.m
//  LoyalAZ
//

#import "BaseURL.h"

@implementation BaseURL
@synthesize delegate = _delegate;

-(void)GetBaseURL
{
    
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSString *urlString;
    
    NSMutableString *SOAPEnvelopeString = [[NSMutableString alloc]init];
    [SOAPEnvelopeString appendString:@"<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?><SOAP-ENV:Envelope SOAP-ENV:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\">\n"];
    [SOAPEnvelopeString appendString:@"<SOAP-ENV:Body>\n"];
    [SOAPEnvelopeString appendString:@"<get_baseurl> \n"];
    [SOAPEnvelopeString appendString:@"<d>1</d> \n"]; // 0 = PRODUCTION;; 1 = TESTING; 2 = DEMO
    [SOAPEnvelopeString appendString:@"</get_baseurl> </SOAP-ENV:Body></SOAP-ENV:Envelope>\n"];

    //NSLog(@"%@",SOAPEnvelopeString);
    Application *appObj = [Application applicationManager];
    urlString = appObj.SOAPURL;
    //NSLog(@"RAW_URL_HIT=%@",urlString);
    NSURL *locationOfWebService = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *theRequest = [[[NSMutableURLRequest alloc]initWithURL:locationOfWebService]autorelease];
    
    NSString *msgLength = [NSString stringWithFormat:@"%d",[SOAPEnvelopeString length]];
    
    
    [theRequest addValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue:@"http://schemas.microsoft.com/sharepoint/soap/GetListCollection" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    //the below encoding is used to send data over the net
    [theRequest setHTTPBody:[SOAPEnvelopeString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLResponse *response;
    NSError *err;
    NSData* result = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&err];
    NSString *ResponseXML = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
//    NSLog(@"RAW=%@",ResponseXML);
    NSString* returnedXML = [XMLParser GetNodeValue:ResponseXML nodePath:@"//return"];
    NSData *data = [NSStringUtil base64DataFromString:returnedXML];
    NSString *plainURL = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"PLAIN_URL==%@",plainURL);
    appObj.SOAPURL = plainURL;
    appObj.BaseURLSet = YES;
//    if (connect) {
//        webData = [[NSMutableData alloc]init];
//    }
//    else {
//        NSLog(@"No Connection established");
//    }
    //[webData release];
    
}

@end
