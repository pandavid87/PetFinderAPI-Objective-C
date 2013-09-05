//
//  DPViewController.m
//  Pet Finder
//
//  Created by David Pan on 8/23/13.
//  Copyright (c) 2013 David Pan. All rights reserved.
//

#import "PetFinderExampleViewController.h"
#import "PetFinder.h"

@interface PetFinderExampleViewController ()

@property PetFinder * petFinder;
@end

@implementation PetFinderExampleViewController


-(IBAction)test:(id)sender{
    _petFinder = [[PetFinder alloc] initWithApiKey:@"ba963900373951971ad3e690062149d1" secret:@"eaefb47d85c4270ec321dc6c44dd6e07" defaultFormat:kPetFinderFormatJSON defaultOutput:kPetFinderOutputFull];
    [_petFinder breedList:PetFinderAnimalTypeDog completionBlock:^(id response, NSError *error) {
        if(!error){
            NSLog(@"%@", [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:nil]);
        }
        else{
            NSLog(@"%@", error);
        }
    }];
}
@end
