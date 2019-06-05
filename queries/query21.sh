#!/bin/bash
curl -XPOST -H "Content-type: application/json" -d '
{
  "query": {"bool": { "filter": {
"bool": {
	      "must": [
		{"match": {"s_region":"AMERICA"}}, 
		{
    "bool": {
      "filter": {
        "nested": {
          "inner_hits": {},
          "path": "lineorder",
          "query": {
            "bool": {
              "filter": {
                "bool": {
                "must": [ 
                  { "match": { "lineorder.part.p_category":"MFGR#12"}}  
                ]
               }
              }
            }
          }
        }
      }
    }}]}}}
},
  "aggs": {
    "lineorder": {
      "nested": {
        "path": "lineorder"
      },
      "aggs": {
	  "only_loc": {
          "filter": {
                "bool": {
                "must": [ 
                  { "match": { "lineorder.part.p_category":"MFGR#12"}}  
                ]
               }
			   },
          "aggs": {
   		 "group_by_year": {
     		 "terms": {
      		  "field": "lineorder.orderdate.d_year",
            "order" : { "_key" : "asc" }, "size": 10000
     		  },
          "aggs": {
   		 	"group_by_brand": {
     		 	"terms": {
      		 	 "field": "lineorder.part.p_brand1",
            "order" : { "_key" : "asc" }, "size": 10000
      		         },
			"aggs": {
    			"sum_revenue": {
    			  "sum": {
     		        "field": "lineorder.lo_revenue"
      }}}
      }
    }
  }
  }
        }
		}
  }
}, "size":0
}' 'https://74b29662.ngrok.io/suppliers/_search?pretty' > /Users/carlacosenza/Dropbox\ \(DeveloperAcademy-BR\)/IME/Semestre7/Banco\ de\ Dados\ II/ElasticSearch/results/query21.txt