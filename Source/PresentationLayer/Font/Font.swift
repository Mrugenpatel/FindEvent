//
//  Font.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 2/6/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import UIKit

struct Font {

    // MARK: - Initialization

    private init() { }


    // MARK: - Appearance

    static func bold(of size: CGFloat) -> UIFont {
        return R.font.openSansBold(size: size) ?? .systemFont(ofSize: size, weight: .bold)
    }

    static func boldItalic(of size: CGFloat) -> UIFont {
        return R.font.openSansBoldItalic(size: size) ?? .systemFont(ofSize: size, weight: .bold)
    }

    static func extrabold(of size: CGFloat) -> UIFont {
        return R.font.openSansExtrabold(size: size) ?? .systemFont(ofSize: size, weight: .bold)
    }

    static func extraboldItalic(of size: CGFloat) -> UIFont {
        return R.font.openSansExtraboldItalic(size: size) ?? .systemFont(ofSize: size, weight: .bold)
    }

    static func italic(of size: CGFloat) -> UIFont {
        return R.font.openSansItalic(size: size) ?? .italicSystemFont(ofSize: size)
    }

    static func light(of size: CGFloat) -> UIFont {
        return R.font.openSansLight(size: size) ?? .systemFont(ofSize: size, weight: .light)
    }

    static func lightItalic(of size: CGFloat) -> UIFont {
        return R.font.openSansLightItalic(size: size) ?? .systemFont(ofSize: size, weight: .light)
    }

    static func regular(of size: CGFloat) -> UIFont {
        return R.font.openSans(size: size) ?? .systemFont(ofSize: size)
    }

    static func semibold(of size: CGFloat) -> UIFont {
        return R.font.openSansSemibold(size: size) ?? .systemFont(ofSize: size, weight: .semibold)
    }

    static func semiboldItalic(of size: CGFloat) -> UIFont {
        return R.font.openSansSemiboldItalic(size: size) ?? .systemFont(ofSize: size, weight: .semibold)
    }
}

