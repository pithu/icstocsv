module.exports = function(grunt) {
    grunt.initConfig({
        lint: {
            all: ['lib/**/*.js', 'test/**/*.js', 'grunt.js']
        },

        coffee: {
            app: {
                src: ['lib/**/*.coffee', 'test/**/*.coffee'],
                options: {
                    bare: false
                }
            }
        },

        jshint: {
            options: {
                eqeqeq: false,
                eqnull: true
            },
            globals: {}
        },

        test: {
            all: { src: 'test/**/*NTest.js' }
        }
    });

    grunt.loadNpmTasks('grunt-coffee');

    grunt.registerTask('default', 'coffee lint test');
};
