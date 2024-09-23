import os
import psycopg2
from datetime import datetime

DB_NAME = os.getenv('POSTGRES_DB')
DB_USER = os.getenv('POSTGRES_USER')
DB_PASSWORD = os.getenv('POSTGRES_PASSWORD')
DB_HOST = os.getenv('POSTGRES_HOST')
DB_PORT = os.getenv('POSTGRES_PORT')
QUERY_ATTEMPTS = int(os.getenv('QUERY_ATTEMPTS'))

def execute_query(query, params):
    try:
        conn = psycopg2.connect(
            dbname=DB_NAME, user=DB_USER, password=DB_PASSWORD, host=DB_HOST, port=DB_PORT
        )
        cur = conn.cursor()
        cur.execute(query, params)
        result = cur.fetchall()
        cur.close()
        conn.close()

        for row in result:
            if 'cost=' in row[0]:
                cost_str = row[0].split('cost=')[1].split('..')[1]
                total_cost = float(cost_str.split(' ')[0])
                return total_cost

    except Exception as e:
        print(f"Error executing query: {e}")
        return None

def analyze_queries(queries_with_params):
    results = {}

    for query, params in queries_with_params:
        costs = []
        for _ in range(QUERY_ATTEMPTS):
            cost = execute_query(query, params)
            if cost is not None:
                costs.append(cost)

        if costs:
            results[query] = {
                'best_case': min(costs),
                'average_case': sum(costs) / len(costs),
                'worst_case': max(costs)
            }
        else:
            results[query] = {
                'best_case': None,
                'average_case': None,
                'worst_case': None
            }

    return results

def save_results(results, original_queries_with_params):
    timestamp = datetime.now().strftime("%Y%m%d%H%M%S")
    filename = f"/app/results/part_index_query_performance_{timestamp}.txt"

    with open(filename, 'w') as file:
        for query, data in results.items():
            original_query, params = original_queries_with_params[query]
            query_with_params = original_query % params
            file.write(f"Query: {query_with_params}\n")
            file.write(f"Best Case: {data['best_case']}\n")
            file.write(f"Average Case: {data['average_case']}\n")
            file.write(f"Worst Case: {data['worst_case']}\n")
            file.write("\n")

if __name__ == "__main__":
    CLIENT_ID = int(os.getenv("CLIENT_ID"))
    HALL_ID = int(os.getenv("HALL_ID"))

    original_queries_with_params = [
        ("SELECT * FROM training_history WHERE client_id=%s", (CLIENT_ID,)),
        ("SELECT * FROM coaches_in_hall WHERE hall_id=%s", (HALL_ID,)),
        ("""
         SELECT
            hse.hall_id AS Hall_ID,
            sec.name AS Category_Name,
            COUNT(hse.sports_equipment_id) AS Equipment_Count
        FROM
            new_hall_sports_equipment hse
        JOIN
            sports_equipment se ON hse.sports_equipment_id = se.id
        JOIN
            sports_equipment_subcategory ses ON se.subcategory_id = ses.id
        JOIN
            Sports_equipment_category sec ON ses.category_id = sec.id
        GROUP BY
            hse.hall_id, sec.name
        ORDER BY
            hse.hall_id, sec.name;
        """,
         ()),
        ("""
             SELECT
                EXTRACT(YEAR FROM start_time) AS year,
                EXTRACT(MONTH FROM start_time) AS month,
                COUNT(*) AS subscription_count
            FROM
                subscription
            WHERE
                start_time >= NOW() - INTERVAL '5 years'
            GROUP BY
                EXTRACT(YEAR FROM start_time),
                EXTRACT(MONTH FROM start_time)
            ORDER BY
                year,
                month;
            """,
         ())
    ]
    queries_with_params = [(f"EXPLAIN ANALYZE {query}", params) for query, params in original_queries_with_params]
    results = analyze_queries(queries_with_params)
    save_results(results,
                 {f"EXPLAIN ANALYZE {query}": (query, params) for query, params in original_queries_with_params})
    print("Analysis complete. Results saved.")
