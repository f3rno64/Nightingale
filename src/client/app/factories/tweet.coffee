angular.module("App").factory "Tweet", ($resource) ->
  $resource "/api/v1/tweets/:id",
  { id: "@id" },
  { consume: {
      method: "POST"
      params: consume: true
    }
  }
