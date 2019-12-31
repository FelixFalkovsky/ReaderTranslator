//
//  FileStore.swift
//  ReaderTranslatorPlayer
//
//  Created by Viktor Kushnerov on 31/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import Foundation

final class FileStore: ObservableObject {
    static let shared = FileStore()
    
    static private var directoryObserver: DirectoryObserver?

    var files: [URL] {
        guard let url = folderUrl else { return [] }

        do {
            return try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
        } catch {
            Logger.log(type: .error, value: error)
            return []
        }
    }

    private let folderUrl: URL? = {
        guard let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return documentsUrl.appendingPathComponent("/Inbox")
    }()

    private init() {
        
    }
    
    func prevFile(file: URL?) -> URL? {
        guard let file = file else { return nil }
        guard let current = files.firstIndex(of: file) else { return nil }
        let index = files.index(before: current)
        
        return files.indices.contains(index) ? files[index] : nil
    }

    func nextFile(file: URL?) -> URL? {
        guard let file = file else { return nil }
        guard let current = files.firstIndex(of: file) else { return nil }
        let index = files.index(after: current)
        
        return files.indices.contains(index) ? files[index] : nil
    }
}

