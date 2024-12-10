//
//  ScrollView+Rx.swift
//  Common
//
//  Created by Hung Nguyen on 10/12/2024.
//

import Foundation
import RxSwift
import RxCocoa

public extension Reactive where Base: UIScrollView {

    var reachedBottom: ControlEvent<Void> {
        let observable = contentOffset.flatMapLatest { [weak base] _ -> Observable<Void> in
            guard let scrollView = base else {
                return Observable.empty()
            }
            let currentOffset = scrollView.contentOffset.y
            let maximunOffset = scrollView.contentSize.height - scrollView.frame.size.height

            if maximunOffset - currentOffset <= 10 {
                return Observable.just(())
            }
            return Observable.empty()
        }

        return ControlEvent(events: observable)
    }

    var reachedTop: ControlEvent<Void> {
        let observable = contentOffset.flatMapLatest { contentOffset -> Observable<Void> in
            if contentOffset.y <= 0 {
                return Observable.just(())
            }
            return Observable.empty()
        }

        return ControlEvent(events: observable)
    }

    var contentSize: Observable<CGSize> {
        observe(CGSize.self, #keyPath(UIScrollView.contentSize)).unwrap()
    }
}
