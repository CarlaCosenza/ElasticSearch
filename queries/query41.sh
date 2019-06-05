curl -XPOST -H "Content-type: application/json" -d '
{
  "query": {"bool": {"filter": {
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
       {"bool":{"should":[{"match": {"lineorder.part.p_mfgr":"MFGR#1"}},{"match": {"lineorder.part.p_mfgr":"MFGR#2"}}]}},            
      {"match": {"lineorder.customer.c_region":"AMERICA"}}
                ]
         }}}}}}}}]}}}
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
                   {"bool":{"should":[{"match": {"lineorder.part.p_mfgr":"MFGR#1"}},{"match": {"lineorder.part.p_mfgr":"MFGR#2"}}]}},            
      {"match": {"lineorder.customer.c_region":"AMERICA"}}
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
          "profit": {
            "sum": {"script" : "doc[\"lineorder.lo_revenue\"].value - doc[\"lineorder.lo_supplycost\"].value"}
      }}}}}}}}}
},"size":0
}' 'https://74b29662.ngrok.io/suppliers/_search?pretty' > /Users/carlacosenza/Dropbox\ \(DeveloperAcademy-BR\)/IME/Semestre7/Banco\ de\ Dados\ II/ElasticSearch/results/query41.txt