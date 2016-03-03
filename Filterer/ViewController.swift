//
//  ViewController.swift
//  Filterer
//
//  Created by alberto pasca on 09/02/16.
//  Copyright © 2015 Coursera. All rights reserved.
//

import UIKit


enum Filters:Int
{
    case None   = 0
    case Red    = 1
    case Green  = 2
    case Blue   = 3
    case Yellow = 4
    case Purple = 5
    case Orange = 6
    case Nigth  = 7
    case Invert = 8
    case Sepia  = 9
    case Gray   = 10
}


class ViewController: UIViewController,
UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate
{
    //
    // Interface Builder components
    //
    @IBOutlet var imageView          : UIImageView!
    @IBOutlet var imageViewFiltered  : UIImageView!
    @IBOutlet var secondaryMenu      : UICollectionView!
    @IBOutlet var thirdMenu          : UIView!
    @IBOutlet var bottomMenu         : UIView!
    @IBOutlet var infoView           : UIView!
    @IBOutlet var newButton          : UIButton!
    @IBOutlet var shareButton        : UIButton!
    @IBOutlet var filterButton       : UIButton!
    @IBOutlet var editButton         : UIButton!
    @IBOutlet var compareButton      : UIButton!
    @IBOutlet var editSlider         : UISlider!


    var selectedFilter : Filter!

    //
    // List of filters for UICollectionView preview
    //
    var filtersPreview: [Filter] =
    [
        Filter(defaultValue: 0,   filterType: Filters.None),
        Filter(defaultValue: 255, filterType: Filters.Red),
        Filter(defaultValue: 255, filterType: Filters.Green),
        Filter(defaultValue: 255, filterType: Filters.Blue),
        Filter(defaultValue: 255, filterType: Filters.Yellow),
        Filter(defaultValue: 255, filterType: Filters.Purple),
        Filter(defaultValue: 255, filterType: Filters.Orange),
        Filter(defaultValue: 255, filterType: Filters.Nigth),
        Filter(defaultValue: 255, filterType: Filters.Invert),
        Filter(defaultValue: 0,   filterType: Filters.Sepia),
        Filter(defaultValue: 255, filterType: Filters.Gray)
    ]


    // +---------------------------------------------------------------------------+
    //MARK: - View lifecycle
    // +---------------------------------------------------------------------------+


    override func viewDidLoad() {
        super.viewDidLoad()

        self.selectedFilter = Filter(defaultValue: 0, filterType: .None)

        secondaryMenu.delegate = self
        secondaryMenu.dataSource = self
        secondaryMenu.registerNib(UINib(nibName: "FilterCell", bundle: nil), forCellWithReuseIdentifier: "fcell")

        secondaryMenu.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        infoView.backgroundColor      = UIColor.blackColor().colorWithAlphaComponent(0.2)
        thirdMenu.backgroundColor     = UIColor.blackColor().colorWithAlphaComponent(0.5)

        secondaryMenu.translatesAutoresizingMaskIntoConstraints = false
        thirdMenu.translatesAutoresizingMaskIntoConstraints     = false
        infoView.translatesAutoresizingMaskIntoConstraints      = false

        refreshLayout()
    }


    // +---------------------------------------------------------------------------+
    //MARK: - Touch
    // +---------------------------------------------------------------------------+
    //
    // toggle image
    //
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if ( self.selectedFilter.filterType == .None || !newButton.enabled ) { return }
        showInfoView()
        showOriginal()
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if ( self.selectedFilter.filterType == .None || !newButton.enabled ) { return }
        hideInfoView()
        showFiltered()
    }


    // +---------------------------------------------------------------------------+
    //MARK: - Protected
    // +---------------------------------------------------------------------------+


    func showCamera() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .Camera

        presentViewController(cameraPicker, animated: true, completion: nil)
    }

    func showAlbum() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .PhotoLibrary

        presentViewController(cameraPicker, animated: true, completion: nil)
    }

    //
    // toggle Filters VIEW
    //
    func showSecondaryMenu() {
        editButton.selected = false
        hideEditMenu()
        view.addSubview(secondaryMenu)
        secondaryMenu.reloadData()

        let bottomConstraint = secondaryMenu.bottomAnchor.constraintEqualToAnchor(bottomMenu.topAnchor)
        let leftConstraint   = secondaryMenu.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
        let rightConstraint  = secondaryMenu.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
        let heightConstraint = secondaryMenu.heightAnchor.constraintEqualToConstant(50)

        NSLayoutConstraint.activateConstraints([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])

        view.layoutIfNeeded()

        self.secondaryMenu.alpha = 0
        UIView.animateWithDuration(0.4) {
            self.secondaryMenu.alpha = 1.0
        }
    }

    func hideSecondaryMenu() {
        UIView.animateWithDuration(0.4, animations: {
            self.secondaryMenu.alpha = 0
            }) { completed in
                if completed == true {
                    self.secondaryMenu.removeFromSuperview()
                }
        }
    }

    //
    // toggle INFO VIEW ("Original" label)
    //
    func showInfoView() {
        view.addSubview(infoView)

        let xConstraint      = infoView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor)
        let yConstraint      = infoView.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 30)
        let leftConstraint   = infoView.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
        let rightConstraint  = infoView.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
        let heightConstraint = infoView.heightAnchor.constraintEqualToConstant(44)

        NSLayoutConstraint.activateConstraints([xConstraint, yConstraint, leftConstraint, rightConstraint, heightConstraint])

        view.layoutIfNeeded()

        self.infoView.alpha = 0
        UIView.animateWithDuration(0.4) {
            self.infoView.alpha = 1.0
        }
    }

    func hideInfoView() {
        UIView.animateWithDuration(0.4, animations: {
            self.infoView.alpha = 0
            }) { completed in
                if completed == true {
                    self.infoView.removeFromSuperview()
                }
        }
    }

    //
    // toggle Slider VIEW, "intensity"
    //
    func showEditMenu() {
        filterButton.selected = false
        hideSecondaryMenu()
        view.addSubview(thirdMenu)

        let bottomConstraint = thirdMenu.bottomAnchor.constraintEqualToAnchor(bottomMenu.topAnchor)
        let leftConstraint   = thirdMenu.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
        let rightConstraint  = thirdMenu.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
        let heightConstraint = thirdMenu.heightAnchor.constraintEqualToConstant(100)

        NSLayoutConstraint.activateConstraints([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])

        view.layoutIfNeeded()

        self.thirdMenu.alpha = 0
        UIView.animateWithDuration(0.4) {
            self.thirdMenu.alpha = 1.0
        }
    }

    func hideEditMenu() {
        UIView.animateWithDuration(0.4, animations: {
            self.thirdMenu.alpha = 0
            }) { completed in
                if completed == true {
                    self.thirdMenu.removeFromSuperview()
                }
        }
    }


    //
    // toggle Original/Filtered image
    //
    func showOriginal() {
        UIView.animateWithDuration(0.25) { () -> Void in
            self.imageView.alpha         = 1
            self.imageViewFiltered.alpha = 0
        }
    }

    func showFiltered() {
        UIView.animateWithDuration(0.25) { () -> Void in
            self.imageView.alpha         = 0
            self.imageViewFiltered.alpha = 1
        }
    }


    //
    // update layout, buttons
    //
    func refreshLayout() {
        self.compareButton.enabled = self.selectedFilter.filterType != .None
        self.editButton.enabled    = self.selectedFilter.filterType != .None

        if ( self.selectedFilter.filterType != .None ) {
            hideEditMenu()
        }
    }


    // +---------------------------------------------------------------------------+
    //MARK: - Actions
    // +---------------------------------------------------------------------------+


    @IBAction func onShare(sender: AnyObject) {
        let activityController = UIActivityViewController(activityItems: ["InstaSwift __ Check out our really cool app!", imageViewFiltered.image!], applicationActivities: nil)
        presentViewController(activityController, animated: true, completion: nil)
    }
    
    @IBAction func onNewPhoto(sender: AnyObject) {
        let actionSheet = UIAlertController(title: "New Photo", message: nil, preferredStyle: .ActionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .Default, handler: { action in
            self.showCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Album", style: .Default, handler: { action in
            self.showAlbum()
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }

    //
    // Button "Filter" pressed
    //
    @IBAction func onFilter(sender: UIButton) {
        if (sender.selected) {
            hideSecondaryMenu()
            sender.selected = false
        } else {
            showSecondaryMenu()
            sender.selected = true
        }
    }

    //
    // Button "Edit" pressed
    //
    @IBAction func onEdit(sender: UIButton) {
        if (sender.selected) {
            hideEditMenu()
            sender.selected = false
        } else {
            showEditMenu()
            editSlider.setValue(Float(self.selectedFilter.value), animated: true)
            sender.selected = true
        }
    }

    //
    // Button "Compare" pressed
    //
    @IBAction func onCompare(sender: UIButton) {
        if self.selectedFilter.filterType == .None { return }

        if ( compareButton.titleLabel?.text == "Compare" ) {
            showInfoView()
            showOriginal()

            compareButton.setTitle("Back", forState: .Normal)

            newButton.enabled     = false
            shareButton.enabled   = false
            editButton.enabled    = false
            filterButton.enabled  = false
            filterButton.selected = false
            editButton.selected   = false

            hideEditMenu()
            hideSecondaryMenu()

        } else {
            hideInfoView()
            showFiltered()

            compareButton.setTitle("Compare", forState: .Normal)

            newButton.enabled    = true
            shareButton.enabled  = true
            editButton.enabled   = true
            filterButton.enabled = true
        }
    }

    //
    // Slider change value
    //
    @IBAction func onEditChange(sender: UISlider) {
        self.selectedFilter.value = Int(sender.value)
        imageViewFiltered.image = Filter.applyFilter(imageView.image, filter: self.selectedFilter)
        showFiltered()
    }


    // +---------------------------------------------------------------------------+
    //MARK: - Picker delegate
    // +---------------------------------------------------------------------------+


    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        dismissViewControllerAnimated(true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            imageViewFiltered.image = image
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }


    // +---------------------------------------------------------------------------+
    //MARK: - Collectionview delegete/datasource
    // +---------------------------------------------------------------------------+


    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filtersPreview.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("fcell", forIndexPath: indexPath) as! FilterCell

        let filter   = filtersPreview[indexPath.row]
        filter.value = filtersPreview[indexPath.row].value

        cell.imageView.image = Filter.applyFilter(UIImage(named: "sample"), filter: filter)
        showFiltered()

        return cell
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let filter = filtersPreview[indexPath.row]
        self.selectedFilter = filter

        imageViewFiltered.image = Filter.applyFilter(imageView.image, filter: filter)
        showFiltered()
        refreshLayout()
    }



}






