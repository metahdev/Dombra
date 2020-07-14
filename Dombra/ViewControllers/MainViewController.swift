//
//  MainViewController.swift
//  Dombra
//
//  Created by Metah on 3/1/20.
//  Copyright © 2020 devMetah. All rights reserved.
//

import UIKit
import GoogleMobileAds


// ca-app-pub-3940256099942544/2934735716 - test banner id

#warning("TODO")
/*
 1. Main Layout
 2. SettingVC
 3. Refactoring(sound reusing, less CVs)
 */

protocol MainViewControllerProtocol: class {
    func closeChildView()
}

class MainViewController: UIViewController, MainViewControllerProtocol {
    // MARK:- Properties
    private lazy var backgroundImageView = UIImageView()
    private lazy var keysCVBackground: UIImageView = {
        let iv = UIImageView()
        let image = UIImage(named: "dombraBg")
        iv.image = image
        return iv
    }()
    
    #warning("make less count of CVs")
    private lazy var firstKeysCV: UICollectionView = {
        return turnToKeyCV(vc: self, tag: 1000, CellClass: KeyCollectionViewCell.self, direction: .horizontal, spacing: 4)
    }()
    private lazy var firstNotesCV: UICollectionView = {
        return turnToKeyCV(vc: self, tag: 1002, CellClass: TitleCollectionViewCell.self, direction: .horizontal, spacing: 4)
    }()
    private lazy var firstOpenNoteLbl: UILabel = {
        let label = UILabel()
        label.turnToStateLabel(Content.firstOpenNote, font: view.frame.height * 0.04)
        return label
    }()
    private lazy var firstString: UIImageView = {
        let iv = UIImageView()
        iv.turnToString()
        return iv
    }()
    
    private lazy var secondKeysCV: UICollectionView = {
        return turnToKeyCV(vc: self, tag: 1001, CellClass: KeyCollectionViewCell.self, direction: .horizontal, spacing: 4)
    }()
    private lazy var secondNotesCV: UICollectionView = {
        return turnToKeyCV(vc: self, tag: 1003, CellClass: TitleCollectionViewCell.self, direction: .horizontal, spacing: 4)
    }()
    private lazy var secondOpenNoteLbl: UILabel = {
        let label = UILabel()
        label.turnToStateLabel(Content.secondOpenNote, font: view.frame.height * 0.04)
        return label
    }()
    private lazy var secondString: UIImageView = {
        let iv = UIImageView()
        iv.turnToString()
        return iv
    }()
    
