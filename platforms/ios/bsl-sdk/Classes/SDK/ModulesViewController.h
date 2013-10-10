//
//  ModulesViewController.h
//  bsl-sdk
//
//  Created by Justin Yip on 10/10/13.
//
//

#import <UIKit/UIKit.h>

@interface ModulesViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
