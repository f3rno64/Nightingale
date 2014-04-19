gulp = require "gulp"
coffee = require "gulp-coffee"
rename = require "gulp-rename"
stylus = require "gulp-stylus"
minifycss = require "gulp-minify-css"
nodemon = require "gulp-nodemon"

paths =
  lib: "src/client/app/**/*.coffee"
  styl: "src/client/styles/style.styl"

# Compile stylus
gulp.task "stylus", ->
  gulp.src paths.styl
  .pipe stylus "include css": true
  .pipe rename suffix: ".min"
  .pipe minifycss()
  .pipe gulp.dest "src/client/css"

# Compile clientside coffeescript
gulp.task "coffee", ->
  gulp.src paths.lib
  .pipe coffee()
  .pipe gulp.dest "src/client/js"

# Rerun the task when a file changes
gulp.task "watch", ->
  gulp.watch paths.lib, ["coffee"]
  gulp.watch paths.styl, ["stylus"]

# Spin-up a development server
gulp.task "server", ->
  nodemon
    script: "src/server/server.coffee"
    ignore: "src/client/**"

# Build all of the assets
gulp.task "build", ["stylus", "coffee"]

# Run in development
gulp.task "develop", ["build", "watch", "server"]

# The default task (called when you run `gulp` from cli)
gulp.task "default", ["build"]
