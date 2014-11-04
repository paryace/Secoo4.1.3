//
//  DataSigner.m
//  AlixPayDemo
//
//  Created by Jing Wen on 8/2/11.
//  Copyright 2011 alipay.com. All rights reserved.
//

#import "DataSigner.h"
#import "DataMD5Local.h"

id<DataSigner> CreateRSADataSigner(NSString *privateKey) {
	
	id signer = nil;
	signer = [[DataMD5Local alloc] init];
	return [signer autorelease];
	
}
id<DataSigner> CreateMD5DataSigner()
{
    id signer = nil;
	signer = [[DataMD5Local alloc] init];
	return [signer autorelease];
}