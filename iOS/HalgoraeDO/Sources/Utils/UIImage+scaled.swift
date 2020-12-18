//
// UIImage+scaled.swift
// HalgoraeDO
//
// Created by woong on 2020/11/26.
//
import UIKit.UIImage

extension UIImage {
  /// image를 주어진 size로 렌더링해서 반환합니다.
  /// - Parameters:
  ///  - size: 새로 draw할 size
  ///  - renderingMode: default: alwaysTemplate
  func scaled(to size: CGSize, renderingMode: RenderingMode = .alwaysTemplate) -> UIImage? {
    UIGraphicsBeginImageContext(size)
    self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage?.withRenderingMode(renderingMode)
  }
}
