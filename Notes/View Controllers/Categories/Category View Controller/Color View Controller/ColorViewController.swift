//
//  ColorViewController.swift
//  Notes
//
//  Created by PinguMac on 2018/4/10.
//  Copyright © 2018年 PinguMac. All rights reserved.
//

import UIKit

protocol ColorViewControllerDelegate {
  func controller(_ controller: ColorViewController, didPick color: UIColor)
}

class ColorViewController: UIViewController {
  
  // MARK: - Properties
  @IBOutlet weak var colorView: UIView!
  
  @IBOutlet weak var redSlider: UISlider!
  @IBOutlet weak var blueSlider: UISlider!
  @IBOutlet weak var greenSlider: UISlider!
  
  // MARK: -
  var delegate: ColorViewControllerDelegate?
  
  // MARK: -
  var color: UIColor = .white
  
  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Choose Color"
    
    setupView()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    // Notify Delegate
    delegate?.controller(self, didPick: (colorView.backgroundColor ?? .white))
  }
  
  // MARK: - View Methods
  private func setupView() {
    setupSliders()
    setupColorView()
  }
  
  // MARK: -
  private func setupSliders() {
    // Helpers
    var r: CGFloat = 0.0
    var g: CGFloat = 0.0
    var b: CGFloat = 0.0
    var a: CGFloat = 0.0
    
    // Extract Components
    color.getRed(&r, green: &g, blue: &b, alpha: &a)
    
    // Configure Sliders
    redSlider.value = Float(r)
    blueSlider.value = Float(g)
    greenSlider.value = Float(b)
  }
  
  private func setupColorView() {
    updateColorView()
  }
  
  private func updateColorView() {
    // Create Color
    let color = UIColor(red: CGFloat(redSlider.value), green: CGFloat(greenSlider.value), blue: CGFloat(blueSlider.value), alpha: 1.0)
    
    // Configure Color View
    colorView.backgroundColor = color
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Actions
  @IBAction func colorDidChange(_ sender: UISlider) {
    // Update View
    updateColorView()
  }
}