    private lazy var dotsCV: UICollectionView = {
        return turnToKeyCV(vc: self, tag: 1004, CellClass: DotCollectionViewCell.self, direction: .horizontal, spacing: 4)
    }()
    private lazy var openKeyView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    private lazy var keysHidingSwitch: UISwitch = {
        let s = UISwitch()
        s.isOn = false
        s.addTarget(self, action: #selector(hideOrUnhideKeys), for: .valueChanged)
        return s
    }()
    private lazy var keysStateLabel: UILabel = {
        let lbl = UILabel()
        lbl.turnToStateLabel("Hide the dombra keys", font: self.view.frame.height * 0.04)
        return lbl
    }()
    
    private lazy var metronomeLabel: UILabel = {
        let lbl = UILabel()
        lbl.turnToStateLabel("Metronome(Grave)", font: self.view.frame.height * 0.045)
        return lbl
    }()
    private lazy var containerView: ContainerView = {
        return ContainerView(frame: CGRect(x: 0, y: 0, width: 0, height: view.frame.height * 0.1))
    }()
    private lazy var playButton: UIButton = {
        let btn = UIButton()
        btn.configureButton(with: "play", target: self, and: #selector(toggleMetronome))
        return btn
    }()
    private lazy var plusButton: UIButton = {
        let btn = UIButton()
        btn.configureButton(with: "plus", target: self, and: #selector(increaseTempo))
        return btn
    }()
    private lazy var minusButton: UIButton = {
        let btn = UIButton()
        btn.configureButton(with: "minus", target: self, and: #selector(decreaseTempo))
        btn.isEnabled = false
        return btn
    }()

    private lazy var iconsCV: UICollectionView = {
        return turnToKeyCV(vc: self, tag: 1005, CellClass: ImageCollectionViewCell.self, direction: .vertical, spacing: 10)
    }()
    
    private lazy var firstOpenKeyHighlight: UIView = {
        let v = UIView()
        v.makeItDisappear()
        v.backgroundColor = Content.highlightColor
        return v
    }()
    private lazy var secondOpenKeyHighlight: UIView = {
        let v = UIView()
        v.makeItDisappear()
        v.backgroundColor = Content.highlightColor
        return v
    }()
    
    private lazy var bannerView: GADBannerView = {
        let v = GADBannerView()
        v.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        v.delegate = self
        v.rootViewController = self
        return v
    }()
    
    private var icons = ["settings", "question"]

    private var animationTimer: Timer?

    private var currentTempo = "Grave" {
        didSet {
            metronomeLabel.text = ("Metronome(\(currentTempo))")
        }
    }
    private var tempoIndex = 0
    private var isMetronomeTurnedOn = false
    private var isRight = false
    
    private var tempConstraints = [NSLayoutConstraint]()
    private var visualEffectView: UIVisualEffectView!
    private var currentVC: UIViewController!
    

    // MARK:- View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImageView.turnToBackground(view, image: "wood")

        // the layout methods are in the extension
        addSubviews()
        setAutoresizingToFalse()
        activateConstraints()
        
        containerView.setupLayout(playButton)
        
        addGesturesToOpenKey()
        bannerView.load(GADRequest())
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AudioPlayer.backgroundAudioPlayer.stop()
    }
    
    private func addGesturesToOpenKey() {
        let touch = UITapGestureRecognizer(target: self, action: #selector(playStringIndividually(recognizer:)))
        
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(playBothStrings))
        downSwipe.direction = .down
        
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(playBothStrings))
        upSwipe.direction = .up

        openKeyView.addGestureRecognizer(touch)
        openKeyView.addGestureRecognizer(downSwipe)
        openKeyView.addGestureRecognizer(upSwipe)
    }


    // MARK:- Switches
    @objc
    private func hideOrUnhideKeys() {
        if keysHidingSwitch.isOn {
            keysStateLabel.text = "Show the dombra keys"
        } else {
            keysStateLabel.text = "Hide the dombra keys"
        }
        firstKeysCV.reloadData()
        secondKeysCV.reloadData()
    }


    // MARK:- Metronome functionality
    @objc
    private func toggleMetronome() {
        isMetronomeTurnedOn = !isMetronomeTurnedOn
        guard isMetronomeTurnedOn else {
            playButton.setImage(UIImage(named: "play"), for: .normal)
            stopMetronome()
            return
        }
        playButton.setImage(UIImage(named: "stop"), for: .normal)
        runMetronome()
    }
    
    private func runMetronome() {
        animationTimer = Timer.scheduledTimer(timeInterval: Content.tempos[currentTempo]! * 0.5, target: self, selector: #selector(updateState), userInfo: nil, repeats: true)
    }

    @objc
    private func updateState() {
        isRight = !isRight
        
        containerView.clearAllDots()
        if isRight {
            AudioPlayer.playMetronomeBeat()
            containerView.fillRightDot()
        } else {
            containerView.fillLeftDot()
        }
    }

    @objc
    private func increaseTempo() {
        minusButton.isEnabled = true
        stopMetronome()
        setCurrentTempo(increase: true)
    }

    @objc
    private func decreaseTempo() {
        plusButton.isEnabled = true
        stopMetronome()
        setCurrentTempo(increase: false)
    }
    
    private func setCurrentTempo(increase: Bool) {
        var dictArr = Array(Content.tempos)
        dictArr.sort{ $0.1 > $1.1 }
        var keys = [String]()
        for (key, _) in dictArr {
            keys.append(key)
        }
        if increase {
            tempoIndex += 1
            plusButton.isEnabled = (tempoIndex != keys.count - 1)
        } else {
            tempoIndex -= 1
            minusButton.isEnabled = (tempoIndex != 0)
        }
        currentTempo = keys[tempoIndex]
    }
    
    private func stopMetronome() {
        isMetronomeTurnedOn = false
        isRight = false 
        playButton.setImage(UIImage(named: "play"), for: .normal)
        
        animationTimer?.invalidate()
        containerView.clearAllDots()
        AudioPlayer.metronomeAudioPlayer.stop()
    }


    // MARK:- Strings
    @objc
    private func playStringIndividually(recognizer: UITapGestureRecognizer) {
        let point = recognizer.location(in: openKeyView)
        let height = openKeyView.frame.height
        
        if point.y < height * 0.5 {
            firstStringDragged(0)
            
            animateHighlighting(viewToHighlight: firstOpenKeyHighlight, keysCV: firstKeysCV)
        } else {
            secondStringDragged(0)
            
            animateHighlighting(viewToHighlight: secondOpenKeyHighlight, keysCV: secondKeysCV)
        }
    }

    @objc
    private func playBothStrings(swipe: UISwipeGestureRecognizer) {
        firstStringDragged(0)
        animateHighlighting(viewToHighlight: firstOpenKeyHighlight, keysCV: firstKeysCV)
        animateHighlighting(viewToHighlight: secondOpenKeyHighlight, keysCV: secondKeysCV)
        secondStringDragged(0)
    }
    
    private func animateHighlighting(viewToHighlight: UIView?, keysCV: UICollectionView) {
        guard keysHidingSwitch.isOn else { return }
        viewToHighlight?.alpha = 1
        UIView.animate(withDuration: 0.1, animations: {
            viewToHighlight?.alpha = 0
        })
    }

    private func firstStringDragged(_ index: Int) {
        AudioPlayer.playFirstStringNote(index)
        animateString(firstString)
    }

    private func secondStringDragged(_ index: Int) {
        AudioPlayer.playSecondStringNote(index)
        animateString(secondString)
    }

    private func animateString(_ string: UIImageView) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 5
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: string.center.x, y: string.center.y + 1))
        animation.toValue = NSValue(cgPoint: CGPoint(x: string.center.x, y: string.center.y - 1))

        string.layer.add(animation, forKey: "position")
    }
}


extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag < 1005 {
            return 19
        } else {
            return icons.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuseID", for: indexPath)
        cell.backgroundColor = .clear
        cell.isUserInteractionEnabled = false
        
        if collectionView.tag == 1005 {
            (cell as! ImageCollectionViewCell).imageName = icons[indexPath.row]
            cell.isUserInteractionEnabled = true 
            return cell
        }
        
        if collectionView.tag == 1004 {
            configureDotCVCell(indexPath.row, cell)
            return cell
        }
        if collectionView.tag > 1001 {
            (cell as! TitleCollectionViewCell).title = collectionView.tag == 1003 ? Content.secondNotes[indexPath.row] : Content.firstNotes[indexPath.row]
            return cell
        }
        
        cell.isUserInteractionEnabled = true
        if keysHidingSwitch.isOn {
            (cell as? KeyCollectionViewCell)?.addBlurEffectViews()
        } else {
            (cell as? KeyCollectionViewCell)?.removeBlurs()
        }
        
        return cell
    }
    
    private func configureDotCVCell(_ index: Int, _ cell: UICollectionViewCell) {
        switch (index) {
        case 2, 5, 7, 9, 12, 14, 17:
            (cell as! DotCollectionViewCell).createDot()
        default: return
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? KeyCollectionViewCell
    
        let index = 19 - indexPath.row
        if collectionView.tag == 1000 {
            firstStringDragged(index)
            animateHighlighting(viewToHighlight: cell?.greenBlurEffectView, keysCV: firstKeysCV)
        } else if collectionView.tag == 1001 {
            secondStringDragged(index)
            animateHighlighting(viewToHighlight: cell?.greenBlurEffectView, keysCV: secondKeysCV)
        } else if collectionView.tag == 1005 {
            stopMetronome()
            addBlur()
            if indexPath.row == 0 {
                currentVC = SettingsViewController()
            } else {
                currentVC = VideoViewController()
            }
            setProperties()
            initChildVC()
            NSLayoutConstraint.activate(tempConstraints)
            setupAlphaValues(0)
            animWithValue(1, completion: {})
        }
    }
    
    private func setProperties() {
        (currentVC as! ChildVC).main = self
        currentVC.view.translatesAutoresizingMaskIntoConstraints = false
        currentVC.view.layer.zPosition = 3
        
        self.view.addSubview(currentVC.view)
        self.addChild(currentVC)
        currentVC.didMove(toParent: parent)
        initChildVC()
        setupAlphaValues(0)
    }
    
    private func setupAlphaValues(_ value: CGFloat) {
        self.currentVC.view.alpha = value
        self.visualEffectView.alpha = value
    }
    
    private func animWithValue(_ value: CGFloat, completion: @escaping () -> Void) {
        UIView.animate(withDuration: 1.0, animations: {
            self.setupAlphaValues(value)
        }, completion: {(_) in
            completion()
        })
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let constant = collectionView.frame.width
        if collectionView.tag < 1005 {
            let width = (constant / 19) - 4
            return CGSize(width: width, height: collectionView.frame.height)
        } else {
            return CGSize(width: constant, height: constant)
        }
    }
}


