CLASS z2ui5_cl_fw_http_handler DEFINITION
  PUBLIC
  CREATE PUBLIC.

  PUBLIC SECTION.

    CLASS-METHODS http_post
      IMPORTING
        body          TYPE string
      RETURNING
        VALUE(result) TYPE string.

    CLASS-METHODS http_get
      IMPORTING
        t_config                  TYPE z2ui5_if_client=>ty_t_name_value OPTIONAL
        content_security_policy   TYPE clike                            OPTIONAL
        check_logging             TYPE abap_bool                        OPTIONAL
        custom_js                 TYPE string                           OPTIONAL
        custom_js_oneventfrontend TYPE string                           OPTIONAL
          PREFERRED PARAMETER t_config
      RETURNING
        VALUE(r_result)           TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.


ENDCLASS.



CLASS Z2UI5_CL_FW_HTTP_HANDLER IMPLEMENTATION.


  METHOD http_get.

    DATA(lt_config) = t_config.

    IF lt_config IS INITIAL.
      lt_config = VALUE #(
          (  n = `data-sap-ui-theme`         v = `sap_horizon` )
          (  n = `src`                       v = `https://sdk.openui5.org/resources/sap-ui-cachebuster/sap-ui-core.js` )
*          (  n = `data-sap-ui-libs`          v = `sap.m` )
          (  n = `data-sap-ui-bindingSyntax` v = `complex` )
          (  n = `data-sap-ui-frameOptions`  v = `trusted` )
          (  n = `data-sap-ui-compatVersion` v = `edge` ) ).
    ENDIF.

    IF content_security_policy IS NOT SUPPLIED.
      DATA(lv_sec_policy) = `<meta http-equiv="Content-Security-Policy" content="default-src 'self' 'unsafe-inline' 'unsafe-eval' data: ` &&
        `ui5.sap.com *.ui5.sap.com sapui5.hana.ondemand.com *.sapui5.hana.ondemand.com sdk.openui5.org *.sdk.openui5.org cdn.jsdelivr.net *.cdn.jsdelivr.net cdnjs.cloudflare.com *.cdnjs.cloudflare.com"/>`.
    ELSE.
      lv_sec_policy = content_security_policy.
    ENDIF.
    z2ui5_cl_fw_db=>cleanup( ).

    r_result = `<!DOCTYPE html>` && |\n| &&
               `<html lang="en">` && |\n| &&
               `<head>` && |\n| &&
                  lv_sec_policy && |\n| &&
               `    <meta charset="UTF-8">` && |\n| &&
               `    <meta name="viewport" content="width=device-width, initial-scale=1.0">` && |\n| &&
               `    <meta http-equiv="X-UA-Compatible" content="IE=edge">` && |\n| &&
               `    <title>abap2UI5</title>` && |\n| &&
               `    <style>` && |\n| &&
               `        html, body, body > div, #container, #container-uiarea {` && |\n| &&
               `            height: 100%;` && |\n| &&
               `        }` && |\n| &&
               `    </style> ` &&
               `    <script id="sap-ui-bootstrap"`.

    LOOP AT lt_config REFERENCE INTO DATA(lr_config).
      r_result = r_result && | { lr_config->n }="{ lr_config->v }"|.
    ENDLOOP.

    r_result = r_result &&
        ` ></script></head>` && |\n| &&
        `<body class="sapUiBody sapUiSizeCompact" >` && |\n| &&
        `    <div id="content"  data-handle-validation="true" ></div>` && |\n| &&
        `` && |\n| &&
        `<abc/>` && |\n|.

    r_result = r_result && `<script>` && |\n| &&
                           `    sap.ui.getCore().attachInit(function () {` && |\n| &&
                           `        "use strict";` && |\n| &&
                           |\n| &&
                           `        sap.ui.controller("z2ui5_controller", {` && |\n| &&
                           `            onAfterRendering: function () {` && |\n| &&
                           |\n| &&
                           `                if (sap.z2ui5.oResponse.PARAMS.S_CURSOR.ID !== '') {` && |\n| &&
                           `                    jQuery.sap.delayedCall(50, this, () => {` && |\n| &&
                           `                        var ofocus = sap.z2ui5.oView.byId(sap.z2ui5.oResponse.PARAMS.S_CURSOR.ID).getFocusInfo();` && |\n| &&
                           `                        ofocus.selectionStart = sap.z2ui5.oResponse.PARAMS.S_CURSOR.SELECTIONSTART;` && |\n| &&
                           `                        ofocus.selectionEnd = sap.z2ui5.oResponse.PARAMS.S_CURSOR.SELECTIONEND;` && |\n| &&
                           `                        sap.z2ui5.oView.byId(sap.z2ui5.oResponse.PARAMS.S_CURSOR.ID).applyFocusInfo(ofocus);` && |\n| &&
                           `                    });` && |\n| &&
                           `                }` && |\n| &&
                           `                if (sap.z2ui5.oResponse.PARAMS.T_SCROLL) {` && |\n| &&
                           `              //      jQuery.sap.delayedCall(1, this, () => {` && |\n| &&
                           `                    sap.z2ui5.oResponse.PARAMS.T_SCROLL.forEach(item => {` && |\n| &&
                           `                        try {` && |\n| &&
                           `                            sap.z2ui5.oView.byId(item.N).scrollTo(item.V);` && |\n| &&
                           `                        } catch {` && |\n| &&
                           `                            try {` && |\n| &&
                           `                                var ele = '#' + sap.z2ui5.oView.byId(item.N).getId() + '-inner';` && |\n| &&
                           `                                $(ele).scrollTop(item.V);` && |\n| &&
                           `                            } catch { setTimeout( function( item ) { sap.z2ui5.oView.byId(item.N).scrollTo(item.V); } , 1 , item);}` && |\n| &&
                           `                        }` && |\n| &&
                           `          //           });` && |\n| &&
                           `                    }` && |\n| &&
                           `                   ` && |\n| &&
                           `                    );` && |\n| &&
                           `                }` && |\n| &&
                           `                if (sap.z2ui5.oResponse.PARAMS.S_POPUP.CHECK_DESTROY == true) {` && |\n| &&
                           `                    sap.z2ui5.oController.PopupDestroy();` && |\n| &&
                           `                }` && |\n| &&
                           `                if (sap.z2ui5.oResponse.PARAMS.S_POPUP.XML) {` && |\n| &&
                           `                    sap.z2ui5.oController.PopupDestroy();` && |\n| &&
                           `                    sap.ui.core.Fragment.load({` && |\n| &&
                           `                        definition: sap.z2ui5.oResponse.PARAMS.S_POPUP.XML,` && |\n| &&
                           `                        controller: sap.z2ui5.oController,` && |\n| &&
                           `                    }).then(oFragment => {` && |\n| &&
