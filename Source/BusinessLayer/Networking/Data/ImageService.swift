//
//  ImageService.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 2/14/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import Foundation
import FirebaseStorage

protocol ImageUploadable {
    func uploadImage(_ img: UIImage, identifier: String, completion: @escaping(Result<URL, ImageServiceError>) -> Void)
}

protocol ImageDownloadable {
    func getImage(by stringUrl: String?, completion: @escaping (Result<UIImage, ImageServiceError>) -> Void)
}

typealias ImageServiceType = ImageUploadable & ImageDownloadable

class ImageService: ImageServiceType {

    private enum Constants: String {
        case avatarImages
    }
    private let storageImages = Storage
        .storage()
        .reference()
        .child(Constants.avatarImages.rawValue)

    private var imageCache: [URL: UIImage] = [:]

    private let syncQueue = DispatchQueue(label: "com.familyapp.imageservice.syncqueue")
    private func addCachedImage(withUrl url: URL, image: UIImage) {
        syncQueue.sync {
            imageCache[url] = image
        }
    }

    private func getCachedImage(byUrl url: URL) -> UIImage? {
        var cachedImage: UIImage?
        syncQueue.sync {
            cachedImage = imageCache[url]
        }
        return cachedImage
    }

    func uploadImage(_ img: UIImage, identifier: String, completion: @escaping (Result<URL, ImageServiceError>) -> Void) {
        if identifier.isEmpty { completion(.failure(.userIdEmpty)); return }
        let userAvatarImageRef = storageImages.child("/\(identifier)")
        guard let data = img.pngData() else { completion(.failure(.unknown)); return }
        userAvatarImageRef.putData(data, metadata: nil) { (_, error) in
            guard let error = error else {
                userAvatarImageRef.downloadURL(completion: { (url, error) in
                    guard let error = error else {
                        guard let dowmloadURL = url else { return }
                        completion(.success(dowmloadURL))
                        return
                    }
                    let err = ImageServiceError.getImageServiceError(from: error)
                    completion(.failure(err))
                })
                return
            }
            let err = ImageServiceError.getImageServiceError(from: error)
            completion(.failure(err))
        }
    }

    func getImage(by stringUrl: String?, completion: @escaping (Result<UIImage, ImageServiceError>) -> Void) {
        guard let stringUrl = stringUrl else { completion(.failure(.invalidURL)); return }
        guard let url = URL(string: stringUrl) else { completion(.failure(.invalidURL)); return }

        if let cachedImage = getCachedImage(byUrl: url) {
            completion(.success(cachedImage))
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] (data, _, error) in
            if error == nil {
                guard let data = data else { completion(.failure(.failedToDownloadData)); return }

                guard let image = UIImage(data: data) else { completion(.failure(.invalidData)); return }
                self?.addCachedImage(withUrl: url, image: image)
                completion(.success(image))
                return
            } else {
                completion(.failure(.failedToDownloadData))
            }
            }.resume()
    }
}

