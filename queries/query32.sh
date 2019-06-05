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
                {"match": {"lineorder.customer.c_nation":"UNITED STATES"}},
                   {"range": {"lineorder.orderdate.d_year":{"gte":1992,"lte":1997}}}  
                ]
         }}}}}}}
}]}}}},
  "aggs": {
       "s_city": {
         "terms": {
            "field": "s_city",
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
                   {"match": {"lineorder.customer.c_nation":"UNITED STATES"}},
                   {"range": {"lineorder.orderdate.d_year":{"gte":1992,"lte":1997}}}   
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
       "c_city": {
         "terms": {
            "field": "lineorder.customer.c_city",
            "order" : { "_key" : "asc" }       
          },
      "aggs": {
          "sum_revenue": {
            "sum": {
                "field": "lineorder.lo_revenue"
                }
      }}}}}}}}}}}
},"sort" : [{"lineorder.lo_revenue" : {"order" : "desc"}}],"size":0
}' 'https://74b29662.ngrok.io/suppliers/_search?pretty' > /Users/carlacosenza/Dropbox\ \(DeveloperAcademy-BR\)/IME/Semestre7/Banco\ de\ Dados\ II/ElasticSearch/results/query32.txt