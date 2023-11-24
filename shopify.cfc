component {

	function init(
		required string storeName
	,	required string appKey
	,	required string appPass
	,	required string secretKey
	,	required string accessToken
	,	required string apiUrl= "https://<storeName>.myshopify.com"
	,	numeric httpTimeOut= 120
	,	boolean debug
	) {
		arguments.debug = ( arguments.debug ?: request.debug ?: false );
		this.storeName = arguments.storeName;
		this.appKey = arguments.appKey;
		this.appPass = arguments.appPass;
		this.secretKey = arguments.secretKey;
		this.accessToken = arguments.accessToken;
		this.apiUrl = replaceNoCase( arguments.apiUrl, "<storeName>", this.storeName );
		this.httpTimeOut= arguments.httpTimeOut;
		this.debug= arguments.debug;
		return this;
	}

	function debugLog( required input ) {
		if ( structKeyExists( request, "log" ) && isCustomFunction( request.log ) ) {
			if ( isSimpleValue( arguments.input ) ) {
				request.log( "shopify: " & arguments.input );
			} else {
				request.log( "shopify: (complex type)" );
				request.log( arguments.input );
			}
		} else if( this.debug ) {
			var info= ( isSimpleValue( arguments.input ) ? arguments.input : serializeJson( arguments.input ) );
			cftrace(
				var= "info"
			,	category= "shopify"
			,	type= "information"
			);
		}
		return;
	}

	// ---------------------------------------------------------------------------------------------------------- 
	// ORDER METHODS 
	// ---------------------------------------------------------------------------------------------------------- 

	function orderCount( string status= "", string financial_status= "", string fulfillment_status= "" ) {
		var out= this.apiRequest(
			path="/admin/api/2023-10/orders/count.json"
		,	verb="GET"
		,	args= arguments
		);
		return out;
	}

	function orders( string ids= "", string status= "open", string financial_status= "any", string fulfillment_status= "any", string fields= "", numeric limit= 50 ) {
		var out= this.apiRequest(
			path="/admin/api/2023-10/orders.json"
		,	verb="GET"
		,	args= arguments
		);
		return out;
	}

	function order( required string id ) {
		var out= this.apiRequest(
			path="/admin/api/2023-10/orders/#arguments.id#.json"
		,	verb="GET"
		);
		return out;
	}

	function orderCancel( string amount= "", string restock= "", string reason= "", boolean email= false ) {
		var out= this.apiRequest(
			path="/admin/api/2023-10/orders/#arguments.id#/cancel.json"
		,	verb="POST"
		);
		return out;
	}

	function orderDelete( required string id ) {
		var out= this.apiRequest(
			path="/admin/api/2023-10/orders/#arguments.id#.json"
		,	verb="DELETE"
		);
		return out;
	}

	// ---------------------------------------------------------------------------------------------------------- 
	// FULFILLMENT METHODS 
	// ---------------------------------------------------------------------------------------------------------- 

	function fulfillments( required numeric order_id, string fields= "", numeric page= 1, numeric limit= 50, string since_id= "" ) {
		var out = "";
		out= this.apiRequest(
			path= "/admin/api/2023-10/orders/#arguments.order_id#/fulfillments.json"
		,	verb= "GET"
		,	args= arguments
		);
		return out;
	}

	function fulfillment( required numeric order_id, required numeric id ) {
		var out = "";
		out= this.apiRequest(
			path= "/admin/api/2023-10/orders/#arguments.order_id#/fulfillments/#arguments.id#.json"
		,	verb= "GET"
		,	args= arguments
		);
		return out;
	}

	function fulfillmentCreate( required numeric order_id, string tracking_number= "", boolean notify_customer= true, line_items= "" ) {
		// convert line_items string/array into array struct 
		if ( isSimpleValue( arguments.line_items ) && len( arguments.line_items ) ) {
			arguments.line_items = listToArray( arguments.line_items, "," );
		}
		if ( isArray( arguments.line_items ) && arrayLen( arguments.line_items ) ) {
			var i = 0;
			var li = [];
			for ( i in arguments.line_items ) {
				arrayAppend( li, { "id" = i } );
			}
			arguments.line_items = il;
		}
		var out = "";
		var json = {
		"fulfillment" = arguments
		};
		out= this.apiRequest(
			path= "/admin/api/2023-10/orders/#arguments.order_id#/fulfillments.json"
		,	verb= "POST"
		,	json= json
		);
		return out;
	}

	function fulfillmentUpdate( required numeric order_id, required numeric id, string tracking_number= "", boolean notify_customer= true, line_items= "" ) {
		// convert line_items string/array into array struct 
		if ( isSimpleValue( arguments.line_items ) && len( arguments.line_items ) ) {
			arguments.line_items = listToArray( arguments.line_items, "," );
		}
		if ( isArray( arguments.line_items ) && arrayLen( arguments.line_items ) ) {
			var i = 0;
			var li = [];
			for ( i in arguments.line_items ) {
				arrayAppend( li, { "id" = i } );
			}
			arguments.line_items = il;
		}
		var out = "";
		var json = {
		"fulfillment" = arguments
		};
		out= this.apiRequest(
			path= "/admin/api/2023-10/orders/#arguments.order_id#/fulfillments/#arguments.id#.json"
		,	verb= "PUT"
		,	json= json
		);
		return out;
	}

	// ---------------------------------------------------------------------------------------------------------- 
	// PRODUCT METHODS 
	// ---------------------------------------------------------------------------------------------------------- 

	function productCount( string collection= "" ) {
		var out= this.apiRequest(
			path= "/admin/api/2023-10/products/count.json"
		,	verb= "GET"
		,	args= arguments
		);
		return out;
	}

	function products( string ids= "", string fields= "", string collection= "", numeric page= 1, numeric limit= 50, string vendor= "" ) {
		var out= this.apiRequest(
			path= "/admin/api/2023-10/products.json"
		,	verb= "GET"
		,	args= arguments
		);
		return out;
	}

	function product( required string id ) {
		var out= this.apiRequest(
			path= "/admin/api/2023-10/products/#arguments.id#.json"
		,	verb= "GET"
		);
		return out;
	}

	function productDelete( required string id ) {
		var out= this.apiRequest(
			path= "/admin/api/2023-10/products/#arguments.id#.json"
		,	verb= "DELETE"
		);
		return out;
	}

	function productCreate(
		required string title
	,	string body_html= ""
	,	string vendor= ""
	,	string product_type= ""
	,	boolean published= false
	,	images= ""
	,	array variants= []
	,	numeric var_price
	,	string var_barcode
	,	numeric var_weight
	,	string var_fulfillment_service
	,	string var_inventory_policy
	,	numeric var_inventory_quantity
	,	string var_inventory_management
	,	string var_sku
	,	boolean var_taxable
	,	boolean var_title
	,	numeric var_position
	) {
		if ( isSimpleValue( arguments.images ) && left( arguments.images, 4 ) == "http" ) {
			arguments.images = [ { "src" = arguments.images } ];
		}
		if ( arrayLen( arguments.variants ) == 0 ) {
			arrayAppend( arguments.variants, {} );
		}
		var item = "";
		var x = 0;
		for ( item in arguments ) {
			if ( left( item, 4 ) == "var_" ) {
				// copy var_ into all variants 
				for ( x=1 ; x<=arrayLen( arguments.variants ) ; x++ ) {
					arguments.variants[ x ][ listRest( item, "_" ) ] = arguments[ item ];
				}
				structDelete( arguments, item );
			} else if ( reFindNoCase( "var[0-9]+_", item ) ) {
				// copy var1_ into a single variant 
				x = replace( listFirst( item, "_" ), "var", "" );
				arguments.variants[ x ][ listRest( item, "_" ) ] = arguments[ item ];
				structDelete( arguments, item );
			}
		}
		var out = "";
		var json = {
			"product" = arguments
		};
		out= this.apiRequest(
			path= "/admin/api/2023-10/products.json"
		,	verb= "POST"
		,	json= json
		);
		return out;
	}

	function productUpdate(
		required string id
	,	string title= ""
	,	string body_html= ""
	,	string vendor= ""
	,	string product_type= ""
	,	boolean published= false
	,	array variants= []
	) {
		if ( structKeyExists( arguments, "images" ) && isSimpleValue( arguments.images ) && left( arguments.images, 4 ) == "http" ) {
			arguments.images = [ { "src" = arguments.images } ];
		}
		if ( arrayLen( arguments.variants ) == 0 ) {
			arrayAppend( arguments.variants, {} );
		}
		var item = "";
		var x = 0;
		for ( item in arguments ) {
			if ( left( item, 4 ) == "var_" ) {
				// copy var_ into all variants 
				for ( x=1 ; x<=arrayLen( arguments.variants ) ; x++ ) {
					arguments.variants[ x ][ listRest( item, "_" ) ] = arguments[ item ];
				}
				structDelete( arguments, item );
			} else if ( reFindNoCase( "var[0-9]+_", item ) ) {
				// copy var1_ into a single variant 
				x = replace( listFirst( item, "_" ), "var", "" );
				arguments.variants[ x ][ listRest( item, "_" ) ] = arguments[ item ];
				structDelete( arguments, item );
			}
		}
		if ( !arrayLen( arguments.variants ) ) {
			structDelete( arguments, "variants" );
		}
		var out = "";
		var json = {
			"product" = arguments
		};
		out= this.apiRequest(
			path= "/admin/api/2023-10/products/#arguments.id#.json"
		,	verb= "PUT"
		,	json= json
		);
		return out;
	}

	function variants( required string product_id, string fields= "", numeric page= 1, numeric limit= 50 ) {
		var out = "";
		out= this.apiRequest(
			path= "/admin/api/2023-10/variants/#arguments.product_id#.json"
		,	verb= "GET"
		,	args= arguments
		);
		return out;
	}

	function variantCreate( required string product_id ) {
		var out = "";
		var json = {
		"variant" = arguments
		};
		out= this.apiRequest(
			path= "/admin/api/2023-10/products/#arguments.product_id#/variants.json"
		,	verb= "POST"
		,	json= json
		);
		return out;
	}

	function variantUpdate( string id= "" ) {
		var out = "";
		var json = {
		"variant" = arguments
		};
		out= this.apiRequest(
			path= "/admin/api/2023-10/variants/#arguments.id#.json"
		,	verb= "PUT"
		,	json= json
		);
		return out;
	}

	function variantDelete( string product_id= "", string id= "" ) {
		var out= this.apiRequest(
			path= "/admin/api/2023-10/products/#arguments.product_id#/variants/#arguments.id#.json"
		,	verb= "DELETE"
		);
		return out;
	}

	struct function apiRequest( required string path, string verb= "POST", args= "", json= "" ) {
		var http = {};
		var dataKeys = 0;
		var item = "";
		var out = {
			success = false
		,	error = ""
		,	status = ""
		,	json = ""
		,	statusCode = 0
		,	response = ""
		,	verb = arguments.verb
		,	requestUrl = this.apiUrl & arguments.path
		};
		if ( isStruct( arguments.args ) ) {
			out.requestUrl &= this.structToQueryString( arguments.args );
		} else if ( len( arguments.args ) ) {
			out.requestUrl &= arguments.args;
		}
		if ( isStruct( arguments.json ) ) {
			out.json = serializeJSON( arguments.json, false, false );
			out.json = reReplace( out.json, "[#chr(1)#-#chr(7)#|#chr(11)#|#chr(14)#-#chr(31)#]", "", "all" );
		} else if ( isSimpleValue( arguments.json ) && len( arguments.json ) ) {
			out.json = arguments.json;
		}
		this.debugLog( out.verb & ": " & arguments.path );
		// this.debugLog( out );
		cftimer( type="debug", label="shopify request" ) {
			cfhttp( result="http", method=out.verb, url=out.requestUrl, charset="UTF-8", throwOnError=false, timeOut=this.httpTimeOut ) {
				cfhttpparam( name="X-Shopify-Access-Token", type="header", value="#this.accessToken#" );
				cfhttpparam( name="Content-Type", type="header", value="application/json" );
				if ( out.verb == "POST" || out.verb == "PUT" ) {
					cfhttpparam( type="body", value=out.json );
				}
			}
		}
		// this.debugLog( http );
		out.response = toString( http.fileContent );
		// this.debugLog( out.response );
		out.statusCode = http.responseHeader.Status_Code ?: 500;
		if ( left( out.statusCode, 1 ) == 4 || left( out.statusCode, 1 ) == 5 ) {
			out.error = "status code error: #out.statusCode#";
		} else if ( out.response == "Connection Timeout" || out.response == "Connection Failure" ) {
			out.error = out.response;
		} else if ( left( out.statusCode, 1 ) == 2 ) {
			out.success = true;
		}
		// parse response 
		if ( out.success && len( out.response ) ) {
			try {
				out.response = deserializeJSON( out.response );
				if ( isStruct( out.response ) && structKeyExists( out.response, "error" ) ) {
					out.success = false;
					out.error = out.response.error;
				}
			} catch (any cfcatch) {
				out.error= "JSON Error: " & (cfcatch.message?:"No catch message") & " " & (cfcatch.detail?:"No catch detail");
			}
		}
		if ( len( out.error ) ) {
			out.success = false;
		}
		this.debugLog( out.statusCode & " " & out.error );
		return out;
	}

	string function structToQueryString( required struct stInput, boolean bEncode= true, string lExclude= "", string sDelims= "," ) {
		var sOutput = "";
		var sItem = "";
		var sValue = "";
		var amp = "?";
		for ( sItem in stInput ) {
			if ( !len( lExclude ) || !listFindNoCase( lExclude, sItem, sDelims ) ) {
				try {
					sValue = stInput[ sItem ];
					if ( len( sValue ) ) {
						if ( bEncode ) {
							sOutput &= amp & lCase( sItem ) & "=" & urlEncodedFormat( sValue );
						} else {
							sOutput &= amp & lCase( sItem ) & "=" & sValue;
						}
						amp = "&";
					}
				} catch (any cfcatch) {
				}
			}
		}
		return sOutput;
	}

}
