curl -GET -H "Content-type: application/json" -d '
{
  "query": {
    "bool": {
      "must": [
        {
          "match": {
            "c_name": "Customer#000000001"
          }
        }
      ]
    }
  }
}' 'https://74b29662.ngrok.io/suppliers/_search?pretty'