curl -XPOST -H "Content-type: application/json" -d '
{
  "query": {"bool": {"filter": {
  "bool": {
        "must": [
        {"match": {"s_nation":"UNITED STATES"}},
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
                  {"match": {"lineorder.part.p_category":"MFGR#14"}},             
      {"match": {"lineorder.customer.c_region":"AMERICA"}},
      {"range": {"lineorder.orderdate.d_year":{"gte":1997}}},
      {"range": {"lineorder.orderdate.d_year":{"lte":1998}}} 
                ]
         }}}}}}}}]}}}
}, 
 "aggs": {
       "s_city": {
         "terms": {
            "field": "s_city",
            "order" : { "_key" : "asc" }, "size": 10000
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
                   {"match": {"lineorder.part.p_category":"MFGR#14"}},             
      {"match": {"lineorder.customer.c_region":"AMERICA"}},
      {"range": {"lineorder.orderdate.d_year":{"gte":1997}}},
      {"range": {"lineorder.orderdate.d_year":{"lte":1998}}}   
                 ]
                }
         },
          "aggs": {
       "year": {
         "terms": {
            "field": "lineorder.orderdate.d_year",
            "order" : { "_key" : "asc" }, "size": 10000
          },
          "aggs": {
       "p_brand1": {
         "terms": {
            "field": "lineorder.part.p_brand1",
            "order" : { "_key" : "asc" }, "size": 10000
          },
      "aggs": {
          "profit": {
            "sum": {
                "script" : "doc[\"lineorder.lo_revenue\"].value - doc[\"lineorder.lo_supplycost\"].value"
         }
      }}}}}}}}}
}}},"size":0
}' 'https://3348021e.ngrok.io/suppliers/_search?pretty' > /Users/carlacosenza/Dropbox\ \(DeveloperAcademy-BR\)/IME/Semestre7/Banco\ de\ Dados\ II/ElasticSearch/results/query43.txt