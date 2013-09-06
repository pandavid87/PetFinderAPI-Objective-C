//
//  DPPetFinderAPI.h
//  Pet Finder
//
//  Created by David Pan on 8/23/13.
//  Copyright (c) 2013 David Pan. All rights reserved.
//


/**
    Version History
       9/5/13 v.1 - initial commit
 
 

 TODO:
 
    - finish authenticated token request and api calls that require session token
    - testing
    - optional params builder
    - examples
 
 **/


#import <Foundation/Foundation.h>


extern NSString * const kPetFinderFormatXML;
extern NSString * const kPetFinderFormatJSON;

extern NSString * const kPetFinderOutputId;
extern NSString * const kPetFinderOutputBasic;
extern NSString * const kPetFinderOutputFull;

//enum representing the different types of valid animals for Pet Finder API
typedef enum {
    PetFinderAnimalTypeInvalid = -1,
    PetFinderAnimalTypeBarnyard = 0,
    PetFinderAnimalTypeBird,
    PetFinderAnimalTypeCat,
    PetFinderAnimalTypeDog,
    PetFinderAnimalTypeHorse,
    PetFinderAnimalTypePig
    
}PetFinderAnimalType;


@interface PetFinder : NSObject



//shared instance for convenience
+(PetFinder*)sharedInstance;

// initialization call before shared instance can be used
+(PetFinder *)initializePetFinderWithApiKey:(NSString*)key secret:(NSString*)secret;
+(PetFinder *)initializePetFinderWithApiKey:(NSString*)key secret:(NSString*)secret defaultFormat:(NSString*)defaultFormat defaultOutput:(NSString*)defaultOutput;

// default response format to use.  if nil, will use xml
@property NSString * defaultFormat;
@property NSString * defaultOutput;


-(id)initWithApiKey:(NSString*)apiKey secret:(NSString*)secret;
-(id)initWithApiKey:(NSString*)apiKey secret:(NSString*)secret defaultFormat:(NSString*)defaultFormat defaultOutput:(NSString*)defaultOutput;


//TODO:
//-(void)getToken:(void(^)(NSString *, NSError*))completionBlock;

// get list of breeds for animal type
-(void)breedList:(PetFinderAnimalType)animalType completionBlock:(void(^)(id response, NSError * error))completionBlock;
-(void)breedList:(PetFinderAnimalType)animalType optionalParams:(NSDictionary *)optionalParams completionBlock:(void(^)(id response, NSError * error))completionBlock;

// get single pet for given pet id

-(void)petGet:(NSInteger)petId completionBlock:(void(^)(id response, NSError * error))completionBlock;
-(void)petGet:(NSInteger)petId optionalParams:(NSDictionary *)optionalParams completionBlock:(void(^)(id response, NSError * error))completionBlock;

// find all pets by proximity to given location.
// location = the ZIP/postal code or city and state where the search should begin

-(void)petFind:(NSString*)location completionBlock:(void(^)(id response, NSError * error))completionBlock;
-(void)petFind:(NSString*)location optionalParams:(NSDictionary *)optionalParams completionBlock:(void(^)(id response, NSError * error))completionBlock;

//get a random pet
-(void)petGetRandom:(void(^)(id response, NSError * error))completionBlock;
-(void)petGetRandom:(NSDictionary*)optionalParams completionBlock:(void(^)(id response, NSError * error))completionBlock;

// find a shelter by a location
// location = the ZIP/postal code or city and state where the search should begin
-(void)shelterFindByLocation:(NSString*)location completionBlock:(void(^)(id response, NSError * error))completionBlock;
-(void)shelterFindByLocation:(NSString*)location optionalParams:(NSDictionary*)optionalParams completionBlock:(void(^)(id response, NSError * error))completionBlock;

//
-(void)shelterFindByName:(NSString*)shelterName completionBlock:(void(^)(id response, NSError * error))completionBlock;
-(void)shelterFindByName:(NSString*)shelterName optionalParams:(NSDictionary*)optionalParams completionBlock:(void(^)(id response, NSError * error))completionBlock;


//TODO: shelter.get api call requires a session
//-(void)shelterGet:(NSString*)shelterId completionBlock:(void(^)(id response, NSError * error))completionBlock;

//get string representation for a type of animal
//string representation is value that is actually passed to api calls
-(NSString*)getStringForAnimalType:(PetFinderAnimalType)type;



@end
