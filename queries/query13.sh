#!/bin/bash
curl -XPOST -H "Content-type: application/json" -d '
{
  "query": {
    "bool": {
      "filter": {
        "nested": {
          "inner_hits": {},
          "path": "lineorder",
          "query": {
            "bool": {
              "must": [
              	{
                  "term": {
                    "lineorder.orderdate.d_weeknuminyear": 6
                  }
                },
                {
                  "term": {
                    "lineorder.orderdate.d_year": 1994
                  }
                },
                {
                  "range": {
                    "lineorder.lo_discount": {
                      "gte": 5,
                      "lte": 7
                    }
                  }
                },
                {
                  "range": {
                    "lineorder.lo_quantity": {
                      "gte": 26,
                      "lte": 35
                    }
                  }
                }
              ]
            }
          }
        }
      }
    }
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
                {
                  "term": {
                    "lineorder.orderdate.d_weeknuminyear": 6
                  }
                },
                {
                  "term": {
                    "lineorder.orderdate.d_year": 1994
                  }
                },
                {
                  "range": {
                    "lineorder.lo_discount": {
                      "gte": 5,
                      "lte": 7
                    }
                  }
                },
                {
                  "range": {
                    "lineorder.lo_quantity": {
                      "gte": 26,
                      "lte": 35
                    }
                  }
                }
              ]
            }
          },
          "aggs": {
            "extended_price": {
              "sum": {
                "script": "doc[\"lineorder.lo_extendedprice\"].value * doc[\"lineorder.lo_discount\"].value"
              }
            }
          }
        }
      }
    }
  },
  "size": 0
}' 'https://d93df2f6.ngrok.io/suppliers/_search?pretty' > /Users/carlacosenza/Dropbox\ \(DeveloperAcademy-BR\)/IME/Semestre7/Banco\ de\ Dados\ II/ElasticSearch/results/query13.txt