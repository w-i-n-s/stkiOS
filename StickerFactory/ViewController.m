//
//  ViewController.m
//  StickerFactory
//
//  Created by Vadim Degterev on 25.06.15.
//  Copyright (c) 2015 908. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+Stickers.h"
#import "STKStickersManager.h"
#import "NSManagedObjectContext+Additions.h"
#import "STKCoreDataService.h"
#import "NSPersistentStoreCoordinator+Additions.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *categoryStickerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *methodImageView;
@property (strong, nonatomic) STKStickersManager *stickerManager;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.stickerManager = [STKStickersManager new];
    
    [STKCoreDataService setupCoreData];
}

- (void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    NSManagedObjectContext *context = [NSManagedObjectContext stk_defaultContext];
    
    NSPersistentStoreCoordinator *coordinator = [NSPersistentStoreCoordinator stk_defaultPersistentsStoreCoordinator];
    
    NSString *testString = @"[[pinkgorilla_bigSmile]]";
    
    //Есть возможность отображать стикер с помощью категрии, но необходимо сначала проверить стикер ли это
    if ([STKStickersManager isStickerMessage:testString]) {
        [self.categoryStickerImageView stk_setStickerWithMessage:testString completion:^(NSError *error, UIImage *stickerImage) {
            
        }];
    } else {
        NSLog(@"Sticker not found");
    }
    
    //Можно загрузить методом напрямую(Если это не стикер, вызовется failure блок)
    __weak typeof(self) weakSelf = self;
    [self.stickerManager getStickerForMessage:testString progress:nil success:^(UIImage *sticker) {
        
        weakSelf.methodImageView.image = sticker;
        
    } failure:^(NSError *error, NSString *errorMessage) {
        NSLog(@"Error : %@", error.localizedDescription);
    }];
    
    
}


@end
