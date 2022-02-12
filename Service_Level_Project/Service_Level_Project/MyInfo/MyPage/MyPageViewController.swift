//
//  MyPageViewController.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/01/25.
//

import UIKit
import RxSwift

class MyPageViewController: BaseViewController {
    
    let pageScrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    
    //MARK: 이미지
    let userBackgroudImage = UIImageView().then {
        $0.image = UIImage(named: "sesac_background_1")
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 15
    }
    let userFace = UIImageView().then {
        $0.image = UIImage(named: "sesac_face_1")
    }
    
    //MARK: 오토디멘션 헤더
    let headerView = DimensionHeaderView()
    
    //MARK: 테이블 뷰
    let userTableView = UITableView(frame: .zero, style: .plain).then {
        $0.register(MyPageTableViewCell.self, forCellReuseIdentifier: MyPageTableViewCell.reuseIdentifier)
        $0.isScrollEnabled = false
        $0.separatorColor = .clear
    }
    
    private lazy var input = MyPageViewModel
        .Input()
    private lazy var output = viewModel.transform(input: input)
    
    private let viewModel = MyPageViewModel()
    private let disposeBag = DisposeBag()
    
    //MARK: override 부분
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SeSacURLNetwork.shared.loginMember { model in
        } failErrror: { error in
        }
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    func bind() {
        viewModel.updateUsetInfomation()
        headerView.userNickname.text = output.userData.nick
        headerView.hobby.isHidden = true
        headerView.hobbyStackView.isHidden = true
    }
    
    override func configure() {
        view.backgroundColor = .white
        
        userTableView.delegate = self
        userTableView.dataSource = self
        userTableView.rowHeight = UITableView.automaticDimension
        
        userBackgroudImage.image = SeSacUserBackgroundImageManager.image(output.userData.background)
        userFace.image = SeSacUserBackgroundImageManager.image(output.userData.sesac)
        
        title = "정보 관리"
        self.navigationController?.navigationBar.tintColor = .black
        let saveButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(clickedSaveButton))
        self.navigationItem.rightBarButtonItem = saveButton
    }
    
    @objc func clickedSaveButton() {
        // 이건 아닌거 같은데...
        switch viewModel.update {
        case let .some((search, min, max, male, female, hobby)):
            if male && female {
                let alertPage = SeSacAlert("성별 오류", "성별이 올바르지 않습니다") {
                    self.dismiss(animated: true)
                }
                alertPage.modalPresentationStyle = .overFullScreen
                self.present(alertPage, animated: true, completion: nil)
            } else if male {
                SeSacURLNetwork.shared.updateMypage(search: search, ageMin: min, ageMax: max, gender: 0, hobby: hobby)
                self.navigationController?.popViewController(animated: true)
            } else if female {
                SeSacURLNetwork.shared.updateMypage(search: search, ageMin: min, ageMax: max, gender: 1, hobby: hobby)
                self.navigationController?.popViewController(animated: true)
            } else {
                SeSacURLNetwork.shared.updateMypage(search: search, ageMin: min, ageMax: max, gender: -1, hobby: hobby)
                self.navigationController?.popViewController(animated: true)
            }
        default: break
        }
    }
    
    override func setConstraints() {
        view.addSubview(pageScrollView)
        pageScrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.bottom.equalTo(view).inset(20)
        }
        
        pageScrollView.addSubview(userBackgroudImage)
        userBackgroudImage.addSubview(userFace)
        pageScrollView.addSubview(headerView)
        pageScrollView.addSubview(userTableView)
        
        userBackgroudImage.snp.makeConstraints {
            $0.top.equalTo(pageScrollView).inset(16)
            $0.leading.trailing.equalTo(pageScrollView)
            $0.centerX.equalTo(pageScrollView)
        }
        userFace.snp.makeConstraints {
            $0.bottom.equalTo(userBackgroudImage)
            $0.centerX.equalTo(userBackgroudImage)
        }
        headerView.snp.makeConstraints {
            $0.top.equalTo(userBackgroudImage.snp.bottom)
            $0.leading.trailing.equalTo(pageScrollView)
            $0.centerX.equalTo(pageScrollView)
        }
        
        userTableView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(pageScrollView)
            $0.height.equalTo(350)
            $0.bottom.equalTo(pageScrollView)
        }
    }
}

extension MyPageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyPageTableViewCell.reuseIdentifier, for: indexPath) as? MyPageTableViewCell else {
            return UITableViewCell()
        }

        cell.title.text = "\(viewModel.tableData[indexPath.row].title)"
        cell.selectionStyle = .none
        
        //MARK: TableView Data 입력..
        //다음에는 ScrollView나 TableView중에 하나만 해야겠다..
        let gender = CheckDataModel.gender(output.userData.gender).genderSwitch
        if gender == "남자" {
            MyPageViewModel.maleSwitch = true
            MyPageViewModel.maleGender.accept(true)
            cell.maleButton.customLayout(.fill)
        } else if gender == "여자" {
            MyPageViewModel.femaleSwitch = true
            MyPageViewModel.femaleGender.accept(true)
            cell.femaleButton.customLayout(.fill)
        }
        
        let hobby = output.userData.hobby.count > 0 ? output.userData.hobby : nil
        cell.hobbyTextField.textField.text = hobby
    
        if let searchable = CheckDataModel.searchable(output.userData.searchable).searchable {
            cell.searchSwitch.isOn = searchable
            MyPageViewModel.searchSwitch = searchable
        }
        
        
        cell.slider.value = [CGFloat(output.userData.ageMin), CGFloat(output.userData.ageMax)]
        cell.startAge.accept(output.userData.ageMin)
        cell.lastAge.accept(output.userData.ageMax)
        
        cell.cellConfigure(indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 4 {
            let alertPage = SeSacAlert("정말 탈퇴하시겠습니까?", "탈퇴하시면 새싹 프렌즈를 이용할실 수 없어요 ㅜㅜ\noh nooooooo") {
                SeSacURLNetwork.shared.withdraw()
                self.dismiss(animated: true) {
                    DispatchQueue.main.async {
                        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                        windowScene.windows.first?.rootViewController = UINavigationController(rootViewController: CreateNicknameViewController())
                        windowScene.windows.first?.makeKeyAndVisible()
                    }
                }
            }
            alertPage.modalPresentationStyle = .overFullScreen
            self.present(alertPage, animated: true, completion: nil)
        }
    }
    
}
