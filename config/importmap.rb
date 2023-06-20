# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"

# Big thanks to @coorasse for reply and blogpost: 
# https://github.com/twbs/bootstrap-rubygem/issues/228#issuecomment-1011407591
# https://dev.to/coorasse/rails-7-bootstrap-5-and-importmaps-without-nodejs-4g8
pin "popper", to: "popper.js", preload: true 
pin "bootstrap", to: "bootstrap.min.js", preload: true
