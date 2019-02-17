//
//  ImagePickerActionSheet.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 2/16/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import UIKit

final class ImagePickerActionSheet {

    // MARK: - Properties
    // MARK: Content

    let title: String
    let message: String

    let takePhotoAction: ImagePickerAction
    let choosePhotoAction: ImagePickerAction
    let cancelAction: ImagePickerAction

    // MARK: Callbacks

    var willTakePhoto: EmptyClosure?
    var willChoosePhoto: EmptyClosure?


    // MARK: - Initialization

    init(
        title: String = "Photo",
        message: String = "Select photo from",
        takePhotoAction: ImagePickerAction,
        choosePhotoAction: ImagePickerAction,
        cancelAction: ImagePickerAction
        ) {
        self.title = title
        self.message = message
        self.takePhotoAction = takePhotoAction
        self.choosePhotoAction = choosePhotoAction
        self.cancelAction = cancelAction
    }


    // MARK: - Apperance

    func show(
        from controller: UIViewController,
        animated: Bool = true
        ) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .actionSheet
        )

        let cameraAction = UIAlertAction(title: takePhotoAction.name, style: .default) { _ in
            self.takePhotoAction.didPress?()
        }

        let photoLibraryAction = UIAlertAction(title: choosePhotoAction.name, style: .default) { _ in
            self.choosePhotoAction.didPress?()
        }

        let cancelAction = UIAlertAction(title: self.cancelAction.name, style: .cancel) { _ in
            self.cancelAction.didPress?()
        }

        alertController.addAction(cameraAction)
        alertController.addAction(photoLibraryAction)
        alertController.addAction(cancelAction)

        controller.present(alertController, animated: animated)
    }
}

