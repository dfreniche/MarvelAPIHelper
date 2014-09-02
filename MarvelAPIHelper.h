//
//  MarveAPIHelper.h
//  MarvelAPIDemo
//
//  Created by Diego Freniche Brito on 02/07/14.
//  Copyright (c) 2014 Diego Freniche Brito. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MarvelAPIHelper : NSObject

@property (nonatomic, copy) NSString *publicKey;
@property (nonatomic, copy) NSString *secretKey;

// Designated initializer

- (instancetype)initWithPublicKey:(NSString *)publicKey andSecretKey:(NSString *)secretKey;

// call completionBlock with a hero's data. Nil if hero not found
- (void)JSONDataForSuperheroNamed:(NSString *)name completion:(void (^)(NSDictionary *resultData))completionBlock;
- (void)JSONDataForSuperheros:(void (^)(NSDictionary *resultData))completionBlock;


@end
