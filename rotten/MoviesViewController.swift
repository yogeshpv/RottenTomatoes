//
//  MoviesViewController.swift
//  rotten
//
//  Created by Yogesh Patikkal Veettil on 9/15/14.
//  Copyright (c) 2014 Yogesh Patikkal Veettil. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MBProgressHUDDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var movies: [NSDictionary] = []
    var refreshControl: UIRefreshControl!
    var url = "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=kg9pgy63929bana8x5e7z2ee&limit=20&country=us"
    var mbhud = MBProgressHUD()
    var mbhuderror = MBProgressHUD()
    var isProgress = false
    var isError  = UILabel()

    
    func refresh(){
        loadTableData()
        self.refreshControl.endRefreshing()
    }
    
    func loadTableData() {
        if(isProgress == false) {
            mbhud.labelText = "Loading Movie List"
            mbhud.delegate = self
            self.mbhud.show(true)
            isError.text = "Error Retrieving !"
            self.view.addSubview(self.mbhud)
            self.view.bringSubviewToFront(self.mbhud)
            isProgress = true
            self.mbhud.hidden = false
        }
        
        var request = NSURLRequest(URL: NSURL(string: url))

        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            self.mbhud.hidden = true

            if (data != nil) {
                var object = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
                self.movies = object["movies"] as [NSDictionary]
                self.tableView.reloadData()
            } else {
                self.mbhud.hidden = true
                YRDropdownView.showDropdownInView(
                    self.navigationController?.view,
                    title: "Error Retrieving!",
                    detail: "Please try again later",
                    image: nil,
                    animated: true,
                    hideAfter: 2)
            }
        
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refersh")
        self.refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.insertSubview(self.refreshControl, atIndex: 0)
        loadTableData()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("MovieCell") as MovieCell
        
        var movie = movies[indexPath.row]
        cell.movieTitleLabel.text = movie["title"] as? String
        cell.synopsisLabel.text = movie["synopsis"] as? String
        
        var posters = movie["posters"] as NSDictionary
        var posterURL = posters["thumbnail"] as String
        
        cell.posterView.setImageWithURL(NSURL(string: posterURL))
        
        return cell
    }
    


    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        let indexPath = tableView.indexPathForSelectedRow()
        var movie = movies[indexPath!.row]
        var posters = movie["posters"] as NSDictionary
        var textdesc = movie["synopsis"] as? String
        var posterUrl = posters["original"] as String
        var movieName = movie["title"] as? String
        
        let vc = segue.destinationViewController as DetailsViewController
        vc.posterUrl  = posterUrl
        vc.descriptionText = textdesc!
        vc.movieName = movieName!
    }
}
