// Generated using Sourcery 1.4.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable all
import RxSwift
import RxCocoa














public class AlbumRepositoryMock: AlbumRepository {
    public init() {}

    //MARK: - getTopAlbums

    public var getTopAlbumsUsernamePeriodPageCallsCount = 0
    public var getTopAlbumsUsernamePeriodPageCalled: Bool {
        return getTopAlbumsUsernamePeriodPageCallsCount > 0
    }
    public var getTopAlbumsUsernamePeriodPageReceivedArguments: (username: String, period: Period, page: Int?)?
    public var getTopAlbumsUsernamePeriodPageReceivedInvocations: [(username: String, period: Period, page: Int?)] = []
    public var getTopAlbumsUsernamePeriodPageReturnValue: Single<TopAlbums>!
    public var getTopAlbumsUsernamePeriodPageClosure: ((String, Period, Int?) -> Single<TopAlbums>)?

    public func getTopAlbums(username: String, period: Period, page: Int?) -> Single<TopAlbums> {
        getTopAlbumsUsernamePeriodPageCallsCount += 1
        getTopAlbumsUsernamePeriodPageReceivedArguments = (username: username, period: period, page: page)
        getTopAlbumsUsernamePeriodPageReceivedInvocations.append((username: username, period: period, page: page))
        return getTopAlbumsUsernamePeriodPageClosure.map({ $0(username, period, page) }) ?? getTopAlbumsUsernamePeriodPageReturnValue
    }

    //MARK: - getAlbumDetails

    public var getAlbumDetailsIdUsernameCallsCount = 0
    public var getAlbumDetailsIdUsernameCalled: Bool {
        return getAlbumDetailsIdUsernameCallsCount > 0
    }
    public var getAlbumDetailsIdUsernameReceivedArguments: (id: String, username: String)?
    public var getAlbumDetailsIdUsernameReceivedInvocations: [(id: String, username: String)] = []
    public var getAlbumDetailsIdUsernameReturnValue: Single<ExtendedAlbum>!
    public var getAlbumDetailsIdUsernameClosure: ((String, String) -> Single<ExtendedAlbum>)?

    public func getAlbumDetails(id: String, username: String) -> Single<ExtendedAlbum> {
        getAlbumDetailsIdUsernameCallsCount += 1
        getAlbumDetailsIdUsernameReceivedArguments = (id: id, username: username)
        getAlbumDetailsIdUsernameReceivedInvocations.append((id: id, username: username))
        return getAlbumDetailsIdUsernameClosure.map({ $0(id, username) }) ?? getAlbumDetailsIdUsernameReturnValue
    }

}
public class AuthRepositoryMock: AuthRepository {
    public init() {}
    public var isLoggedIn: Bool {
        get { return underlyingIsLoggedIn }
        set(value) { underlyingIsLoggedIn = value }
    }
    public var underlyingIsLoggedIn: Bool!

    //MARK: - login

    public var loginUsernamePasswordCallsCount = 0
    public var loginUsernamePasswordCalled: Bool {
        return loginUsernamePasswordCallsCount > 0
    }
    public var loginUsernamePasswordReceivedArguments: (username: String, password: String)?
    public var loginUsernamePasswordReceivedInvocations: [(username: String, password: String)] = []
    public var loginUsernamePasswordReturnValue: Single<String>!
    public var loginUsernamePasswordClosure: ((String, String) -> Single<String>)?

    public func login(username: String, password: String) -> Single<String> {
        loginUsernamePasswordCallsCount += 1
        loginUsernamePasswordReceivedArguments = (username: username, password: password)
        loginUsernamePasswordReceivedInvocations.append((username: username, password: password))
        return loginUsernamePasswordClosure.map({ $0(username, password) }) ?? loginUsernamePasswordReturnValue
    }

}