*                           `                        debugger;` && |\n| &&
                           `                        oFragment.setModel(new sap.ui.model.json.JSONModel(sap.z2ui5.oResponse.OVIEWMODEL))` && |\n| &&
                           `                        sap.z2ui5.oView.addDependent(oFragment);` && |\n| &&
                           `                        oFragment.open();` && |\n| &&
                           `                        sap.z2ui5.oViewPopup = oFragment;` && |\n| &&
                           `                    });` && |\n| &&
                           `                }` && |\n| &&
                           `                if (sap.z2ui5.checkNestAfter == false) {` && |\n| &&
                           `                    if (sap.z2ui5.oResponse.PARAMS.S_VIEW_NEST.XML !== '') {` && |\n| &&
                           `                        sap.z2ui5.oController.NestViewDestroy( );` && |\n| &&
                           `                        new sap.ui.core.mvc.XMLView.create({` && |\n| &&
                           `                            definition: sap.z2ui5.oResponse.PARAMS.S_VIEW_NEST.XML,` && |\n| &&
                           `                            controller: sap.z2ui5.oControllerNest,` && |\n| &&
                           `                        }).then(oView => {` && |\n| &&
                           `                            oView.setModel(new sap.ui.model.json.JSONModel(sap.z2ui5.oResponse.OVIEWMODEL));` && |\n| &&
                           `                            var oParent = sap.z2ui5.oView.byId(sap.z2ui5.oResponse.PARAMS.S_VIEW_NEST.ID);` && |\n| &&
                           `                            try { oParent[sap.z2ui5.oResponse.PARAMS.S_VIEW_NEST.METHOD_DESTROY](); } catch { }` && |\n| &&
                           `                            oParent[sap.z2ui5.oResponse.PARAMS.S_VIEW_NEST.METHOD_INSERT](oView);` && |\n| &&
                           `                            sap.z2ui5.checkNestAfter = true;` && |\n| &&
                           `                            sap.z2ui5.oViewNest = oView;` && |\n| &&
                           `                      //      sap.z2ui5.oView.setModel( sap.z2ui5.oViewNest.getModel( ) );` && |\n| &&
                           `                      //      sap.z2ui5.oLastView = oView;` && |\n| &&
                           `                        },);` && |\n| &&
                           `                    }` && |\n| &&
                           `                }` && |\n| &&
                           `                if (sap.z2ui5.checkNestAfter2 == false) {` && |\n| &&
                           `                    if (sap.z2ui5.oResponse.PARAMS.S_VIEW_NEST2.XML !== '') {` && |\n| &&
                           `                        sap.z2ui5.oController.NestViewDestroy2( );` && |\n| &&
                           `                        new sap.ui.core.mvc.XMLView.create({` && |\n| &&
                           `                            definition: sap.z2ui5.oResponse.PARAMS.S_VIEW_NEST2.XML,` && |\n| &&
                           `                            controller: sap.z2ui5.oControllerNest2,` && |\n| &&
                           `                        }).then(oView => {` && |\n| &&
                           `                            oView.setModel(new sap.ui.model.json.JSONModel(sap.z2ui5.oResponse.OVIEWMODEL));` && |\n| &&
                           `                            var oParent = sap.z2ui5.oView.byId(sap.z2ui5.oResponse.PARAMS.S_VIEW_NEST2.ID);` && |\n| &&
                           `                            try { oParent[sap.z2ui5.oResponse.PARAMS.S_VIEW_NEST2.METHOD_DESTROY](); } catch { }` && |\n| &&
                           `                            oParent[sap.z2ui5.oResponse.PARAMS.S_VIEW_NEST2.METHOD_INSERT](oView);` && |\n| &&
                           `                            sap.z2ui5.checkNestAfter2 = true;` && |\n| &&
                           `                            sap.z2ui5.oViewNest2 = oView;` && |\n| &&
                           `                      //      sap.z2ui5.oView.setModel( sap.z2ui5.oViewNest.getModel( ) );` && |\n| &&
                           `                      //      sap.z2ui5.oLastView = oView;` && |\n| &&
                           `                        },);` && |\n| &&
                           `                    }` && |\n| &&
                           `                }` && |\n| &&
                           `                if (sap.z2ui5.oResponse.PARAMS.S_POPOVER.CHECK_DESTROY == true) {` && |\n| &&
                           `                    sap.z2ui5.oController.PopoverDestroy();` && |\n| &&
                           `                }` && |\n| &&
                           `                if (sap.z2ui5.oResponse.PARAMS.S_POPOVER.XML) {` && |\n| &&
                           `                    sap.z2ui5.oController.PopoverDestroy();` && |\n| &&
                           `                    sap.ui.core.Fragment.load({` && |\n| &&
                           `                        definition: sap.z2ui5.oResponse.PARAMS.S_POPOVER.XML,` && |\n| &&
                           `                        controller: sap.z2ui5.oController,` && |\n| &&
                           `                    }).then(oFragment => {` && |\n| &&
                           `                        oFragment.setModel(new sap.ui.model.json.JSONModel(sap.z2ui5.oResponse.OVIEWMODEL))` && |\n| &&
                           `                        sap.z2ui5.oView.addDependent(oFragment);` && |\n| &&
                           `                        var oControl = sap.ui.getCore().byId(sap.z2ui5.oResponse.PARAMS.S_POPOVER.OPEN_BY_ID);` && |\n| &&
                           `                        if (oControl === undefined) {` && |\n| &&
                           `                            oControl = sap.z2ui5.oView.byId(sap.z2ui5.oResponse.PARAMS.S_POPOVER.OPEN_BY_ID);` && |\n| &&
                           `                        }` && |\n| &&
                           `                        if (oControl === undefined) {` && |\n| &&
                           `                            oControl = sap.z2ui5.oViewNest.byId(sap.z2ui5.oResponse.PARAMS.S_POPOVER.OPEN_BY_ID);` && |\n| &&
                           `                        }` && |\n| &&
                           `                        if (oControl === undefined) {` && |\n| &&
                           `                            oControl = sap.z2ui5.oViewNest2.byId(sap.z2ui5.oResponse.PARAMS.S_POPOVER.OPEN_BY_ID);` && |\n| &&
                           `                        }` && |\n| &&
                           `                        oFragment.openBy(oControl);` && |\n| &&
                           `                        sap.z2ui5.oViewPopover = oFragment;` && |\n| &&
                           `                    });` && |\n| &&
                           `                }` && |\n| &&
                           `                if (sap.z2ui5.oResponse.PARAMS.S_TIMER.EVENT_FINISHED !== '') {` && |\n| &&
                           `                    var oEvent = { 'EVENT': 'BUTTON_CHECK', 'METHOD': 'UPDATE' };` && |\n| &&
                           `                    oEvent.EVENT = sap.z2ui5.oResponse.PARAMS.S_TIMER.EVENT_FINISHED;` && |\n| &&
                           `                    sap.z2ui5.checkTimerActive = true;` && |\n| &&
                           `                    setTimeout(() => {` && |\n| &&
                           `                        if (sap.z2ui5.checkTimerActive) {` && |\n| &&
                           `                            let method = sap.z2ui5.oResponse.PARAMS.S_TIMER.EVENT_FINISHED.split( '(' )[ 0 ];` && |\n| &&
                           `                            let oArgs = [];` && |\n| &&
                           `                            oArgs.push( JSON.parse( (sap.z2ui5.oResponse.PARAMS.S_TIMER.EVENT_FINISHED.split( '(' )[ 1 ].split( ')' )[ 0 ].split( '}' )[ 0 ] + '}').replaceAll( "'" , '"' ) ) );` && |\n| &&
                           `                         //   let oArgsPara = sap.z2ui5.oResponse.PARAMS.S_TIMER.EVENT_FINISHED.split( '(' )[ 1 ].split( ')' )[ 0 ].split( '}' )[ 1 ].split( ',' ).slice(1);` && |\n| &&
                           `                            let oArgsPara = sap.z2ui5.oResponse.PARAMS.S_TIMER.EVENT_FINISHED.split( '(' )[ 1 ].split( ')' )[ 0 ].split( '}' )[ 1 ].split( '"' ).slice(1);` && |\n| &&
                           `                      //      oArgsPara.forEach( ( item, index, arr ) => { arr[index] = item.replace( '"' , '' ); } );;` && |\n| &&
                           `                            oArgs = oArgs.concat( oArgsPara );` && |\n| &&
                           `                            if (method == 'onEvent'){  sap.z2ui5.oController.onEvent(...oArgs);  }else{ sap.z2ui5.oController.onEventFrontend(...oArgs);  }` && |\n| &&
                           `                        }` && |\n| &&
                           `                    }, sap.z2ui5.oResponse.PARAMS.S_TIMER.INTERVAL_MS, oEvent);` && |\n| &&
                           `                }` && |\n| &&
                           `                sap.ui.core.BusyIndicator.hide();` && |\n| &&
                           `              if (sap.z2ui5.isBusy) { sap.z2ui5.isBusy = false; }` && |\n| &&
                           `            if (sap.z2ui5.b) { sap.z2ui5.b.close(); }` && |\n| &&
                           `            },` && |\n| &&
                           `            PopupDestroy: () => {` && |\n| &&
                           `                if (!sap.z2ui5.oViewPopup) {` && |\n| &&
                           `                    return;` && |\n| &&
                           `                }` && |\n| &&
                           `                if (sap.z2ui5.oViewPopup.close) {` && |\n| &&
                           `                    try { sap.z2ui5.oViewPopup.close(); } catch { }` && |\n| &&
                           `                }` && |\n| &&
                           `                sap.z2ui5.oViewPopup.destroy();` && |\n| &&
                           `            },` && |\n| &&
                           `            PopoverDestroy: () => {` && |\n| &&
                           `                if (!sap.z2ui5.oViewPopover) {` && |\n| &&
                           `                    return;` && |\n| &&
                           `                }` && |\n| &&
                           `                if (sap.z2ui5.oViewPopover.close) {` && |\n| &&
                           `                    try { sap.z2ui5.oViewPopover.close(); } catch { }` && |\n| &&
                           `                }` && |\n| &&
                           `                sap.z2ui5.oViewPopover.destroy();` && |\n| &&
                           `            },` && |\n| &&
                           `               NestViewDestroy: () => {` && |\n| &&
                           `                if (!sap.z2ui5.oViewNest) {` && |\n| &&
                           `                    return;` && |\n| &&
                           `                }` && |\n| &&
                           `                sap.z2ui5.oViewNest.destroy();` && |\n| &&
                           `            },` && |\n| &&
                           `               NestViewDestroy2: () => {` && |\n| &&
                           `                if (!sap.z2ui5.oViewNest2) {` && |\n| &&
                           `                    return;` && |\n| &&
                           `                }` && |\n| &&
                           `                sap.z2ui5.oViewNest2.destroy();` && |\n| &&
                           `            },` && |\n| &&
                           `            ViewDestroy: () => {` && |\n| &&
                           `                if (!sap.z2ui5.oView) {` && |\n| &&
                           `                    return;` && |\n| &&
                           `                }` && |\n| &&
                           `                sap.z2ui5.oView.destroy();` && |\n| &&
                           `            },` && |\n| &&
                           `            ` && |\n| &&
                           `            onEventFrontend: (...args) => {` && |\n| &&
                               custom_js_oneventfrontend &&
                           `                switch (args[0].EVENT) {` && |\n| &&
                           `  case 'CROSS_APP_NAV_TO_PREV_APP': ` && |\n| &&
                           `  var oCrossAppNavigator = sap.ushell.Container.getService("CrossApplicationNavigation"); ` && |\n| &&
                           ` oCrossAppNavigator.backToPreviousApp();` && |\n| &&
                           ` break;` && |\n| &&
                           `  case 'CROSS_APP_NAV_TO_EXT': ` && |\n| &&
                           ` var oCrossAppNavigator = sap.ushell.Container.getService("CrossApplicationNavigation");` && |\n|  &&
                           |\n|  &&
                           `  const hash = ( oCrossAppNavigator.hrefForExternal({` && |\n|  &&
                           `    target: args[1],` && |\n|  &&
                           `    params: args[2]` && |\n|  &&
                           `  } )) || "";` && |\n|  &&
                           |\n|  &&
                           ` if (args[3] === 'EXT') {` && |\n| &&
                           |\n| &&
                           `   var url = window.location.href.split('#')[0] + hash;` && |\n| &&
                           `   sap.m.URLHelper.redirect(url, true);` && |\n| &&
                           |\n| &&
                           `  }` && |\n| &&
                           ` else {` && |\n| &&
                           |\n| &&
                           `    oCrossAppNavigator.toExternal({` && |\n|  &&
                           `      target: {` && |\n|  &&
                           `          shellHash: hash` && |\n|  &&
                           `      }` && |\n|  &&
                           `    });` && |\n|  &&
                           |\n| &&
                           ` }` && |\n| &&
                           ` break;` && |\n| &&
                           `                    case 'LOCATION_RELOAD':` && |\n| &&
                           `                        window.location = args[1];` && |\n| &&
                           `                        break;` && |\n| &&
                           `                    case 'OPEN_NEW_TAB':` && |\n| &&
                           `                        window.open( args[1] , '_blank' );` && |\n| &&
                           `                        break;` && |\n| &&
                           `                    case 'POPUP_CLOSE':` && |\n| &&
                           `                        sap.z2ui5.oController.PopupDestroy();` && |\n| &&
                           `                        break;` && |\n| &&
                           `                    case 'POPOVER_CLOSE':` && |\n| &&
                           `                        sap.z2ui5.oController.PopoverDestroy();` && |\n| &&
                           `                        break;` && |\n| &&
                           `                    case 'NAV_CONTAINER_TO':` && |\n| &&
                           `                        var navCon = sap.z2ui5.oView.byId(args[1]);` && |\n| &&
                           `                        var navConTo = sap.z2ui5.oView.byId(args[2]);` && |\n| &&
                           `                        navCon.to(navConTo);` && |\n| &&
                           `                        break;` && |\n| &&
                           `                    case 'NEST_NAV_CONTAINER_TO':` && |\n| &&
                           `                        var navCon = sap.z2ui5.oViewNest.byId(args[1]);` && |\n| &&
                           `                        var navConTo = sap.z2ui5.oViewNest.byId(args[2]);` && |\n| &&
                           `                        navCon.to(navConTo);` && |\n| &&
                           `                        break;` && |\n| &&
                           `                    case 'NEST2_NAV_CONTAINER_TO':` && |\n| &&
                           `                        var navCon = sap.z2ui5.oViewNest2.byId(args[1]);` && |\n| &&
                           `                        var navConTo = sap.z2ui5.oViewNest.byId(args[2]);` && |\n| &&
                           `                        navCon.to(navConTo);` && |\n| &&
                           `                        break;` && |\n| &&
                           `                    case 'DRIVERJS_DRIVE':` && |\n| &&
                           `                        if( driver !== undefined ) { if( config !== undefined ) {` && |\n| &&
                           `                          driverObj = driver(config);` && |\n| &&
                           `                          driverObj.drive();` && |\n| &&
                           `                        } };` && |\n| &&
                           `                        break;` && |\n| &&
                           `                    case 'DRIVERJS_HIGHLIGHT':` && |\n| &&
                           `                        if( driver !== undefined ) { if ( highlight_driver_config !== undefined ) { if (highlight_config !== undefined ) {` && |\n| &&
                           `                          driverObj = driver(highlight_driver_config);` && |\n| &&
                           `                          driverObj.highlight(highlight_config);` && |\n| &&
                           `                        } }};` && |\n| &&
                           `                        break;` && |\n| &&
                           `                }` && |\n| &&
                           `            },` && |\n| &&
                           |\n| &&
                           `            onEvent: function (...args) {` && |\n| &&
                           `   //         return;` && |\n| &&
                           `   if ( sap.z2ui5.isBusy ) { if( sap.z2ui5.isBusy == true ){  sap.z2ui5.b = new sap.m.BusyDialog();    sap.z2ui5.b.open(); return; } } ` &&
                           `                sap.z2ui5.isBusy = true; ` &&
                           `                if (!window.navigator.onLine) {` && |\n| &&
                           `                    sap.m.MessageBox.alert('No internet connection! Please reconnect to the server and try again.');` && |\n| &&
                           `                    sap.z2ui5.isBusy = false; ` && |\n| &&
                           `                    return;` && |\n| &&
                           `                }` && |\n| &&
                           `                sap.ui.core.BusyIndicator.show();` && |\n| &&
                           `                sap.z2ui5.oBody = {};` && |\n| &&
                           `                let isUpdated = false;` && |\n| &&
                           `                if (sap.z2ui5.oViewPopup) {` && |\n| &&
                           `               if (!sap.z2ui5.oViewPopup.isOpen || sap.z2ui5.oViewPopup.isOpen() == true) {` && |\n| &&
                           `                    sap.z2ui5.oBody.EDIT = sap.z2ui5.oViewPopup.getModel().getData().EDIT;` && |\n| &&
                           `                    isUpdated = true;` && |\n| &&
                              `                  sap.z2ui5.oBody.VIEWNAME = 'MAIN';` && |\n| &&
                           `                  }` && |\n| &&
                           `                    }` && |\n| &&
                           `              if ( isUpdated == false ) { ` && |\n| &&
                           `              if (sap.z2ui5.oViewPopover) {` && |\n| &&
                           `              if (sap.z2ui5.oViewPopover.isOpen ) {` && |\n| &&
                           `                   if ( sap.z2ui5.oViewPopover.isOpen() == true) {` && |\n| &&
                           `                    sap.z2ui5.oBody.EDIT = sap.z2ui5.oViewPopover.getModel().getData().EDIT;` && |\n| &&
                           `                    isUpdated = true;` && |\n| &&
                              `                  sap.z2ui5.oBody.VIEWNAME = 'MAIN';` && |\n| &&
                           `                } } sap.z2ui5.oViewPopover.destroy(); } }` && |\n| &&
                           `                if (isUpdated == false){` && |\n| &&
                           `                   if (sap.z2ui5.oViewNest == this.getView() ) {` && |\n| &&
                           `                       sap.z2ui5.oBody.EDIT = sap.z2ui5.oViewNest.getModel().getData().EDIT;` && |\n| &&
                           `                   sap.z2ui5.oBody.VIEWNAME = 'NEST';` && |\n| &&
                           `                    isUpdated = true;` && |\n| &&
                           `                } }` && |\n| &&
                           `                if (isUpdated == false){` && |\n| &&
                           `                     sap.z2ui5.oBody.EDIT = sap.z2ui5.oView.getModel().getData().EDIT;` && |\n| &&
                           `                  sap.z2ui5.oBody.VIEWNAME = 'MAIN';` && |\n| &&
                           `                 }` && |\n| &&
                           |\n| &&
                           `                if (args[ 0 ].CHECK_VIEW_DESTROY){` && |\n| &&
                           `                    sap.z2ui5.oController.ViewDestroy();` && |\n| &&
                           `                }` && |\n| &&
                           `                if (sap.z2ui5.oResponse.PARAMS.T_SCROLL) {` && |\n| &&
                           `                    sap.z2ui5.oBody.oScroll = sap.z2ui5.oResponse.PARAMS.T_SCROLL;` && |\n| &&
                           `                    sap.z2ui5.oBody.oScroll.forEach(item => {` && |\n| &&
                           `                        try {` && |\n| &&
                           `                            item.V = sap.z2ui5.oView.byId(item.N).getScrollDelegate().getScrollTop();` && |\n| &&
                           `                        } catch (e) {` && |\n| &&
                           `                            try {` && |\n| &&
                           `                                var ele = '#' + sap.z2ui5.oView.byId(item.N).getId() + '-inner';` && |\n| &&
                           `                                item.V = $(ele).scrollTop();` && |\n| &&
                           `                            } catch (e) { }` && |\n| &&
                           `                        }` && |\n| &&
                           `                    });` && |\n| &&
                           `                }` && |\n| &&
                              `  try {              ` && |\n| &&
                              `   sap.z2ui5.oBody.OMESSAGEMANAGER = [];   ` && |\n| &&
                              `   try {            ` && |\n| &&
                              `   var aMsg = sap.ui.getCore().getMessageManager().getMessageModel().getData();           ` && |\n| &&
                              `   } catch (e) {  aMsg = sap.ui.getCore().getMessageManager().getMessageModel().oMessageManager.oMessageModel.oData; }            ` && |\n| &&
                              `   aMsg.forEach( row => {             ` && |\n| &&
                              ` //  sap.ui.getCore().getMessageManager().getMessageModel().oMessageManager.oMessageModel.oData.forEach( row => {             ` && |\n| &&
                              `    sap.z2ui5.oBody.OMESSAGEMANAGER.push( { type : row.type , message : row.message , additionaltext : row.additionalText , atargets : row.aTargets[ 0 ] } );            ` && |\n| &&
                              `}  ) } catch (e) { } ` && |\n| &&
                           `                sap.z2ui5.oBody.ID = sap.z2ui5.oResponse.ID;` && |\n| &&
                           `              sap.z2ui5.oBody.ARGUMENTS = args;` && |\n| &&
                           `                try { sap.z2ui5.oBody.OCURSOR = sap.ui.getCore().byId(sap.ui.getCore().getCurrentFocusedControlId()).getFocusInfo(); } catch (e) { }` && |\n| &&
                           |\n| &&
                           `                if (sap.z2ui5.checkLogActive) {` && |\n| &&
                           `                    console.log('Request Object:');` && |\n| &&
                           `                    console.log(sap.z2ui5.oBody);` && |\n| &&
                           `                }` && |\n| &&
                           `                sap.z2ui5.oResponseOld = sap.z2ui5.oResponse;` && |\n| &&
                           `                sap.z2ui5.oResponse = {};` && |\n| &&
                           `                sap.z2ui5.oController.Roundtrip();` && |\n| &&
                           `            },` && |\n| &&
                           `            responseError: response => {` && |\n| &&
                           `                document.write(response);` && |\n| &&
                           `            },` && |\n| &&
                           `            responseSuccess: response => {` && |\n| &&
                           |\n| &&
                           `                sap.z2ui5.oResponse = JSON.parse(response);` && |\n| &&
                           |\n| &&
                           `                 if (sap.z2ui5.checkLogActive) {` && |\n| &&
                           `                    console.log('Response Object:');` && |\n| &&
                           `                    console.log(JSON.parse( JSON.stringify(sap.z2ui5.oResponse) ) );` && |\n| &&
                           `                 if (sap.z2ui5.oResponse.PARAMS.S_VIEW.XML !== '') {` && |\n| &&
                           `                        console.log('UI5-XML-View:');` && |\n| &&
                           `                        console.log(sap.z2ui5.oResponse.PARAMS.S_VIEW.XML);` && |\n| &&
                           `                    }` && |\n| &&
                           `                 if (sap.z2ui5.oResponse.PARAMS.S_POPUP.XML !== '') {` && |\n| &&
                           `                        console.log('UI5-XML-Popup:');` && |\n| &&
                           `                        console.log(sap.z2ui5.oResponse.PARAMS.S_POPUP.XML);` && |\n| &&
                           `                    }` && |\n| &&
                           `                 if (sap.z2ui5.oResponse.PARAMS.S_POPOVER.XML !== '') {` && |\n| &&
                           `                        console.log('UI5-XML-Popover:');` && |\n| &&
                           `                        console.log(sap.z2ui5.oResponse.PARAMS.S_POPOVER.XML);` && |\n| &&
                           `                    }` && |\n| &&
                           `                 if (sap.z2ui5.oResponse.PARAMS.S_VIEW_NEST.XML !== '') {` && |\n| &&
                           `                        console.log('UI5-XML-Nest:');` && |\n| &&
                           `                        console.log(sap.z2ui5.oResponse.PARAMS.S_VIEW_NEST.XML);` && |\n| &&
                           `                    }` && |\n| &&
                           `                 if (sap.z2ui5.oResponse.PARAMS.S_VIEW_NEST2.XML !== '') {` && |\n| &&
                           `                        console.log('UI5-XML-Nest2:');` && |\n| &&
                           `                        console.log(sap.z2ui5.oResponse.PARAMS.S_VIEW_NEST2.XML);` && |\n| &&
                           `                    }` && |\n| &&
                           `                }` && |\n| &&
                           |\n| &&
                           `                if (sap.z2ui5.oResponse.PARAMS.S_VIEW.CHECK_DESTROY == true) { sap.z2ui5.oController.ViewDestroy(); }` && |\n| &&
                           |\n| &&
                           `                if (sap.z2ui5.oResponse.PARAMS.S_VIEW.XML !== '') {` && |\n| &&
                           |\n| &&
                           `                    sap.z2ui5.oController.ViewDestroy();` && |\n| &&
                           |\n| &&
                           `                   new sap.ui.core.mvc.XMLView.create({` && |\n| &&
                           `                        definition: sap.z2ui5.oResponse.PARAMS.S_VIEW.XML,` && |\n| &&
                           `                        controller: sap.z2ui5.oController,` && |\n| &&
                           `                    }).then(oView => {` && |\n| &&
                           `                       oView.setModel(new sap.ui.model.json.JSONModel(sap.z2ui5.oResponse.OVIEWMODEL));` && |\n| &&
                           `                        if (sap.z2ui5.oParent) {` && |\n| &&
                           `                            sap.z2ui5.oParent.removeAllPages();` && |\n| &&
                           `                            sap.z2ui5.oParent.insertPage(oView);` && |\n| &&
                           `                        } else {` && |\n| &&
                           `                            oView.placeAt("content")` && |\n| &&
                           `                        };` && |\n| &&
                           `                        sap.ui.getCore().getMessageManager().registerObject(oView, true);` && |\n| &&
                           `                        sap.z2ui5.oView = oView;` && |\n| &&
                           `                    },` && |\n| &&
                           `                    );` && |\n| &&
                           `                } else {` && |\n| &&
                           `                    if (sap.z2ui5.oResponse.PARAMS.S_VIEW.CHECK_UPDATE_MODEL == true) { sap.z2ui5.oView.setModel(new sap.ui.model.json.JSONModel(sap.z2ui5.oResponse.OVIEWMODEL)); }` && |\n| &&
                           `                    if (sap.z2ui5.oResponse.PARAMS.S_VIEW_NEST.CHECK_UPDATE_MODEL == true) { sap.z2ui5.oViewNest.setModel(new sap.ui.model.json.JSONModel(sap.z2ui5.oResponse.OVIEWMODEL));  }` && |\n|  &&
                           `                    if (sap.z2ui5.oResponse.PARAMS.S_VIEW_NEST2.CHECK_UPDATE_MODEL == true) { sap.z2ui5.oViewNest2.setModel(new sap.ui.model.json.JSONModel(sap.z2ui5.oResponse.OVIEWMODEL));  }` && |\n|  &&
                           `                    if (sap.z2ui5.oResponse.PARAMS.S_POPUP.CHECK_UPDATE_MODEL == true) { sap.z2ui5.oViewPopup.setModel(new sap.ui.model.json.JSONModel(sap.z2ui5.oResponse.OVIEWMODEL)); }` && |\n| &&
                           `                    if (sap.z2ui5.oResponse.PARAMS.S_POPOVER.CHECK_UPDATE_MODEL == true) { sap.z2ui5.oViewPopover.setModel(new sap.ui.model.json.JSONModel(sap.z2ui5.oResponse.OVIEWMODEL)); }` && |\n| &&
                           `                    sap.z2ui5.oController.onAfterRendering();` && |\n| &&
                           `                }` && |\n| &&
                           `                if (sap.z2ui5.oResponse.PARAMS.TITLE != "") {` && |\n| &&
                           `                    document.title = sap.z2ui5.oResponse.PARAMS.TITLE;` && |\n| &&
                           `                }` && |\n| &&
                           `                if (sap.z2ui5.oResponse.PARAMS.S_MSG_TOAST.TEXT !== '') {` && |\n| &&
                           `                    sap.m.MessageToast.show(sap.z2ui5.oResponse.PARAMS.S_MSG_TOAST.TEXT);` && |\n| &&
                           `                }` && |\n| &&
                           `                if (sap.z2ui5.oResponse.PARAMS.S_MSG_BOX.TEXT !== '') {` && |\n| &&
                           `                    sap.m.MessageBox[sap.z2ui5.oResponse.PARAMS.S_MSG_BOX.TYPE](sap.z2ui5.oResponse.PARAMS.S_MSG_BOX.TEXT);` && |\n| &&
                           `                }` && |\n| &&
                           `                if (sap.z2ui5.oResponse.SEARCH != "") {` && |\n| &&
                           `                 history.replaceState(null, null, window.location.pathname + '?' + sap.z2ui5.oResponse.SEARCH );` && |\n| &&
                           `                }` && |\n| &&
                           `                if (sap.z2ui5.oResponse.PARAMS.S_MESSAGE_MANAGER.CHECK_CLEAR == true) {` && |\n| &&
                           `                       sap.ui.getCore().getMessageManager().removeAllMessages();        ` && |\n| &&
                           `                       sap.ui.getCore().getMessageManager().registerObject(oView, true);        } ` && |\n| &&
                           `                if (sap.z2ui5.oResponse.PARAMS.S_MESSAGE_MANAGER.T_MESSAGE != "") {` && |\n| &&
                           `                   sap.z2ui5.oResponse.PARAMS.S_MESSAGE_MANAGER.T_MESSAGE.forEach( item => { ` && |\n|  &&
                           `                 sap.ui.getCore().getMessageManager().addMessages( new sap.ui.core.message.Message({` && |\n|  &&
                           `                        message: item.MESSAGE, ` && |\n|  &&
                           `                    //    persistent: true, // create message as transition message` && |\n|  &&
                           `                         type: item.TYPE ` && |\n|  &&
                           `                    }));}) }                         ` &&
                           `            },` && |\n| &&
                           `            readHttp: () => {` && |\n| &&
                           |\n| &&
                           `                var xhr = new XMLHttpRequest();` && |\n| &&
                           `                xhr.open("POST", sap.z2ui5.pathname, true);` && |\n| &&
                           `                xhr.onload = (that) => {` && |\n| &&
                           `                    if (that.target.status !== 200) {` && |\n| &&
                           `                        sap.z2ui5.oController.responseError(that.target.response);` && |\n| &&
                           `                    } else {` && |\n| &&
                           `                        sap.z2ui5.oController.responseSuccess(that.target.response);` && |\n| &&
                           `                    }` && |\n| &&
                           `                }` && |\n| &&
                           `                xhr.send(JSON.stringify(sap.z2ui5.oBody));` && |\n| &&
                           `            },` && |\n| &&
                           `            Roundtrip: () => {` && |\n| &&
                           |\n| &&
                           `                sap.z2ui5.checkTimerActive = false;` && |\n| &&
                           `                sap.z2ui5.checkNestAfter   = false;` && |\n| &&
                           `                sap.z2ui5.checkNestAfter2   = false;` && |\n| &&
                           |\n| &&
