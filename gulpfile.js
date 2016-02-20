// Require
var gulp = require( 'gulp' );
var changed = require( 'gulp-changed' );
var livereload = require( 'gulp-livereload' );
var gutil = require( 'gulp-util' );
var sass = require( 'gulp-sass' );
var sourcemaps = require( 'gulp-sourcemaps' );
var autoprefixer = require( 'gulp-autoprefixer' );
var sassLint = require( 'gulp-sass-lint' );
var coffee = require( 'gulp-coffee' );
var coffeelint = require( 'gulp-coffeelint' );
var del = require( 'del' );
var runSequence = require( 'run-sequence' );


// Variables
var app = 'app/'
var src = app + 'src/';
var appAssets = app + 'assets/';

// Options
var sassOptions = {
  errLogToConsole: true,
  outputStyle: 'expanded'
};
var coffeeOptions = {
  bare: true,
};
var coffeeLintOptions = {
  optFile: 'coffeelint.json',
};

// TASKS
// Clean
gulp.task('clean:src', function() {
  return del([
    appAssets + 'css/**/*.css',
    appAssets + 'js/**/*.js',
  ]);
});

// PHP
gulp.task('php', function() {
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

// SASS
gulp.task( 'sass', function() {
  return gulp
    .src( src + 'sass/*.sass' )
    .pipe( changed( src + 'css', { extension: '.css' } ) )
    .pipe( sourcemaps.init() )
    .pipe( sass( sassOptions ).on( 'error', sass.logError ) )
    .pipe( sourcemaps.write() )
    .pipe( autoprefixer() )
    .pipe( sassLint() )
    .pipe( sassLint.format() )
    .pipe( sassLint.failOnError() )
    .pipe( gulp.dest( appAssets + 'css' ) )
    .pipe( livereload() )
});

// CoffeeScript
gulp.task( 'coffee', function() {
  gulp
    .src( src + 'coffee/**/*.coffee' )
    .pipe( changed( src + 'js', { extension: '.js' } ) )
    .pipe( coffeelint( coffeeLintOptions ) )
    .pipe( coffeelint.reporter() )
    .pipe( sourcemaps.init() )
    .pipe( coffee( coffeeOptions ).on( 'error', gutil.log ) )
    .pipe( sourcemaps.write() )
    .pipe( gulp.dest( appAssets + 'js' ) )
    .pipe( livereload() )
});

// Watch
gulp.task( 'watch', function() {
  livereload.listen();
  gulp.watch( app + '**/*.php', ['php'] );
  gulp.watch( src + 'sass/**/*.sass', ['sass'] );
  gulp.watch( src + 'coffee/**/*.coffee', ['coffee'] );
});

// Development
gulp.task( 'default', function(callback) {
  runSequence( 'clean:src', 'cssVendor', 'jsVendor',
    [ 'sass', 'coffee', 'watch' ],
    callback
  )
})
