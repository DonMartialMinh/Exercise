//
//  Constants.swift
//  Exercise
//
//  Created by Vo Minh Don on 10/10/21.
//

import Foundation

public struct Constants {
    struct NavigationTitle {
        static let variation = "Select a variation"
        static let photoSelect = "Select a photo"
        static let design = "Design and edit"
        static let confirm = "Confirmation of design"
    }
    struct Alert {
        static let photoAccessTitle = "Enable photos access?"
        static let photoAccessMessage = "To use this feature you must enable photos access in settings"
        static let unselectImageTitle = "Unselected item?"
        static let unselectImageMessage = "Going back will undo the selection you made"
        static let goBack = "Go back"
        static let settings = "Settings"
        static let cancel = "Cancel"
    }
    struct Design {
        struct Event {
            static let add = "addFavoriteDesign"
            static let delete = "deleteFavoriteDesign"
            static let check = "isFavoriteDesign"
            static let setFirebasefunnel = "setFirebaseFunnels"
            static let select = "handleDesignSelected"
        }
        struct Properties {
            static let code = "code"
            static let colorCode = "color_code"
            static let photoCount = "photo_count"
            static let greetingType = "greeting_type"
        }
    }
    static let imageCellIdentifier = "ImageCell"
    static let categoryCellIdentifier = "CategoryCell"
    static let backBarButtonTittle = "Back"
    static let nextBarButtonTitle = "Next"
    static let nextBarButtonEndTitle = "Proceed to order"
    static let hubLoading = "Loading"
    static let savedCategoryTitle = "Saved"
    static let favoriteDesignskey = "favDesignArray"
    static let goToVariationScreenSegue = "GoToVariationScreen"

}
