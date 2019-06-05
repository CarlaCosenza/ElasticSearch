curl -XPOST -H "Content-type: application/json" -d '
{
  "query": {"bool": {"filter": {
  "bool": {
        "must": [
        {"bool":{"should":[{"match": {"s_city":"UNITED KI1"}},{"match": {"s_city":"UNITED KI5"}}]}},
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
                  {"bool":{"should":[{"match": {"lineorder.customer.c_city":"UNITED KI1"}},{"term": {"lineorder.customer.c_city":"UNITED KI5"}}]}},   
      {"range": {"lineorder.orderdate.d_year":{"gte":1992,"lte":1997}}}  
                ]
         }}}}}}}
}]}}}},
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
                   {"bool":{"should":[{"match": {"lineorder.customer.c_city":"UNITED KI1"}},{"match": {"lineorder.customer.c_city":"UNITED KI5"}}]}},  
      {"range": {"lineorder.orderdate.d_year":{"gte":1992,"lte":1997}}} 
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
       "c_city": {
         "terms": {
            "field": "lineorder.customer.c_city",
            "order" : { "_key" : "asc" }, "size": 10000        
          },
      "aggs": {
          "sum_revenue": {
            "sum": {
                "field": "lineorder.lo_revenue"
                }
      }}}}}}}}}}}
},"sort" : [{"lineorder.lo_revenue" : {"order" : "desc"}}],"size":0
}' 'https://74b29662.ngrok.io/suppliers/_search?pretty' > /Users/carlacosenza/Dropbox\ \(DeveloperAcademy-BR\)/IME/Semestre7/Banco\ de\ Dados\ II/ElasticSearch/results/query33.txt