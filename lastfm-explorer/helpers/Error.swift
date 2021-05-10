//
//  Error.swift
//  lastfm-explorer
//
//  Created by Melānija Grunte on 10/05/2021.
//

let justPrintError: ((Error) -> Void) = { error in
    print(error.localizedDescription)
}
