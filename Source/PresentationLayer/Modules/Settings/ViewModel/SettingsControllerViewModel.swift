//
//  SettingsControllerViewModel.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 2/12/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import Foundation
import FirebaseAuth

final class SettingsControllerViewModel {

    // MARK: Properties

    private lazy var cellViewModels = setupCellViewModels()
    private var userService: UserService
    private var imageService: ImageService

    lazy var sections: [SettingsSection] = [.firstSection, .secondSection]

    var numberOfCellViewModels: Int {
        return cellViewModels.count
    }

    var numberOfSections: Int {
        return sections.count
    }


    init(
        userService: UserService,
        imageService: ImageService
        ) {
        self.userService = userService
        self.imageService = imageService
    }

    // MARK: Callbacks

    var didCatchError: ((String) -> (Void))?

    // MARK: Methods

    func getUserInfo(completion: @escaping (UserInfoHeaderViewModel?) -> Void) {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return completion(nil) }
        userService.getById(
            userId: currentUserId
            )
        { [weak self] responseResult in
            switch responseResult {

            case .success(let user):
                self?.imageService.getImage(
                    by: user.avatarImgURL)
                { responseResult in
                    switch responseResult {

                    case .success(let image):
                        completion(UserInfoHeaderViewModel(
                            image: image,
                            name: user.name,
                            location: user.latitude
                            )
                        )
                    case .failure(_):
                        completion(UserInfoHeaderViewModel(
                            image: nil,
                            name: user.name,
                            location: user.latitude
                            )
                        )
                    }
                }
            case .failure(_):
                completion(nil)
            }

        }
        //        { [weak self] responseResult in
        //            switch responseResult {
        //
        //            case .success(let user):
        //                self?.imageService
        //                    .getImage(by: user.avatarImgURL) { [weak self] (imgResult) in
        //                        guard let strongSelf = self else { return }
        //                        switch imgResult {
        //                        case .success(let image):
        //                            completion(UserInfoHeaderViewModel(image: image,
        //                                                               name: user.name,
        //                                                               location: user.latitude)
        //                        case .failure:
        //                            return }
        //                }
        //                )
        //            case .failure(_):
        //                completion(nil)
        //            }
    }


    private func getCurrentUserImg(for user: User) {

    }

    func getCellViewModel(sectionindex: Int, rowIndex: Int) -> SettingsTableCellViewModel {
        return cellViewModels[sectionindex][rowIndex]
    }

    func getNumberOfRowsForSection(sectionIndex: Int) -> Int {
        return cellViewModels[sectionIndex].count
    }

    func selectCellViewModel(sectionindex: Int, rowIndex: Int) {
        guard rowIndex >= 0 && rowIndex < cellViewModels[sectionindex].count else {return}
        //        let catDetail = CatDetailViewModel(name: cellViewModels[index].name,
        //                                           text: cellViewModels[index].text)
        //        showCatDetail.onNext(catDetail)
    }

    private func setupCellViewModels() -> [[SettingsTableCellViewModel]] {

        let notificationsCellViewModel = SettingsTableCellViewModel(
            title: "Notifications and Sounds",
            subtitle: "",
            image: R.image.notification()!
        )

        let appearanceCellVieModel = SettingsTableCellViewModel(
            title: "Appearance",
            subtitle:"" ,
            image: R.image.appearance()!
        )

        let languageCellVieModel = SettingsTableCellViewModel(
            title: "Language",
            subtitle: "English" ,
            image: R.image.language()!
        )

        let reportBugCellVieModel = SettingsTableCellViewModel(
            title: "Report a bug",
            subtitle: "",
            image: R.image.bug()!
        )

        let aboutUsCellVieModel = SettingsTableCellViewModel(
            title: "About us",
            subtitle: "",
            image: R.image.aboutus()!
        )

        return [
            [
                notificationsCellViewModel,
                appearanceCellVieModel,
                languageCellVieModel
            ],
            [
                reportBugCellVieModel,
                aboutUsCellVieModel
            ]
        ]
    }
}
