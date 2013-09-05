//
//  DPPetFinderAPI.m
//  Pet Finder
//
//  Created by David Pan on 8/23/13.
//  Copyright (c) 2013 David Pan. All rights reserved.
//

#import "PetFinder.h"
#import "AFNetworking.h"
#import <CommonCrypto/CommonDigest.h>


#define kPetFinderAPIKey @"ba963900373951971ad3e690062149d1"
#define kPetFinderSecret @"eaefb47d85c4270ec321dc6c44dd6e07"
#define kPetFinderBaseUrl @"http://api.petfinder.com/"

#define kPetFinderApiFind @"pet.find"
#define kPetfinderApiBreedList @"breed.list"
#define kPetFinderApiPetGet @"pet.get"
#define kPetFinderApiPetGetRandom @"pet.getRandom"
#define kPetfinderApiShelterFind @"shelter.find"
#define kPetfinderApiShelterGet @"shelter.get"


NSString * const kPetFinderFormatXML = @"xml";
NSString * const kPetFinderFormatJSON = @"json";

NSString * const kPetFinderOutputId = @"id";
NSString * const kPetFinderOutputBasic = @"basic";
NSString * const kPetFinderOutputFull = @"full";


static PetFinder * _sharedInstance;

@interface PetFinderApiClient : AFHTTPClient


@end


@implementation PetFinderApiClient

-(id)init{
    self = (PetFinderApiClient*)[AFHTTPClient clientWithBaseURL:[NSURL URLWithString:kPetFinderBaseUrl]];
    return self;
}

@end

@interface PetFinder ()

@property PetFinderApiClient * petFinderApiClient;


@property NSString * petFinderApiSecret;
@property NSString * petFinderApiKey;

@end

@implementation PetFinder

+(PetFinder *)sharedInstance{
    if(!_sharedInstance){
        _sharedInstance = [[PetFinder alloc] init];
    }
    
    return _sharedInstance;
}

+(PetFinder *)initializePetFinderWithApiKey:(NSString *)key secret:(NSString *)secret{
    _sharedInstance = [[PetFinder alloc] initWithApiKey:key secret:secret];
    return _sharedInstance;
}

+(PetFinder *)initializePetFinderWithApiKey:(NSString *)key secret:(NSString *)secret defaultFormat:(NSString *)defaultFormat defaultOutput:(NSString *)defaultOutput{
    _sharedInstance = [[PetFinder alloc] initWithApiKey:key secret:secret defaultFormat:defaultFormat defaultOutput:defaultOutput];
    return _sharedInstance;
}

#pragma mark - init methods
-(id)init{
    return [self initWithApiKey:nil secret:nil];
}

-(id)initWithApiKey:(NSString *)apiKey secret:(NSString *)secret{
    return [self initWithApiKey:apiKey secret:secret defaultFormat:kPetFinderFormatXML defaultOutput:kPetFinderOutputId];
}


-(id)initWithApiKey:(NSString *)apiKey secret:(NSString *)secret defaultFormat:(NSString *)defaultFormat defaultOutput:(NSString *)defaultOutput{
    self = [super init];
    
    if(self){
        _petFinderApiKey = apiKey;
        _petFinderApiSecret = secret;
        _defaultFormat = defaultFormat;
        _defaultOutput = defaultOutput;
        _petFinderApiClient = [[PetFinderApiClient alloc] init];
        
    }
    
    return self;
}


#pragma mark - api calls
-(void)breedList:(PetFinderAnimalType)animalType completionBlock:(void (^)(id, NSError *))completionBlock{
    [self breedList:animalType optionalParams:nil completionBlock:completionBlock];
}

-(void)breedList:(PetFinderAnimalType)animalType optionalParams:(NSDictionary *)optionalParams completionBlock:(void (^)(id, NSError *))completionBlock{
    
    NSMutableDictionary * completeParams = [self setupCommonParams:optionalParams hasOutputFormat:NO];
    [completeParams setValue:[self getStringForAnimalType:animalType] forKey:@"animal"];
    [self sendRequestForPath:kPetfinderApiBreedList params:completeParams completionBlock:completionBlock];
}


-(void)petGet:(NSInteger)petId completionBlock:(void (^)(id, NSError *))completionBlock{
    [self petGet:petId optionalParams:nil completionBlock:completionBlock];
}

-(void)petGet:(NSInteger)petId optionalParams:(NSDictionary *)optionalParams completionBlock:(void (^)(id, NSError *))completionBlock{
    NSMutableDictionary * completeParams = [self setupCommonParams:optionalParams hasOutputFormat:NO];

    [completeParams setValue:@(petId) forKey:@"id"];
    
    [self sendRequestForPath:kPetFinderApiPetGet params:completeParams completionBlock:completionBlock];
}



