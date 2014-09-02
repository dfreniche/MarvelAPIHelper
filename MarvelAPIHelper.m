//
//  MarveAPIHelper.m
//  MarvelAPIDemo
//
//  Created by Diego Freniche Brito on 02/07/14.
//  Copyright (c) 2014 Diego Freniche Brito. All rights reserved.
//

#import "MarvelAPIHelper.h"
#import "NSString+MD5.h"
#import "AFNetworking/AFNetworking.h"

static const NSString *MARVEL_BASE_URL = @"http://gateway.marvel.com/v1/public/";

@interface MarvelAPIHelper ()

@property (nonatomic, copy, readonly) NSString *timeStamp;
@property (nonatomic) NSUInteger timeStampCounter;

@end


@implementation MarvelAPIHelper


- (instancetype)initWithPublicKey:(NSString *)publicKey andSecretKey:(NSString *)secretKey {
    self = [super init];
    if (self) {
        _publicKey = publicKey;
        _secretKey = secretKey;
    }
    return self;
}

- (NSString *)timeStamp {
    self.timeStampCounter++;
    return [NSString stringWithFormat:@"%lu", (unsigned long)self.timeStampCounter];
}

// need to add this authorization string to every petition

- (NSString *)authorizationStringWithPublicKey:(NSString *)publicKey andSecretKey:(NSString *)secretKey andTimeStamp:(NSString *)ts {
    
    NSString *preHash = [NSString stringWithFormat:@"%@%@%@", ts, secretKey, publicKey];
    
    return [preHash MD5];
}

- (void)JSONDataForSuperheroNamed:(NSString *)name completion:(void (^)(NSDictionary *resultData))completionBlock {
    NSString *ts = self.timeStamp;  // generate timeStamp
    
    NSString *authString = [self authorizationStringWithPublicKey:self.publicKey andSecretKey:self.secretKey andTimeStamp:ts];
    NSString *getStringWithoutEncoding = [NSString stringWithFormat:@"%@%@?name=%@&ts=%@&apikey=%@&hash=%@", MARVEL_BASE_URL, @"characters", name, ts, self.publicKey, authString];
    
    NSString *get = [getStringWithoutEncoding stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:get parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSUInteger returnCode = [[responseObject objectForKey:@"code"] integerValue];
        if (returnCode != 200) {
            completionBlock(nil);
            return;
        }
        
        NSUInteger count = [[responseObject valueForKeyPath:@"data.count"] integerValue];
        if (count == 0) {
            completionBlock(nil);
            return;
        }
        
        completionBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)JSONDataForSuperheros:(void (^)(NSDictionary *resultData))completionBlock {
    NSString *ts = self.timeStamp;
    
    NSString *authString = [self authorizationStringWithPublicKey:self.publicKey andSecretKey:self.secretKey andTimeStamp:ts];
    NSString *getStringWithoutEncoding = [NSString stringWithFormat:@"%@%@?ts=%@&apikey=%@&hash=%@", MARVEL_BASE_URL, @"characters", ts, self.publicKey, authString];
    
    NSString *get = [getStringWithoutEncoding stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:get parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSUInteger returnCode = [[responseObject objectForKey:@"code"] integerValue];
        if (returnCode != 200) {
            completionBlock(nil);
            return;
        }
        
        NSUInteger count = [[responseObject valueForKeyPath:@"data.count"] integerValue];
        if (count == 0) {
            completionBlock(nil);
            return;
        }
        
        completionBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}


@end
