//
//  OADataFetcher.m
//  OAuthConsumer
//
//  Created by Jon Crosby on 11/5/07.
//  Copyright 2007 Kaboomerang LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.


#import "OADataFetcher.h"


@implementation OADataFetcher

@synthesize response, request, resultBuffer;

- (void)fetchDataWithRequest:(OAMutableURLRequest *)aRequest 
					delegate:(id)aDelegate 
		   didFinishSelector:(SEL)finishSelector 
			 didFailSelector:(SEL)failSelector 
{
    self.request = aRequest;
    delegate = aDelegate;
    didFinishSelector = finishSelector;
    didFailSelector = failSelector;
    
    [request prepare];
    
    self.resultBuffer = [NSMutableData new];
    connection =
    [NSURLConnection connectionWithRequest:request delegate:self];
    
//    responseData = [NSURLConnection sendSynchronousRequest:request
//                                         returningResponse:&response
//                                                     error:&error];
	
//    if (response == nil || responseData == nil || error != nil) {
//        OAServiceTicket *ticket= [[OAServiceTicket alloc] initWithRequest:request
//                                                                 response:response
//                                                               didSucceed:NO];
//        [delegate performSelector:didFailSelector
//                       withObject:ticket
//                       withObject:error];
//    } else {
//        OAServiceTicket *ticket = [[OAServiceTicket alloc] initWithRequest:request
//                                                                  response:response
//                                                                didSucceed:[(NSHTTPURLResponse *)response statusCode] < 400];
//        [delegate performSelector:didFinishSelector
//                       withObject:ticket
//                       withObject:responseData];
//    }   
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[self.resultBuffer appendData:data];
} 

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)_response {
    self.response = _response;
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
//    NSLog(@"response %@", self.response);
	OAServiceTicket *ticket = [[OAServiceTicket alloc] initWithRequest:request
                                                              response:self.response
                                                            didSucceed:[(NSHTTPURLResponse *)self.response statusCode] < 400];
    [delegate performSelector:didFinishSelector
                   withObject:ticket
                   withObject:self.resultBuffer];

}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)_error {
	OAServiceTicket *ticket= [[OAServiceTicket alloc] initWithRequest:request
                                                             response:response
                                                           didSucceed:NO];
    [delegate performSelector:didFailSelector
                   withObject:ticket
                   withObject:_error];

}

- (void)dealloc {
    [resultBuffer release];
    self.response = nil;
    self.request = nil;
    self.resultBuffer = nil;
    [super dealloc];
}


@end
