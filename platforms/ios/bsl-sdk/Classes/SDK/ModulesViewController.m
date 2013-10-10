//
//  ModulesViewController.m
//  bsl-sdk
//
//  Created by Justin Yip on 10/10/13.
//
//

#import "ModulesViewController.h"
#import "BSLApplication.h"

@interface ModulesViewController ()

@end

@implementation ModulesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"BSL Module List";
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[BSLApplication sharedApplication].modules count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    BSLModule *m =[[BSLApplication sharedApplication].modules objectAtIndex:indexPath.row];
    cell.textLabel.text = m.name;
    cell.detailTextLabel.text = m.identifier;
    
    return cell;
}

#pragma mark TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BSLModule *m =[[BSLApplication sharedApplication].modules objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:m.viewController animated:YES];
}

@end
