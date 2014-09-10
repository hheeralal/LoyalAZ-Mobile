//
//  PasscodeVC.m
//  LoyalAZ
//

#import "PasscodeVC.h"

@interface PasscodeVC ()

@end

@implementation PasscodeVC
@synthesize delegate = _delegate;
@synthesize textPass;
@synthesize program;
@synthesize image1,image2,image3,image4;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)textFieldDidChange :(NSNotification *)notif
{
    int newLength = [textPass.text length];
    NSLog(@"LEN = %d",newLength);
        switch (newLength) {
            case 0:
                [image1 setImage:[UIImage imageNamed:@"filled.png"]];
                [image2 setImage:[UIImage imageNamed:@"filled.png"]];
                [image3 setImage:[UIImage imageNamed:@"filled.png"]];
                [image4 setImage:[UIImage imageNamed:@"filled.png"]];
                break;

            case 1:
                [image1 setImage:[UIImage imageNamed:@"empty.png"]];
                [image2 setImage:[UIImage imageNamed:@"filled.png"]];
                [image3 setImage:[UIImage imageNamed:@"filled.png"]];
                [image4 setImage:[UIImage imageNamed:@"filled.png"]];
                break;
            case 2:
                [image1 setImage:[UIImage imageNamed:@"empty.png"]];
                [image2 setImage:[UIImage imageNamed:@"empty.png"]];
                [image3 setImage:[UIImage imageNamed:@"filled.png"]];
                [image4 setImage:[UIImage imageNamed:@"filled.png"]];
                break;
            case 3:
                [image1 setImage:[UIImage imageNamed:@"empty.png"]];
                [image2 setImage:[UIImage imageNamed:@"empty.png"]];
                [image3 setImage:[UIImage imageNamed:@"empty.png"]];
                [image4 setImage:[UIImage imageNamed:@"filled.png"]];
                break;
            case 4:
                [image1 setImage:[UIImage imageNamed:@"empty.png"]];
                [image2 setImage:[UIImage imageNamed:@"empty.png"]];
                [image3 setImage:[UIImage imageNamed:@"empty.png"]];
                [image4 setImage:[UIImage imageNamed:@"empty.png"]];
                [NSTimer scheduledTimerWithTimeInterval:0.5
                                                 target:self
                                               selector:@selector(ValidatePasscode)
                                               userInfo:nil
                                                repeats:NO];
//                [self ValidatePasscode];
                break;
            default:
                break;
        }
}

-(void)ValidatePasscode
{

    bool flagValid = NO;
    NSLog(@"VALID PINS=%@",pins);
    NSArray *codes = [pins componentsSeparatedByString:@","];
    for(int i=0;i<codes.count;i++)
    {
        if([[codes objectAtIndex:i]isEqualToString:textPass.text])
        {
            flagValid = YES;
            break;
        }
    }
    if(flagValid)
    {
        [textPass resignFirstResponder];
        UIAlertView *avFailed = [[UIAlertView alloc]initWithTitle:@"LoyalAZ" message:@"PIN Code Successfully Authenticated." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
        [avFailed show];
        [avFailed release];
        
    }
    else
    {
        UIAlertView *avFailed = [[UIAlertView alloc]initWithTitle:@"LoyalAZ" message:@"Incorrect PIN code." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
        [avFailed show];
        [avFailed release];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withProgram:(Program *)prg
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    self.program = prg;
    
    BusinessLayer *businessLayer = [[BusinessLayer alloc]init];
    pins = [[NSMutableString alloc]init];
    [pins appendString:[businessLayer GetProgramPins:prg]];
    [pins appendString:@","];
    [pins appendString:prg.pins];
    

    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    count=0;
    [textPass becomeFirstResponder];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:@"UITextFieldTextDidChangeNotification" object:textPass];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)confirmPasscode:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.delegate PasscodeVerified:self.program];

}

- (IBAction)cancelPasscode:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.delegate PasscodeDidCancelled];
}

#pragma mark - AlertView Delegates

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.delegate PasscodeVerified:self.program];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 4) ? NO : YES;
}


@end
