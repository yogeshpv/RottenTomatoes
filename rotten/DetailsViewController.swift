//
//  DetailsViewController.swift
//  rotten
//
//  Created by Yogesh Patikkal Veettil on 9/17/14.
//  Copyright (c) 2014 Yogesh Patikkal Veettil. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var posterImage: UIImageView!

    
    var posterUrl = ""
    var movieName = ""
    var descriptionText = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        movieTitle.text = movieName
        synopsisLabel.text = descriptionText
        posterImage.setImageWithURL(NSURL(string: posterUrl))

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
