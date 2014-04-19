angular.module("App").service "UserService", [
  "User"
  "$http"
  (User, $http) ->

    service =
      getUser: (cb) ->
        User.get {}, (user) -> cb user
]
