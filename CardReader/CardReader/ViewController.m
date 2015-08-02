//
//  ViewController.m
//  CardReader
//
//  Created by David Hodge on 8/1/15.
//  Copyright (c) 2015 Genesis Apps, LLC. All rights reserved.
//

#import "ViewController.h"
#import "CardIO.h"
#import "CreditCardManager.h"

typedef enum Sections
{
    kSectionCardInfo = 0,
    kSectionScanCard,
    kSections_COUNT
} Sections;

typedef enum CardInfoRows
{
    kCardInfoRowRedactedNumber = 0,
    kCardInfoRowExpirationDate,
    kCardInfoRowSecurityCode,
    kCardInfoRows_COUNT
} CardInfoRows;

typedef enum ScanCardRows
{
    kScanCardRowScan = 0,
    kScanCardRows_COUNT
} ScanCardRows;

@interface ViewController () <CardIOPaymentViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"Card Reader";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [CardIOUtilities preload];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scanCard {
    CardIOPaymentViewController *cpvc = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
    [self presentViewController:cpvc animated:YES completion:nil];
}

#pragma mark - CardIOPaymentViewControllerDelegate

- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)paymentViewController
{
    NSLog(@"User cancelled payment");
    
    [paymentViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)cardInfo inPaymentViewController:(CardIOPaymentViewController *)paymentViewController
{
    CreditCard *card = [[CreditCardManager defaultManager] card];
    
    card.redactedCardNumber = cardInfo.redactedCardNumber;
    card.expirationMonth = cardInfo.expiryMonth;
    card.expirationYear = cardInfo.expiryYear;
    card.cvv = [cardInfo.cvv integerValue];
    
    [paymentViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return kSections_COUNT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case kSectionCardInfo:
        {
            return kCardInfoRows_COUNT;
        }
            break;
            
        case kSectionScanCard:
        {
            return kScanCardRows_COUNT;
        }
            break;
            
        default:
        {
            return 0;
        }
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    CreditCard *card = [[CreditCardManager defaultManager] card];
    
    switch (indexPath.section)
    {
        case kSectionCardInfo:
        {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            switch (indexPath.row)
        {
            case kCardInfoRowRedactedNumber:
            {
                cell.textLabel.text = @"Card Number";
                
                if (card.redactedCardNumber != nil)
                {
                    cell.detailTextLabel.text = card.redactedCardNumber;
                } else
                {
                    cell.detailTextLabel.text = @"";
                }
            }
                break;
                
            case kCardInfoRowExpirationDate:
            {
                cell.textLabel.text = @"Expiration Date";
                
                if (card.expirationMonth && card.expirationYear)
                {
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%02lu/%lu", (unsigned long)card.expirationMonth, (unsigned long)card.expirationYear];
                } else
                {
                    cell.detailTextLabel.text = @"";
                }
            }
                break;
                
            case kCardInfoRowSecurityCode:
            {
                cell.textLabel.text = @"Security Code";
                
                if (card.cvv)
                {
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long) card.cvv];
                } else
                {
                    cell.detailTextLabel.text = @"";
                }
            }
                break;
                
            default:
                break;
            }
        }
            break;
            
        case kSectionScanCard:
        {
            switch (indexPath.row) {
                case kScanCardRowScan:
                {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"scanCell"];
                    
                    cell.textLabel.text = @"Scan my Card";
                    cell.textLabel.textAlignment = NSTextAlignmentCenter;
                    cell.textLabel.textColor = self.view.tintColor;
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }

    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == kSectionScanCard)
    {
        if (indexPath.row == kScanCardRowScan)
        {
            [self scanCard];
        }
    }
}

@end
