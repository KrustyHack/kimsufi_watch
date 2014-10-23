request = require "request"
cheerio = require "cheerio"
phantom = require 'phantom'

isAvailable = (ref) ->
    #https://www.kimsufi.com/fr/commande/kimsufi.xml?reference=142sk6
    url = "https://www.kimsufi.com/fr/commande/kimsufi.xml?reference=#{ref}"
    phantom.create (ph) ->
      ph.createPage (page) ->
        page.open url, (status) ->
          console.log "opened page? ", status
          page.evaluate (-> document.title), (result) ->
            console.log 'Page title is ' + result
            ph.exit()

request("http://www.kimsufi.com/fr/index.xml", (error, response, html) ->
    if !error && response.statusCode == 200
        $ = cheerio.load html
        
        server_table = $(".homepage-table")
        row = server_table.find "tr.zone-dedicated-availability"
        row.each((i, element) ->
            reference = $(element).attr('data-ref')
            console.log "Inspecting #{reference}"
            isAvailable reference
            
        )
    else
        console.log error
)