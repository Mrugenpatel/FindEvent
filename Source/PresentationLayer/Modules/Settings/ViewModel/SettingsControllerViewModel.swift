//
//  SettingsControllerViewModel.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 2/12/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import Foundation

final class SettingsControllerViewModel {

    // MARK: Properties

    private lazy var cellViewModels = setupCellViewModels()
    
    lazy var sections: [SettingsSection] = [.firstSection, .secondSection]

    var numberOfCellViewModels: Int {
        return cellViewModels.count
    }

    var numberOfSections: Int {
        return sections.count
    }

    // MARK: Callbacks



    // MARK: Methods

    func getCellViewModel(atIndex index: Int) -> SettingsTableCellViewModel {
        return cellViewModels[index]
    }

    func selectCellViewModel(atIndex index: Int) {
        guard index >= 0 && index < cellViewModels.count else {return}
//        let catDetail = CatDetailViewModel(name: cellViewModels[index].name,
//                                           text: cellViewModels[index].text)
//        showCatDetail.onNext(catDetail)
    }

    private func setupCellViewModels() -> [SettingsTableCellViewModel] {

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
            notificationsCellViewModel,
            appearanceCellVieModel,
            languageCellVieModel,
            reportBugCellVieModel,
            aboutUsCellVieModel
        ]
    }
}
