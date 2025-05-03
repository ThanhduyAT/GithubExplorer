//
//  BaseCoordinator.swift
//  Common
//
//  Created by Duy Thanh on 1/5/25.
//
import SwiftUI

public typealias BaseCoordinatorProtocol =
    StackNavigatable &
    SheetPresentable &
    FullScreenCoverPresentable

public protocol StackNavigatable: AnyObject {
    associatedtype ScreenType: Identifiable & Hashable
    var path: NavigationPath { get set }
    func push(_ screen: ScreenType)
    func pop()
    func popToRoot()
}

public protocol SheetPresentable: AnyObject {
    associatedtype SheetType: Identifiable & Hashable
    var sheet: SheetType? { get set }
    func presentSheet(_ sheet: SheetType)
    func dismissSheet()
}

public protocol FullScreenCoverPresentable: AnyObject {
    associatedtype FullScreenType: Identifiable & Hashable
    var fullScreenCover: FullScreenType? { get set }
    func presentFullScreenCover(_ fullScreenCover: FullScreenType)
    func dismissFullScreenCover()
}
