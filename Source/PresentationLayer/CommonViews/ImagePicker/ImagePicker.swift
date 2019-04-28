//
//  ImagePicker.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 2/16/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import UIKit
import Permission

final class ImagePicker:
    NSObject,
    UIImagePickerControllerDelegate,
UINavigationControllerDelegate {

    // MARK: - Types

    enum Error: LocalizedError {

        // MARK: Cases

        case cameraNotAvailable
        case photoLibraryNotAvailable

        // MARK: Properties

        var representation: String {
            switch self {
            case .cameraNotAvailable:
                return "No Camera Available"

            case .photoLibraryNotAvailable:
                return "No Photo Library Available"
            }
        }
    }

    typealias DidPickImage = (UIImage) -> Void


    // MARK: - Properties
    // MARK: Callbacks

    var didPickImage: DidPickImage?


    // MARK: - Initialization

    init(_ configuration: @escaping (ImagePicker) -> Void) {
        super.init()

        configuration(self)
    }


    // MARK: - Appearance

    func show(
        actionSheet: ImagePickerActionSheet,
        allowsEditing: Bool = true,
        from controller: UIViewController,
        animated: Bool = true
        ) {
        actionSheet.show(
            from: controller,
            animated: animated
        )
    }

    func show(
        allowsEditing: Bool = true,
        from controller: UIViewController,
        animated: Bool = true
        ) {
        let actionSheet = ImagePickerActionSheet(
            takePhotoAction: .init(name: "Take photo") {
                let permission: Permission = .camera
                permission.request { status in
                    if status == .authorized {
                        try? self.showTakePhoto(allowsEditing: allowsEditing, from: controller, animated: animated)
                    }
                }
            },
            choosePhotoAction: .init(name: "Choose photo") {
                let permission: Permission = .photos
                permission.request { status in
                    if status == .authorized {
                        try? self.showChoosePhoto(allowsEditing: allowsEditing, from: controller, animated: animated)
                    }
                }
            },
            cancelAction: .init(name: "Cancel") {

            }
        )

        show(
            actionSheet: actionSheet,
            allowsEditing: allowsEditing,
            from: controller,
            animated: animated
        )
    }


    // MARK: - Appearance

    func showTakePhoto(
        allowsEditing: Bool = true,
        from controller: UIViewController,
        animated: Bool
        ) throws {
        if !performOperation(for: .camera, allowsEditing: allowsEditing, animated: animated, from: controller) {
            throw Error.cameraNotAvailable
        }
    }

    func showChoosePhoto(
        allowsEditing: Bool = true,
        from controller: UIViewController,
        animated: Bool
        ) throws {
        if !performOperation(for: .photoLibrary, allowsEditing: allowsEditing, animated: animated, from: controller) {
            throw Error.photoLibraryNotAvailable
        }
    }

    private func performOperation(
        for sourceType: UIImagePickerController.SourceType,
        allowsEditing: Bool,
        animated: Bool,
        from controller: UIViewController
        ) -> Bool {
        if !UIImagePickerController.isSourceTypeAvailable(sourceType) {
            return false
        }

        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = sourceType
        imagePickerController.allowsEditing = allowsEditing
        imagePickerController.modalPresentationStyle = .overFullScreen

        let navigationController = controller.navigationController

        imagePickerController.navigationBar.tintColor = .white
        imagePickerController.navigationBar.barTintColor = navigationController?.navigationBar.barTintColor
        imagePickerController.navigationBar.barStyle = navigationController?.navigationBar.barStyle ?? .black
        imagePickerController.navigationBar.titleTextAttributes = navigationController?.navigationBar.titleTextAttributes
        imagePickerController.navigationBar.isTranslucent = navigationController?.navigationBar.isTranslucent == true

        controller.present(imagePickerController, animated: animated)

        return true
    }


    // MARK: - UIImagePickerDelegate

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
        ) {

        picker.dismiss(animated: true) { [unowned self] in
            let optionalImage = picker.allowsEditing
                ? info[.editedImage] as? UIImage
                : info[.originalImage] as? UIImage

            guard let image = optionalImage else {
                return
            }

            self.didPickImage?(image)
        }
    }
}