-(void)petFind:(NSString *)location completionBlock:(void (^)(id, NSError *))completionBlock{
    [self petFind:location optionalParams:nil completionBlock:completionBlock];
}

-(void)petFind:(NSString *)location optionalParams:(NSDictionary *)optionalParams completionBlock:(void (^)(id, NSError *))completionBlock{
    
    NSMutableDictionary * completeParams = [self setupCommonParams:optionalParams hasOutputFormat:YES];
    [completeParams setValue:location forKey:@"location"];
    [self sendRequestForPath:kPetFinderApiFind params:completeParams completionBlock:completionBlock];
}

-(void)petGetRandom:(void (^)(id, NSError *))completionBlock{
    [self petGetRandom:nil completionBlock:completionBlock];
}

-(void)petGetRandom:(NSDictionary *)optionalParams completionBlock:(void (^)(id, NSError *))completionBlock{
    NSMutableDictionary * completeParams = [self setupCommonParams:optionalParams hasOutputFormat:YES];
    [self sendRequestForPath:kPetFinderApiPetGetRandom params:completeParams completionBlock:completionBlock];
}

-(void)shelterFindByLocation:(NSString *)location completionBlock:(void (^)(id, NSError *))completionBlock{
    [self shelterFindByLocation:location optionalParams:nil completionBlock:completionBlock];
}

-(void)shelterFindByLocation:(NSString *)location optionalParams:(NSDictionary *)optionalParams completionBlock:(void (^)(id, NSError *))completionBlock{
    NSMutableDictionary * completeParams = [self setupCommonParams:optionalParams hasOutputFormat:NO];
    [completeParams setValue:location forKey:@"location"];
    [self sendRequestForPath:kPetFinderApiPetGetRandom params:completeParams completionBlock:completionBlock];
}

-(void)shelterFindByName:(NSString *)shelterName completionBlock:(void (^)(id, NSError *))completionBlock{
    [self shelterFindByName:shelterName optionalParams:nil completionBlock:completionBlock];
}

-(void)shelterFindByName:(NSString *)shelterName optionalParams:(NSDictionary *)optionalParams completionBlock:(void (^)(id, NSError *))completionBlock{
    NSMutableDictionary * completeParams = [self setupCommonParams:optionalParams hasOutputFormat:NO];
    [completeParams setValue:shelterName forKey:@"name"];
    [self sendRequestForPath:kPetFinderApiPetGetRandom params:completeParams completionBlock:completionBlock];
}

#pragma mark - Helper Methods

-(NSMutableDictionary*)setupCommonParams:(NSDictionary*)params hasOutputFormat:(BOOL)hasOutputFormat{
    
    NSMutableDictionary * commonParams = params ? [NSMutableDictionary dictionaryWithDictionary: params] : [NSMutableDictionary dictionary];
    [self addDefaultValues:commonParams hasOutputFormat:hasOutputFormat];
    
    return commonParams;
}

-(void)sendRequestForPath:(NSString*)path params:(NSDictionary*)params completionBlock:(void(^)(id, NSError*))completionBlock{
    [_petFinderApiClient getPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if(completionBlock)
            completionBlock(responseObject, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(completionBlock)
            completionBlock(nil, error);
    }];
}

-(void)addDefaultValues:(NSMutableDictionary*)params hasOutputFormat:(BOOL)hasOutputFormat{
    
    //api key is necessary for all api calls
    if(!_petFinderApiKey){
        [NSException raise:@"Invalid API Key" format:@"Pet Finder API Key must be set!"];
    }
    
    [params setValue:kPetFinderAPIKey forKey:@"key"];
    
    //only set the default value if it hasnt been set yet and a default value has been provided
    if(![params valueForKey:@"format"] && _defaultFormat){
        [params setValue:_defaultFormat forKey:@"format"];
    }
    
    if(![params valueForKey:@"output"] && _defaultOutput && hasOutputFormat){
        [params setValue:_defaultOutput forKey:@"output"];
    }
}

-(NSString *)getStringForAnimalType:(PetFinderAnimalType)type{
    NSString * typeAsString;
    
    switch(type){
        case PetFinderAnimalTypeBarnyard:
            typeAsString = @"barnyard";
            break;
        case PetFinderAnimalTypeBird:
            typeAsString = @"bird";
            break;
        case PetFinderAnimalTypeCat:
            typeAsString = @"cat";
            break;
        case PetFinderAnimalTypeDog:
            typeAsString = @"dog";
            break;
        case PetFinderAnimalTypeHorse:
            typeAsString = @"horse";
            break;
        case PetFinderAnimalTypePig:
            typeAsString = @"pig";
            break;
        case PetFinderAnimalTypeInvalid:
        default:
            break;
            
        
    }
    
    return typeAsString;
}

@end












