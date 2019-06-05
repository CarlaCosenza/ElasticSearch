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
                    "lineorder.orderdate.d_year": 1993
                  }
                },
                {
                  "range": {
                    "lineorder.lo_discount": {
                      "gte": 1,
                      "lte": 3
                    }
                  }
                },
                {
                  "range": {
                    "lineorder.lo_quantity": {
                      "lt": 25
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
                    "lineorder.orderdate.d_year": 1993
                  }
                },
                {
                  "range": {
                    "lineorder.lo_discount": {
                      "gte": 1,
                      "lte": 3
                    }
                  }
                },
                {
                  "range": {
                    "lineorder.lo_quantity": {
                      "lt": 25
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
}' 'https://2eeb8c0c.ngrok.io/suppliers/_search?pretty' > /Users/carlacosenza/Dropbox\ \(DeveloperAcademy-BR\)/IME/Semestre7/Banco\ de\ Dados\ II/ElasticSearch/results/query11.txt