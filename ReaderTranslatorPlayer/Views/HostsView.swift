//
//  HostsView.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 12/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI
import Network

struct HostsView: View {
    class Coordinator: ObservableObject {
        @Published var hosts = [NWBrowser.Result]()
        @Published var status = ConnectionClientStatus.none
    }

    @ObservedObject var coordinator = Coordinator()
    @State var passcode = ""

    init() {
        sharedBrowser = PeerBrowser()
        sharedBrowser?.delegate = coordinator
        sharedBrowser?.startBrowsing()
    }

    var body: some View {
        List {
            TextField("Enter pass code", text: $passcode)
            ForEach(coordinator.hosts, id: \.self) { host in
                Button(
                    action: { self.join(host: host) },
                    label: {
                        HStack {
                            Text(self.hostInfo(host))
                            Spacer()
                            Text(self.coordinator.status.status)
                        }
                })
            }
        }
    }

    private func hostInfo(_ host: NWBrowser.Result) -> String {
        if case let NWEndpoint.service(name: name, type: _, domain: _, interface: _) = host.endpoint {
            return name
        } else {
            return "empty"
        }
    }

    private func join(host: NWBrowser.Result) {
        sharedConnection = PeerConnection(
            endpoint: host.endpoint,
            interface: host.interfaces.first,
            passcode: self.passcode)
        sharedConnection?.delegate = coordinator
        sharedConnection?.startConnection()
    }
}

extension HostsView.Coordinator: PeerBrowserDelegate {
    func refreshResults(results: Set<NWBrowser.Result>) {
        status = .none
        hosts = results.map { $0 }
    }
}

extension HostsView.Coordinator: PeerConnectionDelegate {
    func connectionReady() {
        status = .connected
        sharedConnection?.sendMove("Let's go")
    }

    func connectionFailed() {
        status = .failed(error: "failed")
    }

    func receivedMessage(content: Data?, message: NWProtocolFramer.Message) {
        print("\(#function)")
    }
}

struct HostsView_Previews: PreviewProvider {
    static var previews: some View {
        HostsView()
    }
}
