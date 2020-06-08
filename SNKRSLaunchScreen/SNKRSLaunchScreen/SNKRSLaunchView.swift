//
//  SNKRSLaunchView.swift
//  SNKRSLaunchScreen
//
//  Created by Caleb Rudnicki on 6/7/20.
//  Copyright © 2020 Caleb Rudnicki. All rights reserved.
//

import UIKit

open class SNKRSLaunchView: UIView, SNKRSAnimatable {
    
    // MARK: Properties
    
    public typealias SNKRSAnimatableCompletion = () -> Void
    
    /// The icon of the first image
    open var iconImages: [UIImage]? {
        didSet{
            if let iconImages = self.iconImages {
                for iconImage in iconImages {
                    let imageView = UIImageView()
                    imageView.image = iconImage
                    imageViews?.append(imageView)
                }
            }
        }
    }
    
    /// The image view containing `firstIconImage`
    internal var imageViews: [UIImageView]?
    
    /// The background view containing the `firstImageView`
    internal var imageBackgrounds: [UIView]?
    
    /// The duration of each individual icon's animation. Default to 1.0 second.
    /// If you have three icons, the total animation time is 3.0 seconds (1.0 second for each icon).
    open var duration: Double = 1.0
    
    ///The icon color of the odd images and even backgrounds. Defaults to clear
    open var color1: UIColor = UIColor.white {
        didSet{
            if let imageViews = self.imageViews,
                let imageBackgrounds = self.imageBackgrounds,
                imageViews.count == imageBackgrounds.count {
                
                for index in 0..<imageViews.count {
                    if index % 2 == 0 {
                        imageViews[index].tintColor = color1
                    } else {
                        imageBackgrounds[index].backgroundColor = color1
                    }
                }
                
                if imageViews.count % 2 == 0 {
                    backgroundColor = color1
                }
                
            }
        }
    }
    
    ///The icon color of the even images and odd backgrounds. Defaults to clear
    open var color2: UIColor = UIColor.black {
        didSet{
            if let imageViews = self.imageViews,
                let imageBackgrounds = self.imageBackgrounds,
                imageViews.count == imageBackgrounds.count {
                
                for index in 0..<imageViews.count {
                    if index % 2 == 0 {
                        imageBackgrounds[index].backgroundColor = color2
                    } else {
                        imageViews[index].tintColor = color2
                    }
                }

                if imageViews.count % 2 != 0 {
                    backgroundColor = color2
                }
                
            }
        }
    }

    open var useCustomIconColor: Bool = false {
        didSet {
            if let imageViews = self.imageViews,
                let iconImages = self.iconImages,
                imageViews.count == iconImages.count {
                
                for index in 0..<imageViews.count {
                    imageViews[index].image = iconImages[index].withRenderingMode(useCustomIconColor ? UIImage.RenderingMode.alwaysTemplate : UIImage.RenderingMode.alwaysOriginal)
                }
                
            }
        }
    }
    
    ///The initial size of the icon. Ideally it has to match with the size of the icon in your LaunchScreen.storyboard
    internal var iconInitialSize: CGSize = CGSize(width: 124.0, height: 124.0) {
        didSet{
//            firstImageView?.frame = CGRect(x: 0.0, y: 0.0, width: iconInitialSize.width, height: iconInitialSize.height)
        }
    }
    
    // MARK: Init
    
    /**
     Default constructor of the class
     
     - parameter iconImage:       The Icon image to show the animation
     - parameter iconInitialSize: The initial size of the icon image
     - parameter backgroundColor: The background color of the image, ideally this should match your Splash view
     
     - returns: The created RevealingSplashViewObject
     */
    public init(iconImages: [UIImage], iconInitialSize: CGSize? = nil) {
        self.imageViews = [UIImageView]()
        self.imageBackgrounds = [UIView]()
        
        self.iconImages = iconImages
                
        if let iconInitialSize = iconInitialSize {
            self.iconInitialSize = iconInitialSize
        }
        
        //Inits the view to the size of the screen
        super.init(frame: (UIScreen.main.bounds))
        
        for (index, iconImage) in iconImages.enumerated() {
            let imageBackground = UIView()
            imageBackground.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            imageBackground.transform = CGAffineTransform(scaleX: index == 0 ? 10.0 : 100.0,
                                                          y: index == 0 ? 10.0 : 100.0)
            imageBackground.backgroundColor = index % 2 == 0 ? color1 : color2
            imageBackground.alpha = index == 0 ? 1.0 : 0.0
            
            let imageView = UIImageView()
            imageView.image = iconImage
            imageView.transform = CGAffineTransform(scaleX: index == 0 ? 0.1 : 0.5,
                                                    y: index == 0 ? 0.1 : 0.5)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = UIView.ContentMode.scaleAspectFit
            
            self.imageBackgrounds?.append(imageBackground)
            self.imageViews?.append(imageView)
        }
        
        updateConstraints()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func updateConstraints() {
        super.updateConstraints()

        for (index, imageBackground) in imageBackgrounds!.enumerated().reversed() {
            imageBackground.addSubview((imageViews?[index])!)
            self.addSubview(imageBackground)

            NSLayoutConstraint.activate([
                imageViews![index].centerXAnchor.constraint(equalTo: imageBackground.centerXAnchor),
                imageViews![index].centerYAnchor.constraint(equalTo: imageBackground.centerYAnchor),
                imageViews![index].widthAnchor.constraint(equalToConstant: iconInitialSize.width),
                imageViews![index].heightAnchor.constraint(equalToConstant: iconInitialSize.height)
            ])
        }
    }
    
    // MARK: Animations
    
    //Starts animation series and handles animation of the first icon
    public func start(_ completion: SNKRSAnimatableCompletion? = nil) {
        if let imageBackgrounds = self.imageBackgrounds {
            
            UIView.animate(withDuration: duration,
                           animations: {
                            
                            imageBackgrounds[0].transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                            
            }, completion: { _ in
                
                imageBackgrounds[1].alpha = 1.0
                self.animate(imageBackgrounds: imageBackgrounds, currentIndex: 1, completion)
                
            })
            
        }
    }
    
    //Handles animations of all icons expect for the first and last
    internal func animate(imageBackgrounds: [UIView], currentIndex: Int, _ completion: SNKRSAnimatableCompletion? = nil) {
        UIView.animate(withDuration: duration,
                       animations: {
                        
                        imageBackgrounds[currentIndex - 1].transform = CGAffineTransform(scaleX: 0.0001, y: 0.001)
                        imageBackgrounds[currentIndex].transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                        
        }, completion: { _ in
            
            if currentIndex + 1 >= imageBackgrounds.count {
                print("Last animation complete")
                self.animateFinalIcon(completion)
            } else {
                imageBackgrounds[currentIndex + 1].alpha = 1.0
                self.animate(imageBackgrounds: imageBackgrounds, currentIndex: currentIndex + 1, completion)
            }
            
        })
        
    }
    
    //Handles animation of the last icon
    internal func animateFinalIcon(_ completion: SNKRSAnimatableCompletion? = nil) {
        if let lastImageView = self.imageViews?[self.imageViews!.count - 1] {
            
            UIView.animate(withDuration: self.duration,
                           animations: {

                            lastImageView.transform = CGAffineTransform(scaleX: 0.0001, y: 0.001)
                            self.alpha = 0.0

            }, completion: { _ in
                
                self.removeFromSuperview()
                completion?()
                
            })
            
        }
    }
        
}

