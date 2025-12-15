# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"

# Sneat template assets
pin "jquery", to: "vendor/jquery.js"
pin "popper", to: "vendor/popper.js"
pin "perfect-scrollbar", to: "vendor/perfect-scrollbar.js"
pin "helpers", to: "sneat/helpers.js"
pin "bootstrap", to: "sneat/bootstrap.js"
pin "menu", to: "sneat/menu.js"
pin "config", to: "sneat/config.js"
pin "main", to: "sneat/main.js"
pin "dropdowns", to: "dropdowns.js"
