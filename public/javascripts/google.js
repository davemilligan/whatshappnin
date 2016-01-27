<!-- ++Begin Map Search Control Wizard Generated Code++ -->
  <!--
  // Created with a Google AJAX Search Wizard
  // http://code.google.com/apis/ajaxsearch/wizards.html
  -->

  <!--
  // The Following div element will end up holding the map search control.
  // You can place this anywhere on your page
  -->


  <!-- Maps Api, Ajax Search Api and Stylesheet
  // Note: If you are already using the Maps API then do not include it again
  //       If you are already using the AJAX Search API, then do not include it
  //       or its stylesheet again
  //
  // The Key Embedded in the following script tags is designed to work with
  // the following site:
  // http://localhost:3000
  -->


    function LoadMapSearchControl() {

      var options = {
            zoomControl : GSmapSearchControl.ZOOM_CONTROL_ENABLE_ALL,
            title : "Googleplex",
            url : "http://www.google.com/corporate/index.html",
            idleMapZoom : GSmapSearchControl.ACTIVE_MAP_ZOOM,
            activeMapZoom : GSmapSearchControl.ACTIVE_MAP_ZOOM
            }

      new GSmapSearchControl(
            document.getElementById("mapsearch"),
            "1600 Amphitheatre Parkway, Mountain View, CA",
            options
            );

    }
    // arrange for this function to be called during body.onload
    // event processing
    GSearch.setOnLoadCallback(LoadMapSearchControl);

<!-- ++End Map Search Control Wizard Generated Code++ -->