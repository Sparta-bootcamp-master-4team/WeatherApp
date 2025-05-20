//
//  ViewController+.swift
//  WeatherApp
//
//  Created by 양원식 on 5/20/25.
//
import UIKit

extension UIViewController {

    /// 현재 뷰 컨트롤러에서 간단한 경고(Alert)를 표시합니다.
    ///
    /// - Parameters:
    ///   - title: 알림창의 제목 텍스트입니다.
    ///   - message: 알림창에 표시할 본문 메시지입니다.
    ///   - cancellable: `true`일 경우 "취소" 버튼이 추가됩니다. 기본값은 `false`입니다.
    ///   - completionHandler: "확인" 버튼을 눌렀을 때 실행될 클로저입니다. 기본값은 빈 클로저입니다.
    ///
    /// - Note: 이 메서드는 `UIAlertController`를 간편하게 사용하는 확장 도구입니다.
    /// - Example:
    /// ```
    /// showAlert(title: "오류", message: "네트워크 연결에 실패했습니다.")
    ///
    /// showAlert(title: "삭제", message: "정말 삭제하시겠습니까?", cancellable: true) {
    ///     // 삭제 처리 로직
    /// }
    /// ```
    func showAlert(title: String,
                   message: String,
                   cancellable: Bool = false,
                   completionHandler: @escaping () -> Void = { }) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in completionHandler() }))
        if cancellable {
            alert.addAction(UIAlertAction(title: "취소", style: .destructive, handler: nil))
        }
        self.present(alert, animated: true)
    }
}
