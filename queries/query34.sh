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
    {"bool":{"should":[{"match": {"lineorder.customer.c_city":"UNITED KI1"}},{"match": {"lineorder.customer.c_city":"UNITED KI5"}}]}},                  
      {"match": {"lineorder.orderdate.d_yearmonthnum":199712}}   
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
                   {"bool":{"should":[{"match": {"lineorder.customer.c_city":"UNITED KI1"}},{"match": {"lineorder.customer.c_city":"UNITED KI5"}}]}},          
      {"match": {"lineorder.orderdate.d_yearmonthnum":199712}}     
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
}' 'https://74b29662.ngrok.io/suppliers/_search?pretty' > /Users/carlacosenza/Dropbox\ \(DeveloperAcademy-BR\)/IME/Semestre7/Banco\ de\ Dados\ II/ElasticSearch/results/query34.txt