angular.module("App").service "NotificationService", ["$rootScope", ($rootScope) ->

  notification = {}
  timeout = 2000

  service =
    clearNotification: ->
      notification =
        text: "An authentic twitter drafter"
        color: ""
      @

    getNotification: ->
      notification

    getText: ->
      notification.text

    getColor: ->
      notification.color

    setTimeout: (t) ->
      timeout = t

    setNotification: (text, color, useTimeout) ->
      color ||= ""
      useTimeout ||= true
      notification = text: text, color: color

      if useTimeout
        setTimeout ->
          $rootScope.$apply ->
            service.clearNotification()
        , timeout

      @

  service.clearNotification()
]
