'use strict';

module.exports = function (grunt) {

	require('jit-grunt')(grunt, {
	   coffee:  'grunt-contrib-coffee'
	});

	grunt.initConfig({
	    coffee: {
	      glob_to_multiple: {
	          expand: true,
	          flatten: false,
	          cwd: '',
	          src: ['*.coffee', 'tests/*.coffee'],
	          dest: '',
	          ext: '.js',
	          extDot: 'last'
	      }
	    },

		watch: {
			coffee: {
				files: ['*.coffee', 'tests/*.coffee'],
				tasks: ['coffee:glob_to_multiple']
			},

			mochaTest: {
	        	files: ['tests/*.spec.js'],
	        	tasks: ['env:test', 'mochaTest']
	      	}
	    },

	    mochaTest: {
	      options: {
	        reporter: 'spec'
	      },
	      src: ['tests/*.spec.js']
	    },

	    env: {
	      test: {
	        NODE_ENV: 'test'
	      },
	      prod: {
	        NODE_ENV: 'production'
	      }
	    }
	});

	grunt.registerTask('test', function(target) {
		return grunt.task.run([
			'coffee',
			'mochaTest'
		]);
	});
};