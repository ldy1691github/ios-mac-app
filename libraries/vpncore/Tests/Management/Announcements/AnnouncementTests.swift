//
//  Created on 26/09/2022.
//
//  Copyright (c) 2022 Proton AG
//
//  ProtonVPN is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  ProtonVPN is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with ProtonVPN.  If not, see <https://www.gnu.org/licenses/>.

import vpncore
import XCTest
@testable import vpncore

class AnnouncementTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testAnnouncementFullScreenImage() {
        let sources: [FullScreenImage.Source] = [.init(url: "www.example.com", type: "", width: nil, height: nil),
                                                 .init(url: "www.example2.com", type: "", width: nil, height: nil)]
        let fullScreenImage = FullScreenImage(source: sources, alternativeText: "")
        let offerButton = OfferButton(url: "", text: "", action: .openURL, behaviors: [.autoLogin])
        let offerPanel = OfferPanel(fullScreenImage: fullScreenImage,
                                    button: offerButton)
        let offer = Offer(label: "",
                          icon: "",
                          panel: offerPanel)
        let sut = Announcement(notificationID: "someID",
                               startTime: .distantPast,
                               endTime: .distantFuture,
                               type: .default,
                               offer: offer)

        // Recognizes that it is a full screen image mode
        XCTAssertNotNil(sut.fullScreenImage)
        // Takes the first resource from the list
        XCTAssertEqual(sut.prefetchableImage?.absoluteString, "www.example.com")

        let e = expectation(description: "Correctly reports prefetched assets")
        ImageCacheMock.completionBlockParameterValue = true
        sut.isImagePrefetched(imageCache: ImageCacheFactoryMock()) { isPrefetched in
            if isPrefetched {
                e.fulfill()
            }
        }
        waitForExpectations(timeout: 0.1)

        let e2 = expectation(description: "Correctly reports not prefetched assets")
        ImageCacheMock.completionBlockParameterValue = false
        sut.isImagePrefetched(imageCache: ImageCacheFactoryMock()) { isPrefetched in
            if !isPrefetched {
                e2.fulfill()
            }
        }
        waitForExpectations(timeout: 0.1)
    }
}
