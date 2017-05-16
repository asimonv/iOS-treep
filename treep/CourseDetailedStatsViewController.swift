//
//  CourseDetailedStatsViewController.swift
//  treep
//
//  Created by Andre Simon on 12/30/16.
//  Copyright © 2016 Andre Simon. All rights reserved.
//

import UIKit

class CourseDetailedStatsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var course: Course!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CourseStatCell", for: indexPath)
        
        
        switch indexPath.section {
        case 0:
            cell.backgroundColor = .blue
        case 1:
            cell.backgroundColor = .red
        case 2:
            cell.backgroundColor = .green
        case 3:
            cell.backgroundColor = .yellow
        case 4:
            cell.backgroundColor = .black
        default:
            cell.backgroundColor = .white
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
       /*
        switch section {
        case 0:
            return Int(course.easy)
        case 1:
            return Int(course.normal)
        case 2:
            return Int(course.hard)
        case 3:
            return Int(course.impossible)
        case 4:
            return Int(course.popularity)
        default:
            return 0
        }
    */
        
        return 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    
    /*func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "StatHeader", for: indexPath) as! StatCollectionReusableView
        
        var stat: Int32!
        var statNames = ["easy", "normal", "hard", "impossible", "popularity"]
        
        switch indexPath.section {
        case 0:
            stat = self.course.easy
        case 1:
            stat = self.course.normal
        case 2:
            stat = self.course.hard
        case 3:
            stat = self.course.impossible
        case 4:
            stat = self.course.popularity
        default:
            stat = nil
        }
        
        let string = "\(stat!) voted that this course is \(statNames[indexPath.section])"
        
        let statAttributedString = NSMutableAttributedString(
            string: string,
            attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 20, weight: UIFontWeightRegular)]
        )
        //Add more attributes here
        
        statAttributedString.addAttributes(
            [NSFontAttributeName:UIFont.systemFont(ofSize: 20, weight: UIFontWeightMedium)],
            range: NSRange(location: 0, length: String(stat).characters.count + 1)
        )
        
        
        //Apply to the label
        reusableView.statLabel.attributedText = statAttributedString
        
        reusableView.statLabel.sizeToFit()
        reusableView.statLabel.translatesAutoresizingMaskIntoConstraints = false

        
        return reusableView

    }
 */
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: self.collectionView.frame.size.width, height: 50)
    }
    
    // MARK: - CollectionView Flow Layout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 15, height: 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
