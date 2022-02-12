//
//  HobbyViewController.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/02/11.
//

import UIKit

import RxSwift
import RxRelay
import RxKeyboard
import IQKeyboardManagerSwift

final class HobbyViewController: BaseViewController {
    
    let letters = ["안녕","안녕하세요","안녕하세요 저는 포마입니다.","안녕하세요 만나서 정말 반갑습니다."]
    
    let touchView = UIView().then {
        $0.backgroundColor = SacColor.color(.gray3)
        $0.isHidden = true
        $0.alpha = 0.4
    }
    
    let searchBar = UISearchBar().then {
        $0.placeholder = "띄어쓰기로 복수 입력이 가능해요"
    }

    let hobbyCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout()).then {
        let layer = UICollectionViewFlowLayout()
        layer.scrollDirection = .vertical
        $0.collectionViewLayout = layer
        $0.register(HobbyCollectionCell.self, forCellWithReuseIdentifier: HobbyCollectionCell.reuseIdentifier)
        $0.register(HobbyCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HobbyCollectionViewHeader.reuseIdentifier)
    }
    
    let sasecSearchButton = ButtonConfiguration(customType: .h48(type: .fill, icon: false)).then {
        $0.setTitle("새싹 찾기", for: .normal)
    }
    
    //MARK: Input & Output
    private lazy var input = HobbyViewModel.Input(
        searchBarText: searchBarText.asDriver(onErrorJustReturn: "error"),
        removeItem: removeNumber.asDriver(onErrorJustReturn: ""))
    lazy var output = viewModel.transform(input: input)
    
    var removeNumber = PublishRelay<String>()
    var searchBarText = PublishRelay<String>()
    let viewModel = HobbyViewModel()
    let disposeBag = DisposeBag()
    
    var aroundHobby = [String]()
    var recommendHobby = [String]()
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    //MARK: Function
    private func bind() {
        
        output.myHobbyList.asDriver()
            .drive(onNext: { [weak self] array in
                guard let self = self else {return}
                self.hobbyCollectionView.reloadSections(IndexSet(1...1))
            })
            .disposed(by: disposeBag)
        
        self.removeNumber.asSignal()
            .emit(onNext: { [weak self] _ in
                guard let self = self else {return}
                self.hobbyCollectionView.reloadSections(IndexSet(1...1))
            })
            .disposed(by: disposeBag)
        
        sasecSearchButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else {return}
                self.findFriedsRequest()
            })
            .disposed(by: disposeBag)
    }
    
    func findFriedsRequest() {
        let gender = UserDefaults.standard.integer(forKey: UserDefaultsManager.gender)
        if gender == -1 {
            let alertPage = SeSacAlert("성별 체크 필요", "내 성별이 설정되어 있지 않습니다") {
                self.dismiss(animated: true)
                DispatchQueue.main.async {
                    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                    windowScene.windows.first?.rootViewController = UINavigationController(rootViewController: MyPageViewController())
                    windowScene.windows.first?.makeKeyAndVisible()
                }
            }
            alertPage.cancelButton.isHidden = true
            alertPage.modalPresentationStyle = .overFullScreen
            self.present(alertPage, animated: true, completion: nil)
        } else {
            var hobbyList = [String]()
            viewModel.sendMyHobbylist.forEach {
                hobbyList.append($0)
            }
            SeSacURLNetwork.shared.friendsRequest(hf: hobbyList) {
                self.navigationController?.pushViewController(SearchFriendsViewController(), animated: true)
            } failErrror: { error in
                guard let error = error else {return}
                var toastMessage = ""
                switch error {
                case "201":
                    toastMessage = "신고가 누적되어 이용하실 수 없습니다"
                case "203":
                    toastMessage = "약속 취소 패널티로, 1분동안 이용하실 수 없습니다"
                case "204":
                    toastMessage = "약속 취소 패널티로, 2분동안 이용하실 수 없습니다"
                case "205":
                    toastMessage = "연속으로 약속을 취소하셔서 3분동안 이용하실 수 없습니다"
                case "500":
                    toastMessage = "서버 에러입니다"
                default:
                    toastMessage = "잠시 후 재시도 해주시길 바랍니다"
                }
                // Toast 메시지
                let alertPage = SeSacAlert("\(error) 에러", "\(toastMessage)") {
                    self.dismiss(animated: true)
                }
                alertPage.cancelButton.isHidden = true
                alertPage.modalPresentationStyle = .overFullScreen
                self.present(alertPage, animated: true, completion: nil)
            }
        }
    }
    
    @objc func endEditing() {
        self.view.endEditing(true)
        searchBar.resignFirstResponder()
    }
    func touchManager() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        self.touchView.addGestureRecognizer(tap)
    }
    
    //MARK: View Base
    override func configure() {
        view.backgroundColor = SacColor.color(.white)
        view.bringSubviewToFront(touchView)
        touchManager()
        
        self.navigationController?.navigationBar.tintColor = SacColor.color(.black)
        searchBar.delegate = self
        
        hobbyCollectionView.collectionViewLayout = CollectionViewLeftAlignFlowLayout()
        self.hobbyCollectionView.delegate = self
        self.hobbyCollectionView.dataSource = self
    }
    
    override func setConstraints() {
        self.navigationItem.titleView = searchBar
        let backButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow"), style: .plain, target: self, action: #selector(backPage))
        self.navigationItem.leftBarButtonItem = backButtonItem
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        view.addSubview(sasecSearchButton)
        view.addSubview(touchView)
        view.addSubview(hobbyCollectionView)
        
        sasecSearchButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        touchView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(sasecSearchButton.snp.top)
        }
        
        hobbyCollectionView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.bottom.equalTo(sasecSearchButton.snp.top).inset(-16)
        }
        
        RxKeyboard.instance.visibleHeight
            .skip(1)
            .drive(onNext: { [weak self] keyboardHeigt in
                guard let self = self else {return}
                if keyboardHeigt > 0 {
                    UIView.animate(withDuration: 0) {
                        self.touchView.isHidden = false
                        self.sasecSearchButton.snp.updateConstraints { make in
                            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(keyboardHeigt - 34)
                            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
                        }
                        self.sasecSearchButton.layer.cornerRadius = 0
                    }
                } else {
                    self.touchView.isHidden = true
                    UIView.animate(withDuration: 0) {
                        self.sasecSearchButton.snp.updateConstraints { make in
                            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(16)
                            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(16)
                        }
                        self.sasecSearchButton.layer.cornerRadius = 8
                    }
                }
                self.view.layoutIfNeeded()
            })
            .disposed(by: disposeBag)
    }
    
    @objc func backPage() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension HobbyViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let text = searchBar.text else {return}
        
        var textStatus = false
        output.status.asDriver()
            .drive(onNext: { status in
            textStatus = status
            }).disposed(by: disposeBag)
        
        if textStatus {
            let filter = text.replacingOccurrences(of: " ", with: "")
            if filter.count < 1 || filter.count > 8 {
                let alertPage = SeSacAlert("글자수 제한", "1자 이상 8자 이하로 입력해주셔야 합니다") {
                    self.dismiss(animated: true)
                    self.searchBar.text = ""
                }
                alertPage.cancelButton.isHidden = true
                alertPage.modalPresentationStyle = .overFullScreen
                self.present(alertPage, animated: true, completion: nil)
            } else {
                self.searchBarText.accept(text)
                searchBar.text = ""
            }
        } else {
            let alertPage = SeSacAlert("제한", "더 이상 입력할 수 없습니다") {
                self.dismiss(animated: true)
                self.searchBar.text = ""
            }
            alertPage.cancelButton.isHidden = true
            alertPage.modalPresentationStyle = .overFullScreen
            self.present(alertPage, animated: true, completion: nil)
        }
    }
}
