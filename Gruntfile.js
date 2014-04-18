module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({
    concurrent: {
      dev: {
        tasks: ['nodemon','compass','watch'],
        options: {
          logConcurrentOutput: true
        }
      }
    },    
    watch: {
      src:{
        files: ['public/javascripts/src/*.coffee'],
        tasks: 'newer:coffee',
      },
    livereload: {
      files: ['public/stylesheets/*.css', 'public/javascripts/app/*js'],
      options: { livereload: true }
      }
      // css:{
      //   files: ['public/stylesheets/sass/*.scss'],
      //   tasks: 'compass'
      // }
    },
    coffee: {
      glob_to_multiple: {
        expand: true,
        flatten: true,
        // cwd: 'public/javascripts/app/',
        src: ['public/javascripts/src/*.coffee'],
        dest: 'public/javascripts/app/',
        ext: '.js',
      },
    },
    compass: {
      dist: {
        options: {
          config: 'public/stylesheets/config.rb',
          sassDir: 'public/stylesheets/sass',
          cssDir: 'public/stylesheets/',
          watch: true
        }
      }
    },
  nodemon: {
    dev: {
      script: 'app.coffee',
      options: {
        // nodeArgs: ['--debug'],
        env: {
          PORT: '5000'
        },
        watch: ['app.coffee, routes'],
        // omit this property if you aren't serving HTML files and 
        // don't want to open a browser tab on start
        // callback: function (nodemon) {
        //   nodemon.on('log', function (event) {
        //     console.log(event.colour);
        //   });

        //   // opens browser on initial server start
        //   nodemon.on('config:update', function () {
        //     // Delay before server listens on port
        //     setTimeout(function() {
        //       require('open')('http://localhost:5000');
        //     }, 1000);
        //   });

        //   // refreshes browser when server reboots
        //   nodemon.on('restart', function () {
        //     // Delay before server listens on port
        //     setTimeout(function() {
        //       require('fs').writeFileSync('.rebooted', 'rebooted');
        //     }, 1000);
        //   });
        // }
      }
    }
  },

  });

  grunt.loadNpmTasks('grunt-contrib-compass');
  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks("grunt-foreman");
  grunt.loadNpmTasks('grunt-nodemon');
  grunt.loadNpmTasks('grunt-concurrent');
  grunt.loadNpmTasks('grunt-newer');

  // Default task.
  grunt.registerTask('default', ['coffee','concurrent']);
};