*                           `          debugger;` && |\n| &&
                           `                sap.z2ui5.oBody.OLOCATION = {` && |\n| &&
                           `                    ORIGIN: window.location.origin,` && |\n| &&
                           `                    PATHNAME: sap.z2ui5.pathname,` && |\n| &&
                           `                    SEARCH: window.location.search,` && |\n| &&
                           `                    VERSION: sap.ui.getVersionInfo().gav,` && |\n| &&
                           `                    CHECK_LAUNCHPAD_ACTIVE: sap.ushell !== undefined,` && |\n| &&
                           `                    STARTUP_PARAMETERS: sap.z2ui5.startupParameters,` && |\n| &&
                           `                };` && |\n| &&
                           `                   if(sap.z2ui5.search) {  sap.z2ui5.oBody.OLOCATION.SEARCH = sap.z2ui5.search; }` && |\n| &&
                           |\n| &&
                           `                if (sap.z2ui5.readOData) {` && |\n| &&
                           `                    sap.z2ui5.readOData();` && |\n| &&
                           `                } else {` && |\n| &&
                           `                    sap.z2ui5.oController.readHttp();` && |\n| &&
                           `                }` && |\n| &&
                           `            },` && |\n| &&
                           `        });` && |\n| &&
                           |\n| &&
                           `        if (!sap.z2ui5) {` && |\n| &&
                           `            sap.z2ui5 = {};` && |\n| &&
                           `        }` && |\n| &&
                           `        if (!sap.z2ui5.pathname) {` && |\n| &&
                           `            sap.z2ui5.pathname = window.location.pathname;` && |\n| &&
                           `           // sap.z2ui5.pathname = ``/sap/bc/http/sap/y2ui5_http_handler``;` && |\n| &&
                           `        }` && |\n| &&
                           `        sap.z2ui5.checkNestAfter = false;` && |\n| &&
                           `        jQuery.sap.require("sap.ui.core.Fragment");` && |\n| &&
                           `        jQuery.sap.require("sap.m.MessageToast");` && |\n| &&
                           `        jQuery.sap.require("sap.m.MessageBox");` && |\n| &&
                           `        jQuery.sap.require("sap.ui.model.json.JSONModel");` && |\n| &&
                           `        var xml = atob('PA==') + 'mvc:View controllerName="z2ui5_controller" xmlns:mvc="sap.ui.core.mvc" /' + atob('Pg==');` && |\n| &&
                           `        var oView = sap.ui.xmlview({ viewContent: xml });` && |\n| &&
                           `        sap.z2ui5.oController = oView.getController();` && |\n| &&
                           `        var oViewNest = sap.ui.xmlview({ viewContent: xml });` && |\n| &&
                           `        var oViewNest2 = sap.ui.xmlview({ viewContent: xml });` && |\n| &&
                           `        sap.z2ui5.oControllerNest = oViewNest.getController();` && |\n| &&
                           `        sap.z2ui5.oControllerNest2 = oViewNest.getController();` && |\n| &&
                           `        sap.z2ui5.checkLogActive = ` && z2ui5_cl_fw_utility=>boolean_abap_2_json( check_logging ) && `;` && |\n| &&
                           `        sap.z2ui5.oBody = {};` && |\n| &&
                           `        sap.z2ui5.oBody.APP_START = sap.z2ui5.APP_START;` && |\n| &&
                           `        sap.z2ui5.oController.Roundtrip();` && |\n| &&
                           `        sap.z2ui5.log = () => {  console.log(sap.z2ui5.oResponse.OVIEWMODEL ); };` && |\n| &&
                           `        sap.z2ui5.oController.oUtil = {}; ` && |\n| &&
                           `        sap.z2ui5.oController.oUtil.oDate = {}; ` && |\n| &&
                           `        sap.z2ui5.oController.oUtil.oDate.createObject = (s) => { return new Date(s); }` && |\n| &&
                           `  jQuery.sap.declare("sap.z2ui5.Helper");` && |\n|  &&
                           `sap.z2ui5.Helper = {};` && |\n| &&
                           `sap.z2ui5.Helper.DateCreateObject = (s => new Date(s));` && |\n| &&
                           `sap.z2ui5.Helper.DateAbapTimestampToDate = (sTimestamp => new sap.gantt.misc.Format.abapTimestampToDate(sTimestamp));` && |\n| &&
                           `sap.z2ui5.Helper.DateAbapDateToDateObject = (d => new Date(d.slice(0,4), (d[4]+d[5])-1, d[6]+d[7]));` && |\n| &&
                           `sap.z2ui5.Helper.DateAbapDateTimeToDateObject = ((d,t = '000000') => new Date(d.slice(0,4), (d[4]+d[5])-1, d[6]+d[7],t.slice(0,2),t.slice(2,4),t.slice(4,6)));` && |\n| &&
                           custom_js && |\n|  &&
                           z2ui5_cl_cc_timer=>get_js( ) && |\n|  &&
                           ` });` && |\n| &&
                           `</script>` && |\n| &&
                           `<abc/></body></html>`.

