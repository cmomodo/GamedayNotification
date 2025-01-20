import os
import boto3
import json
from datetime import datetime, timezone, timedelta
from urllib.request import urlopen, Request
from urllib.error import HTTPError, URLError

def get_secret(secret_name):
    client = boto3.client('secretsmanager')
    response = client.get_secret_value(SecretId=secret_name)
    return json.loads(response['SecretString'])

def format_game_data(game):
    game_time = game.get("DateTime", "N/A")
    home_team = game.get("HomeTeam", "N/A")
    away_team = game.get("AwayTeam", "N/A")
    home_score = game.get("HomeTeamScore", "N/A")
    away_score = game.get("AwayTeamScore", "N/A")
    status = game.get("Status", "N/A")

    return (f"Game Time: {game_time}\n"
            f"Home Team: {home_team}\n"
            f"Away Team: {away_team}\n"
            f"Home Score: {home_score}\n"
            f"Away Score: {away_score}\n"
            f"Status: {status}")

def lambda_handler(event, context):
    # Fetch secrets
    try:
        api_secret = get_secret(os.getenv("NBA_API_SECRET_NAME"))
        sns_secret = get_secret(os.getenv("SNS_TOPIC_SECRET_NAME"))
        print("Retrieving API key from Secrets Manager...")
        print(f"API Secret content: {json.dumps(api_secret)}")
    except Exception as e:
        print(f"Error fetching secrets: {e}")
        return {"statusCode": 500, "body": "Error fetching secrets"}
    
    api_key = api_secret.get('NBA_API_KEY')
    if not api_key:
        print("API key is missing or empty")
        return {"statusCode": 500, "body": "API key configuration error"}
        
    sns_topic_arn = sns_secret.get('SNS_TOPIC_ARN')
    if not sns_topic_arn:
        print("SNS topic ARN is missing or empty")
        return {"statusCode": 500, "body": "SNS configuration error"}
    
    sns_client = boto3.client("sns")

    # Adjust for Central Time (UTC-6)
    utc_now = datetime.now(timezone.utc)
    central_time = utc_now - timedelta(hours=6)  # Central Time is UTC-6
    today_date = central_time.strftime("%Y-%m-%d")

    print(f"Fetching games for date: {today_date}")

    # Fetch data from the API
    api_url = f"https://api.sportsdata.io/v3/nba/scores/json/GamesByDate/{today_date}?key={api_key}"
    print(f"API URL: {api_url}")

    try:
        with urlopen(api_url) as response:
            data = json.loads(response.read().decode())
            print(json.dumps(data, indent=4))  # Debugging: log the raw data
    except HTTPError as e:
        print(f"HTTPError fetching data from API: {e.code} - {e.reason}")
        return {"statusCode": e.code, "body": f"HTTPError fetching data from API: {e.reason}"}
    except URLError as e:
        print(f"URLError fetching data from API: {e.reason}")
        return {"statusCode": 500, "body": f"URLError fetching data from API: {e.reason}"}
    except Exception as e:
        print(f"Unexpected error fetching data from API: {e}")
        return {"statusCode": 500, "body": f"Unexpected error fetching data from API: {e}"}

    # Include all games (final, in-progress, and scheduled)
    messages = [format_game_data(game) for game in data]
    final_message = "\n---\n".join(messages) if messages else "No games available for today."

    # Publish to SNS
    try:
        sns_client.publish(
            TopicArn=sns_topic_arn,
            Message=final_message,
            Subject=f"NBA Games for {today_date}"
        )
        print("Message published to SNS successfully")
    except Exception as e:
        print(f"Error publishing to SNS: {e}")
        return {"statusCode": 500, "body": f"Error publishing to SNS: {e}"}

    return {"statusCode": 200, "body": "Success"}
