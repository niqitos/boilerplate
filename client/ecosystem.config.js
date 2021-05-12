const { join } = require('path')

module.exports = {
  apps: [
    {
      name: 'ClientApp',
      exec_mode: 'cluster',
      instances: 'max', // Or a number of instances
      script: './node_modules/nuxt/bin/nuxt.js',
      args: `-c ${join(__dirname, 'nuxt.config.js')}`,
      cwd: './'
    }
  ]
}
