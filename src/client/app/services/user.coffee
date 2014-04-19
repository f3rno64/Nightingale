# This currently uses localStorage; Needs to be updated to use a persistent
# API in the future...

angular.module("App").service "UserService", [->

  service =
    getUser: ->
      localStorage.getItem "user"

    ###
    # Ensures both that a user is logged in
    #
    # @return [Boolean] loggedIn
    ###
    loggedIn: ->
      user = localStorage.getItem "user"
      user and user.handle
]