// MARK:- BannerAd Delegate
extension MainViewController: GADBannerViewDelegate {
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("ad recieved")
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print(error)
    }
}


extension MainViewController {
    // MARK:- Layout
    private func addSubviews() {
        view.addSubview(keysCVBackground)

        view.addSubview(openKeyView)
        view.addSubview(firstOpenKeyHighlight)
        view.addSubview(firstKeysCV)
        view.addSubview(firstNotesCV)
        view.addSubview(firstOpenNoteLbl)
        view.addSubview(firstString)

        view.addSubview(secondOpenKeyHighlight)
        view.addSubview(secondKeysCV)
        view.addSubview(secondNotesCV)
        view.addSubview(secondOpenNoteLbl)
        view.addSubview(secondString)

        view.addSubview(dotsCV)

        view.addSubview(keysHidingSwitch)
        view.addSubview(keysStateLabel)

        view.addSubview(metronomeLabel)
        view.addSubview(containerView)
        view.addSubview(playButton)
        view.addSubview(plusButton)
        view.addSubview(minusButton)
        
        view.addSubview(iconsCV)
        view.addSubview(bannerView)
    }

    private func setAutoresizingToFalse() {
        _ = self.view.subviews.map { $0.translatesAutoresizingMaskIntoConstraints = false }
    }

    private func activateConstraints() {
        #warning("iPad playBtn is incorrect")
        // or change the whole layout to consider bannerView's height
        NSLayoutConstraint.activate([
            keysCVBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            keysCVBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            keysCVBackground.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            keysCVBackground.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),

            openKeyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            openKeyView.topAnchor.constraint(equalTo: keysCVBackground.topAnchor),
            openKeyView.heightAnchor.constraint(equalTo: keysCVBackground.heightAnchor),
            openKeyView.widthAnchor.constraint(equalTo: keysCVBackground.heightAnchor, multiplier: 0.7),
            
            firstOpenKeyHighlight.leadingAnchor.constraint(equalTo: openKeyView.leadingAnchor),
            firstOpenKeyHighlight.trailingAnchor.constraint(equalTo: openKeyView.trailingAnchor),
            firstOpenKeyHighlight.topAnchor.constraint(equalTo: openKeyView.topAnchor),
            firstOpenKeyHighlight.heightAnchor.constraint(equalTo: openKeyView.heightAnchor, multiplier: 0.5),
            
            secondOpenKeyHighlight.leadingAnchor.constraint(equalTo: firstOpenKeyHighlight.leadingAnchor),
            secondOpenKeyHighlight.trailingAnchor.constraint(equalTo: firstOpenKeyHighlight.trailingAnchor),
            secondOpenKeyHighlight.topAnchor.constraint(equalTo: firstOpenKeyHighlight.bottomAnchor),
            secondOpenKeyHighlight.bottomAnchor.constraint(equalTo: openKeyView.bottomAnchor),

            firstNotesCV.leadingAnchor.constraint(equalTo: openKeyView.trailingAnchor),
            firstNotesCV.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            firstNotesCV.bottomAnchor.constraint(equalTo: keysCVBackground.topAnchor),
            firstNotesCV.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),

            firstOpenNoteLbl.centerYAnchor.constraint(equalTo: firstNotesCV.centerYAnchor),
            firstOpenNoteLbl.centerXAnchor.constraint(equalTo: openKeyView.centerXAnchor),

            firstKeysCV.leadingAnchor.constraint(equalTo: openKeyView.trailingAnchor),
            firstKeysCV.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            firstKeysCV.topAnchor.constraint(equalTo: keysCVBackground.topAnchor),
            firstKeysCV.heightAnchor.constraint(equalTo: openKeyView.heightAnchor, multiplier: 0.5),

            secondKeysCV.leadingAnchor.constraint(equalTo: firstKeysCV.leadingAnchor),
            secondKeysCV.trailingAnchor.constraint(equalTo: firstKeysCV.trailingAnchor),
            secondKeysCV.topAnchor.constraint(equalTo: firstKeysCV.bottomAnchor),
            secondKeysCV.heightAnchor.constraint(equalTo: firstKeysCV.heightAnchor),

            secondNotesCV.leadingAnchor.constraint(equalTo: firstNotesCV.leadingAnchor),
            secondNotesCV.trailingAnchor.constraint(equalTo: firstNotesCV.trailingAnchor),
            secondNotesCV.topAnchor.constraint(equalTo: secondKeysCV.bottomAnchor),
            secondNotesCV.heightAnchor.constraint(equalTo: firstNotesCV.heightAnchor),

            secondOpenNoteLbl.centerYAnchor.constraint(equalTo: secondNotesCV.centerYAnchor),
            secondOpenNoteLbl.centerXAnchor.constraint(equalTo: openKeyView.centerXAnchor),

            dotsCV.leadingAnchor.constraint(equalTo: secondKeysCV.leadingAnchor),
            dotsCV.trailingAnchor.constraint(equalTo: secondKeysCV.trailingAnchor),
            dotsCV.heightAnchor.constraint(equalTo: secondKeysCV.heightAnchor),
            dotsCV.centerYAnchor.constraint(equalTo: keysCVBackground.centerYAnchor),

            firstString.leadingAnchor.constraint(equalTo: keysCVBackground.leadingAnchor),
            firstString.trailingAnchor.constraint(equalTo: keysCVBackground.trailingAnchor),
            firstString.centerYAnchor.constraint(equalTo: firstKeysCV.centerYAnchor),
            firstString.heightAnchor.constraint(equalTo: firstKeysCV.heightAnchor, multiplier: 0.06),

            secondString.leadingAnchor.constraint(equalTo: keysCVBackground.leadingAnchor),
            secondString.trailingAnchor.constraint(equalTo: keysCVBackground.trailingAnchor),
            secondString.centerYAnchor.constraint(equalTo: secondKeysCV.centerYAnchor),
            secondString.heightAnchor.constraint(equalTo: firstString.heightAnchor),


            keysHidingSwitch.topAnchor.constraint(equalTo: secondNotesCV.bottomAnchor, constant: 8),
            keysHidingSwitch.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),

