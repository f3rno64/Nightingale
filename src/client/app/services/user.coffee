angular.module("App").service "UserService", [
  "User"
  (User) ->

    service =
      getUser: (cb) ->
        User.get {}, (user) -> cb user
]
