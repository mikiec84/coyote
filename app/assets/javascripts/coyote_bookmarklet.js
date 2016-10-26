(function(){
  var coyote = {};
  var CoyoteBookmarklet = {
    visible : true,
    consumer : {
      css : ['/assets/coyote_bookmarklet.css'],
      init: function(){
        //coyote.logError('consumer init');
        //send images to producer
        var $images = $('img');
        var imgs  = [];
        var pageIdCounter = 0;
        var domain = document.domain;
        var protocol = document.location.protocol;
        var href = document.location.href;
        $images.each(function(){
          pageIdCounter += 1;
          imgs.push( {
            "src": $(this)[0].src,
            "alt": $(this).attr('alt')
          });
        });
        coyote_consumer.producer.populateImages(domain, protocol, href,  imgs);
      },
      methods : {
        annotate: function(src, alt){
          var $images = $('img').filter(function(){
            return $(this)[0].src == src;
          });
          $images.attr('alt', alt);
        }
      }
    },

    producer : {
      path : "/coyote_producer", // The path on your app that provides your data service
      init: function() {
        coyote.logError = function(error){
          var $coyoteHeader = $('#coyote-header');
          var $error = $('<div class="alert alert-warning" role="alert">' + error + '</div>')
          console.log(error)
          $coyoteHeader.append($error);
        };

        coyote.checkForErrors = function(data){
            if( typeof(data.errors) != "undefined"){
              coyote.logError(data.errors.toString());
              return false;
            }
        };

        coyote.getWebsites = function(){
          //coyote.logError('getWebsites');
          var request = $.ajax({
            url: 'websites',
            method: "GET",
            dataType: "json",
            headers: coyote.headers
          });
          request.done(function( data ) {
            var websites = jsonQ(data);
            var record = websites.find('url', function () {
              return this.indexOf(coyote.full_domain) !== -1;
            });
            if(record.length == 1){
              var website = record.parent().value()[0];
              //website exists
              coyote.website_id = website.id;
              coyote.showGrid();
            } else {
              //website doesn't exist; create it
              coyote.postWebsite();
            }
          });
          request.fail(function(jqXHR, textStatus) {
            //TODO check if user logged in?
            coyote.logError( "getWebsites failed: " + textStatus );
          });
        };

        coyote.postWebsite = function(){
          var data = {
           "website" :{
             "url" : coyote.full_domain,
             "title" : coyote.full_domain
           }
          };
          var request = $.ajax({
            url: 'websites',
            data: data,
            method: "POST",
            dataType: "json",
            headers: coyote.headers
          });
          request.done(function( data ) {
            coyote.checkForErrors(data);
            coyote.website_id = data.id;
            coyote.showGrid();
          });
          request.fail(function(jqXHR, textStatus) {
            console.log( "postWebsites failed: " + textStatus );
          });
        };

        coyote.showGrid = function(){

          var $items = $('#coyote-items .item');
          $items.each(function() {
            var $btn = $('<button class="btn btn-info">Describe</button>')
            var $img = $(this).find('img');
            var imgObj = {
              "css_id": $img.attr('id'),
              "src": $img[0].src,
              "alt": $img.attr('alt')
            };
            $btn.click(function(){
              $(this).parents('.item').fadeOut();
              coyote.getImages(function(data){
                //TODO fuzzy https match
                //var path = imgObj.src.replace(/^(https?:|)\/\//, '//')
                var imgs = jsonQ(data.records);
                var record = imgs.find('path', function () {
                  return this.indexOf(imgObj.src) !== -1;
                });
                if(record.length == 1){
                  var img = record.parent().value()[0];
                  //TODO add page url to image record if not present
                  coyote.describe(img.id, imgObj.alt);
                } else {
                  coyote.postImage(imgObj);
                }
              });
            });
            $(this).append($btn);
          });

          //check for images in system
          coyote.getImages(function(data){
            coyote.checkForErrors(data);
            var srcs = coyote.imgs.map(function(img){
              return img["src"];
            });
            var coyote_images = jsonQ(data.records);
            var coyote_matches = coyote_images.find('path', function () {
              return srcs.indexOf(this) !== -1;
            });
            if(coyote_matches.length > 0){
              var imgs = coyote_matches.parent().value();
              $.each(imgs, function(i, img){
                $.each(img.descriptions, function(j, description){
                  var $description = $('<p class="description">' + description.text + '</p>');
                    $link = $('<a target="_blank" class="btn btn-info" href="/descriptions/' + description.id + '/edit">Edit</a>');
                  $link.click(function(){
                    $description.slideUp();
                  });
                  $link.appendTo($description);
                  //TODO labels for metum, locale, etc
                  $('img[src="' + img.path + '"]').after($description);
                  if(j == 0){
                    coyote_producer.consumer.annotate(img.path, description.text);
                  }
                });
              });
            }
          });
        }

        coyote.postImage = function(imgObj){
          //coyote.logError('postImage');
          var canonical_id = "bookmarklet_" + coyote.website_id + "_" + imgObj.css_id + "_"+ Date.now();
          //TODO protocol match logic...
          //var path = imgObj.src.replace(/^(https?:|)\/\//, '//')
          //coyote.logError(path);
          var data = {
           "image" :{
             "path" : imgObj.src,
             "title": imgObj.alt,
             "website_id" : coyote.website_id,
             "group_id" : "1",
             "canonical_id" : canonical_id,
             "page_urls": [ coyote.href ]
           }
          };
          var request = $.ajax({
            url: 'images',
            data: data,
            method: "POST",
            dataType: "json",
            headers: coyote.headers
          });
          request.done(function( data ) {
            coyote.checkForErrors(data);
            coyote.describe(data.id, imgObj.alt);
          });
          request.fail(function(jqXHR, textStatus) {
            coyote.logError( "postImage failed: " + textStatus );
          });
        };

        coyote.getImages = function(callback){
          var data = { "website_id" : coyote.website_id};
          var request = $.ajax({
            url: 'images',
            method: "GET",
            data: data,
            dataType: "json",
            headers: coyote.headers
          });
          request.done(function( data ) {
            coyote.checkForErrors(data);
            callback(data);
          });
          request.fail(function(jqXHR, textStatus) {
            coyote.logError( "getImages failed: " + textStatus );
          });
        };

        coyote.getDescription = function(){
        };

        coyote.describe = function(imgId, imgAlt){
          var text = encodeURIComponent(imgAlt);
          window.open("/descriptions/new?image_id="+imgId+"&metum_id=1&text="+ text);
        }

        //TODO later
        //coyote.postDescription = function(){
        //};
        //
      },

      methods : { // The methods that the consumer can call
        populateImages: function(domain, protocol, href, imgs) {
          //coyote.logError('populating imgs');
          //set shared vars onto coyote object for ajax calls
          coyote.headers = {
            'Accept': 'application/json'
          };
          coyote.imgs = imgs;
          coyote.domain = domain;
          coyote.protocol = protocol;
          coyote.href = href;
          coyote.full_domain = coyote.protocol + "//" + coyote.domain;

          //add imgs to grid
          var $coyoteItems = $('#coyote-items');
          $.each(imgs, function() {
            var $img = $('<img/>', {
              'src': this["src"],
              'alt': this["alt"]
            });
            var $item = $('<div class="item"></div>');
            $img.prependTo($item);
            $coyoteItems.append($item);
          });
          coyote.getWebsites();
          return false;
        },
      }
    }
  }
  window.CoyoteBookmarklet = CoyoteBookmarklet;
})();

