curl -XPOST -H "Content-type: application/json" -d '
{
  "query": {"bool": {"filter": {
  "bool": {
        "must": [
      {"match": {"s_region":"ASIA"}},
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
                  {"match": {"lineorder.customer.c_region":"ASIA"}}, 
      {"range": {"lineorder.orderdate.d_year":{"gte":1992}}},
      {"range": {"lineorder.orderdate.d_year":{"lte":1997}}}  
                ]
         }}}}}}}
}]}}}},
  "aggs": {
       "s_nation": {
         "terms": {
            "field": "s_nation",
            "order" : { "_key" : "asc" }
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
                 {"match": {"lineorder.customer.c_region":"ASIA"}}, 
      {"range": {"lineorder.orderdate.d_year":{"gte":1992}}},
      {"range": {"lineorder.orderdate.d_year":{"lte":1997}}}  
                 ]
                }
         },
          "aggs": {
       "year": {
         "terms": {
            "field": "lineorder.orderdate.d_year",
            "order" : { "_key" : "asc" }
          }, 
      "aggs": {
       "c_nation": {
         "terms": {
            "field": "lineorder.customer.c_nation",
            "order" : { "_key" : "asc" }       
          },
      "aggs": {
          "sum_revenue": {
            "sum": {
                "field": "lineorder.lo_revenue"
                }
      }}}}}}}}}}}
},"sort" : [{"lineorder.lo_revenue" : {"order" : "desc"}}],"size":0
}' 'https://74b29662.ngrok.io/suppliers/_search?pretty' > /Users/carlacosenza/Dropbox\ \(DeveloperAcademy-BR\)/IME/Semestre7/Banco\ de\ Dados\ II/ElasticSearch/results/query31.txt