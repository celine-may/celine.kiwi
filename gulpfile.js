// Require
var gulp = require( 'gulp' );
var plumber = require( 'gulp-plumber' );
var notify = require( 'gulp-notify' );
var changed = require( 'gulp-changed' );
var livereload = require( 'gulp-livereload' );
var gutil = require( 'gulp-util' );
var rename = require( 'gulp-rename' );
var sass = require( 'gulp-sass' );
var sourcemaps = require( 'gulp-sourcemaps' );
var autoprefixer = require( 'gulp-autoprefixer' );
var sassLint = require( 'gulp-sass-lint' );
var coffee = require( 'gulp-coffee' );
var coffeelint = require( 'gulp-coffeelint' );
var concat = require( 'gulp-concat' );
var cssnano = require( 'gulp-cssnano' );
var uglify = require( 'gulp-uglify' );
var del = require( 'del' );
var runSequence = require( 'run-sequence' );


// Variables
var app = 'app/';
var src = app + 'src/';
var appAssets = app + 'assets/';
var dist = 'dist/';
var distAssets = dist + 'assets/';


// Options
var coffeeOptions = {
  bare: true,
};
var coffeeLintOptions = {
  optFile: 'coffeelint.json',
};
var uglifyOptions = {
  compress: {
    drop_console: true,
  },
};
var renameOptions = {
  suffix: '.min',
};

var onError = function(error) {
  notify.onError({
    title: "<%= error.plugin %> error",
    message:  "Error: <%= error.message %>",
    sound:    "Sosumi"
  }) (error);
  this.emit('end');
};

// TASKS
// Clean
gulp.task('clean:app', function() {
  return del([
    appAssets + 'css/**/*.css',
    appAssets + 'js/**/*.js',
  ]);
});

gulp.task('clean:dist', function() {
  return del([
    distAssets,
    dist + 'controllers',
    dist + 'views',
  ]);
});

// PHP
gulp.task('phpWatch', function() {
  return gulp
    .src( app + '**/*.php' )
    .pipe( livereload() )
});

// Move css vendor files to the assets
gulp.task( 'cssVendor', function() {
  return gulp
    .src( src + 'css/**/*.css' )
    .pipe( gulp.dest( appAssets + 'css/vendor' ) )
});

// Move js vendor files to the assets
gulp.task( 'jsVendor', function() {
  return gulp
    .src( src + 'js/**/*.js' )
    .pipe( gulp.dest( appAssets + 'js/vendor' ) )
});

// Move php files to dist
gulp.task( 'php', function() {
  return gulp
    .src( [ app + '**/*.php', '!' + app + 'config.php' ] )
    .pipe( gulp.dest( dist ) )
});

// Move font files to dist/assets
gulp.task( 'fonts', function() {
  return gulp
    .src( appAssets + 'fonts/**' )
    .pipe( gulp.dest( distAssets + 'fonts' ) )
});

// Move images to dist/assets
gulp.task( 'images', function() {
  return gulp
    .src( appAssets + 'images/**' )
    .pipe( gulp.dest( distAssets + 'images' ) )
});

// Move videos to dist/assets
gulp.task( 'videos', function() {
  return gulp
    .src( appAssets + 'videos/**' )
    .pipe( gulp.dest( distAssets + 'videos' ) )
});

// Move svgs to dist/assets
gulp.task( 'svgs', function() {
  return gulp
    .src( appAssets + 'svgs/**' )
    .pipe( gulp.dest( distAssets + 'svgs' ) )
});

// SASS
gulp.task( 'sass', function() {
  return gulp
    .src( src + 'sass/*.sass' )
    .pipe( plumber( { errorHandler: onError } ) )
    .pipe( changed( src + 'css', { extension: '.css' } ) )
    .pipe( sourcemaps.init() )
    .pipe( sass({
      errLogToConsole: true,
      outputStyle: 'expanded',
    }))
    .pipe( sourcemaps.write() )
    .pipe( sassLint() )
    .pipe( sassLint.format() )
    .pipe( sassLint.failOnError() )
    .pipe( autoprefixer() )
    .pipe( gulp.dest( appAssets + 'css/build' ) )
    .pipe( livereload() )
});

// CSS Concat
gulp.task( 'cssconcat', function() {
  return gulp
    .src( [appAssets + 'css/vendor/*.css', '!' + appAssets + 'css/build/lte-ie9.css', appAssets + 'css/build/*.css'] )
    .pipe( concat( 'application.css' ) )
    .pipe( gulp.dest( appAssets + 'css' ) )
});

gulp.task( 'lte-ie9-css', function() {
  return gulp
    .src( appAssets + 'css/build/lte-ie9.css' )
    .pipe( gulp.dest( appAssets + 'css' ) )
});

// CSS Minification
gulp.task( 'cssnano', function() {
  return gulp
    .src( appAssets + 'css/*.css' )
    .pipe( cssnano({
      safe: true
    }) )
    .pipe( rename( renameOptions ) )
    .pipe( gulp.dest( distAssets + 'stylesheets' ) )
});

// CoffeeScript
gulp.task( 'coffee', function() {
  gulp
    .src( src + 'coffee/**/*.coffee' )
    .pipe( plumber( { errorHandler: onError } ) )
    .pipe( changed( src + 'js', { extension: '.js' } ) )
    .pipe( coffeelint( coffeeLintOptions ) )
    .pipe( coffeelint.reporter() )
    .pipe( sourcemaps.init() )
    .pipe( coffee( coffeeOptions ).on( 'error', gutil.log ) )
    .pipe( sourcemaps.write() )
    .pipe( gulp.dest( appAssets + 'js/build' ) )
    .pipe( livereload() )
});

// JS Concat
gulp.task( 'jsconcat', function() {
  return gulp
    .src( [ appAssets + 'js/vendor/*.js', '!' + appAssets + 'js/build/lte-ie9.js', appAssets + 'js/build/**/*.js' ] )
    .pipe( concat( 'application.js' ) )
    .pipe( gulp.dest( appAssets + 'js' ) )
});

gulp.task( 'lte-ie9-js', function() {
  return gulp
    .src( appAssets + 'js/build/lte-ie9.js' )
    .pipe( gulp.dest( appAssets + 'js' ) )
});

// JS Uglify
gulp.task( 'uglify', function() {
  return gulp
    .src( appAssets + 'js/*.js' )
    .pipe( uglify( uglifyOptions ) )
    .pipe( rename( renameOptions ) )
    .pipe( gulp.dest( distAssets + 'javascripts' ) )
});

// Watch
gulp.task( 'watch', function() {
  livereload.listen();
  gulp.watch( app + '**/*.php', ['phpWatch'] );
  gulp.watch( src + 'sass/**/*.sass', ['sass'] );
  gulp.watch( src + 'coffee/**/*.coffee', ['coffee'] );
});

// Development
gulp.task( 'default', function(callback) {
  runSequence( 'clean:app', 'cssVendor', 'jsVendor',
    [ 'sass', 'coffee', 'watch' ],
    callback
  )
});

// Production
gulp.task( 'prod', function(callback) {
  runSequence( 'clean:dist',
    [ 'php', 'fonts', 'images', 'videos', 'svgs', 'cssconcat', 'lte-ie9-css', 'jsconcat', 'lte-ie9-js' ],
    [ 'cssnano', 'uglify' ],
    callback
  )
});
