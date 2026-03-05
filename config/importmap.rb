# Pin npm packages by running ./bin/importmap

pin "application"
pin "@popperjs/core", to: "https://ga.jspm.io/npm:@popperjs/core@2.11.6/dist/umd/popper.min.js"
pin "bootstrap", to: "https://ga.jspm.io/npm:bootstrap@5.3.2/dist/js/bootstrap.js"
pin "blacklight", to: "blacklight/index.js"
pin "blacklight-range-limit", to: "blacklight-range-limit/index.js"
pin "grenander/search_sources_menu", to: "grenander/search_sources_menu.js"

# chart.js is dependency of blacklight-range-limit, currently is not working
# as vendored importmaps, but instead must be pinned to CDN.
pin "chart.js", to: "https://ga.jspm.io/npm:chart.js@4.2.0/dist/chart.js"
pin "@kurkle/color", to: "https://ga.jspm.io/npm:@kurkle/color@0.3.2/dist/color.esm.js"