*                               `     sap.z2ui5.checkLogActive = ` && z2ui5_lcl_utility=>get_json_boolean( check_logging ) && `;` && |\n|  &&
  ENDMETHOD.


  METHOD http_post.

    TRY.
        DATA(lo_handler) = z2ui5_cl_fw_handler=>request_begin( body ).
      CATCH cx_root INTO DATA(x).
        lo_handler = z2ui5_cl_fw_handler=>set_app_system( x ).
    ENDTRY.

    DO.
      TRY.

          ROLLBACK WORK.
          CAST z2ui5_if_app( lo_handler->ms_db-app )->main( NEW z2ui5_cl_fw_client( lo_handler ) ).
          ROLLBACK WORK.

          IF lo_handler->ms_next-o_app_leave IS NOT INITIAL.
            lo_handler = lo_handler->set_app_leave( ).
            CONTINUE.
          ENDIF.

          IF lo_handler->ms_next-o_app_call IS NOT INITIAL.
            lo_handler = lo_handler->set_app_call( ).
            CONTINUE.
          ENDIF.

          result = lo_handler->request_end( ).

        CATCH cx_root INTO x.
          lo_handler = z2ui5_cl_fw_handler=>set_app_system( x ).
          CONTINUE.
      ENDTRY.

      EXIT.
    ENDDO.

  ENDMETHOD.
ENDCLASS.
