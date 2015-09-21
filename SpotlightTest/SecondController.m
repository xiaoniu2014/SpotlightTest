//
//  SecondController.m
//  SpotlightTest
//
//  Created by hw on 15/9/21.
//  Copyright © 2015年 hongw. All rights reserved.
//

#import "SecondController.h"
#import "DetailController.h"
#import <CoreSpotlight/CoreSpotlight.h>

@interface SecondController ()

@property (nonatomic,strong) NSArray *tableData;

@end

@implementation SecondController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableData = @[@"qiuyue",@"jiaoshou",@"xiaowu"];
    [self saveSearchData];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    cell.textLabel.text = self.tableData[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *storeboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailController *vc = [storeboard instantiateViewControllerWithIdentifier:@"DetailController"];
    vc.imageName = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    vc.title = self.tableData[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}



- (void)saveSearchData{
    NSMutableArray *searchbleItem = [NSMutableArray new];
    
    [self.tableData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CSSearchableItemAttributeSet *attributeSet = [[CSSearchableItemAttributeSet alloc] initWithItemContentType:@"default"];
        attributeSet.title = obj;
        attributeSet.contentDescription = [NSString stringWithFormat:NSLocalizedString(@"a easy way to open %@", nil),obj];
        UIImage *thumbImage = [UIImage imageNamed:[NSString stringWithFormat:@"%lu",(unsigned long)idx]];
        attributeSet.thumbnailData = UIImagePNGRepresentation(thumbImage);
        CSSearchableItem *item = [[CSSearchableItem alloc] initWithUniqueIdentifier:obj domainIdentifier:@"com.kingnet.spotlightTest" attributeSet:attributeSet];
        [searchbleItem addObject:item];
    }];
    
    [[CSSearchableIndex defaultSearchableIndex] indexSearchableItems:searchbleItem completionHandler:^(NSError * _Nullable error) {
        NSLog(@"===%@",error.localizedDescription);
    }];
    
    CSSearchableIndex *index = [CSSearchableIndex defaultSearchableIndex];
    
//    删除所有
    [index deleteAllSearchableItemsWithCompletionHandler:^(NSError * _Nullable error) {
        NSLog(@"===%@",error.description);
    }];
    
//    删除单个
    [index deleteSearchableItemsWithIdentifiers:@[@"qiuyue"] completionHandler:^(NSError * _Nullable error) {
        NSLog(@"++%@",error.description);
    }];
    
//    删除所有DomainIdentifiers的
    [index deleteSearchableItemsWithDomainIdentifiers:@[@"com.kingnet.spotlightTest"] completionHandler:^(NSError * _Nullable error) {
        NSLog(@"__%@",error.description);
    }];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