            keysStateLabel.topAnchor.constraint(equalTo: keysHidingSwitch.bottomAnchor, constant: 8),
            keysStateLabel.leadingAnchor.constraint(equalTo: keysHidingSwitch.leadingAnchor),

            metronomeLabel.topAnchor.constraint(equalTo: keysHidingSwitch.topAnchor),
            metronomeLabel.heightAnchor.constraint(equalToConstant: metronomeLabel.intrinsicContentSize.height),
            metronomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            bannerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bannerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bannerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bannerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15),
            
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.17),
            containerView.topAnchor.constraint(equalTo: metronomeLabel.bottomAnchor, constant: 8),
            containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.08),
            
            playButton.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 8),
            playButton.bottomAnchor.constraint(equalTo: bannerView.topAnchor, constant: -16),
            playButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            playButton.widthAnchor.constraint(equalTo: playButton.heightAnchor),
            
            minusButton.trailingAnchor.constraint(equalTo: playButton.leadingAnchor, constant: -16),
            minusButton.topAnchor.constraint(equalTo: playButton.topAnchor),
            minusButton.heightAnchor.constraint(equalTo: playButton.heightAnchor),
            minusButton.widthAnchor.constraint(equalTo: playButton.widthAnchor),
            
            plusButton.leadingAnchor.constraint(equalTo: playButton.trailingAnchor, constant: 16),
            plusButton.widthAnchor.constraint(equalTo: playButton.widthAnchor),
            plusButton.topAnchor.constraint(equalTo: playButton.topAnchor),
            plusButton.heightAnchor.constraint(equalTo: playButton.heightAnchor),
            
            iconsCV.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            iconsCV.topAnchor.constraint(equalTo: keysHidingSwitch.topAnchor),
            iconsCV.bottomAnchor.constraint(equalTo: bannerView.topAnchor),
            iconsCV.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.07)
        ])
    }
    
    
    // MARK:- ChildVC
    private func addBlur() {
        visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        
        visualEffectView.frame = view.frame
        visualEffectView.layer.zPosition = 2
        visualEffectView.isUserInteractionEnabled = false
        openKeyView.isUserInteractionEnabled = false

        view.addSubview(visualEffectView)
    }
    
    private func removeBlur() {
        visualEffectView.removeFromSuperview()
    }
    
    private func initChildVC() {
        tempConstraints = [
            currentVC.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentVC.view.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            currentVC.view.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.9),
            currentVC.view.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9)
        ]
    }
}


extension MainViewController {
    func closeChildView() {
        animWithValue(0, completion: {
            NSLayoutConstraint.deactivate(self.tempConstraints)
            self.removeBlur()
            self.currentVC.remove()
            self.openKeyView.isUserInteractionEnabled = true
        })
    }
}
