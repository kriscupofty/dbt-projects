from google.cloud import bigquery
from google.api_core.exceptions import GoogleAPIError


key_path = "/Users/kristys/Downloads/dbt-user-creds.json"

client = bigquery.Client.from_service_account_json(key_path)

def run_bigquery_query(query):
    try:
        query_job = client.query(query)

        results = query_job.result()
    except GoogleAPIError as e:
        print(f"BigQuery API error: {e.message}")

    rows_as_list = [dict(row) for row in results]
    return rows_as_list

# query = """
# select *
# from dbt_ksiu.fct_orders
# limit 3
# """

# print(run_bigquery_query(query))