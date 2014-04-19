angular.module("App").service "TagService", [
  "Tag"
  (Tag) ->

    cache = new ServiceCache

    service =
      getAllTags: (cb) ->
        Tag.query (tags) =>

          cache.clear()
          cache.setMultiple tags

          cb tags

      getTag: (id, cb) ->
        return cb cache.getItem(id) if cache.hasItem(id)

        Tag.get id: id, (tag) =>
          cache.setItem tag
          cb tag

      save: (tag, cb, errcb) ->
        cache.clearItem tag.id

        tag.$save().then ->
          cache.setItem tag
          cb tag if cb
        , ->
          errcb()
]
