//
//  OnBoardingViewController.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/02/16.
//

import UIKit


class OnBoardingViewController: BaseViewController {
    
    let onboardingTitle = UIImageView().then {
        $0.image = UIImage(named: "관심사가 같은 친구를 찾을 수 있어요")
    }
    let onboardingScrollView = UIScrollView().then {
        $0.alwaysBounceVertical = false
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
        $0.isScrollEnabled = true
        $0.isPagingEnabled = true
        $0.bounces = false
    }
    let onboardingImage = UIImageView().then {
        $0.image = UIImage(named: "onboarding_img1")
    }
    var onboardingPageControl = UIPageControl().then {
        $0.currentPage = 0
        $0.numberOfPages = 3
        $0.pageIndicatorTintColor = SacColor.color(.gray5)
        $0.currentPageIndicatorTintColor = SacColor.color(.black)
    }
    let nextButton = ButtonConfiguration(customType: .h48(type: .disable, icon: false)).then {
        $0.setTitle("시작하기", for: .normal)
        $0.isEnabled = false
        $0.addTarget(self, action: #selector(clickedButton), for: .touchUpInside)
    }
    
    var imageNames = ["onboarding_img1", "onboarding_img2", "onboarding_img3"]
    var titleNames = ["관심사가 같은 친구를 찾을 수 있어요", "위치 기반으로 빠르게 주위 친구를 확인", "SeSAC Frineds"]
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc private func clickedButton() {
        self.dismiss(animated: true) {
            DispatchQueue.main.async {
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                windowScene.windows.first?.rootViewController = UINavigationController(rootViewController: AuthPhoneViewController())
                windowScene.windows.first?.makeKeyAndVisible()
            }
        }
    }
    
    override func configure() {
        view.backgroundColor = SacColor.color(.white)
        onboardingScrollView.delegate = self
    }
    
    override func setConstraints() {
        view.addSubview(onboardingTitle)
        view.addSubview(onboardingScrollView)
        view.addSubview(onboardingPageControl)
        view.addSubview(nextButton)
            
        onboardingScrollView.snp.makeConstraints {
            $0.leading.equalTo(view)
            $0.height.equalTo(view.frame.width)
            $0.trailing.equalTo(view).multipliedBy(3)
            $0.center.equalTo(view)
        }
        onboardingScrollView.contentSize = CGSize(width: view.frame.size.width * CGFloat(imageNames.count), height: view.frame.size.width)

        
        onboardingTitle.snp.makeConstraints {
            $0.centerX.equalTo(view)
            $0.bottom.equalTo(onboardingScrollView.snp.top).offset(-56)
            $0.width.lessThanOrEqualTo(view.snp.width)
        }
        
        onboardingPageControl.snp.makeConstraints {
            $0.centerX.equalTo(view)
            $0.top.equalTo(onboardingScrollView.snp.bottom).offset(56)
        }
        
        nextButton.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        for (index, imageName) in imageNames.enumerated() {
            let image = UIImage(named: imageName)
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            imageView.frame.origin.x = UIScreen.main.bounds.width * CGFloat(index)
            onboardingScrollView.addSubview(imageView)
        }
    }
}

extension OnBoardingViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        onboardingPageControl.currentPage = Int(Float(scrollView.contentOffset.x / UIScreen.main.bounds.width))
        var page = onboardingPageControl.currentPage
        
        switch page {
        case 0:
            onboardingTitle.image = UIImage(named: titleNames[0])
        case 1:
            onboardingTitle.image = UIImage(named: titleNames[1])
        case 2:
            onboardingTitle.image = UIImage(named: titleNames[2])
            nextButton.customLayout(.fill)
            nextButton.isEnabled = true
        default:
            break
        }
        
    }
}
