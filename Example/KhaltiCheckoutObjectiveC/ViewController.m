//
//  ViewController.m
//  KhaltiCheckoutOjbectiveC
//
//  Created by Mac on 7/4/24.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

#import "ViewController.h"
#import <KhaltiCheckout/KhaltiCheckout-Swift.h>

@interface ViewController ()

@property (nonatomic, strong) Khalti *khalti;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupKhalti];
}

- (void)setupKhalti {
    // Khalti Configuration
    KhaltiPayConfig *config = [[KhaltiPayConfig alloc] initWithPublicKey:@"4aa1b684f4de4860968552558fc8487d"
                                                                    pIdx:@"tehsEsSbeEeLD5ECPrWDk2"
                                                             environment:EnvironmentTEST];
    
    __weak typeof(self) weakSelf = self;
    
    // Initialize Khalti
    self.khalti = [[Khalti alloc] initWithConfig:config
                                 onPaymentResult:^(KhaltiPaymentResult *paymentResult, Khalti *khalti) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        NSLog(@"Demo | onPaymentResult: %@", paymentResult);
        [khalti close];
        
        [strongSelf showSuccessAlertWithTitle:@"Success" message:paymentResult.message ?: @"Success"];
        
    } onMessage:^(KhaltiMessageResult *onMessageResult, Khalti *khalti) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        // Handle onMessage callback here
        // if needsPaymentConfiramtion true then verify payment status
        [strongSelf showSuccessAlertWithTitle:@"" message:onMessageResult.message];
        
        BOOL shouldVerify = onMessageResult.needsPaymentConfirmation;
        
        if (shouldVerify) {
            [khalti verify];
        } else {
            [khalti close];
        }
        
    } onReturn:^(Khalti *khalti) {
        // Called when payment is success
    }];
}

- (void)showSuccessAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
