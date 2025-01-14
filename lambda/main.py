import os
import json
import urllib.request
import boto3
from datetime import datetime, timedelta, timezone

def get_secret(secret_name):
    client = boto3.client('secretsmanager')
    response = client.get_secret_value(SecretId=secret_name)
    secret = json.loads(response['SecretString'])
    return secret

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
    except Exception as e:
        print(f"Error fetching secrets: {e}")
        return {"statusCode": 500, "body": "Error fetching secrets"}
    
    api_key = api_secret['NBA_API_KEY']
    sns_topic_arn = sns_secret['SNS_TOPIC_ARN']
    
    sns_client = boto3.client("sns")

    # Adjust for Central Time (UTC-6)
    utc_now = datetime.now(timezone.utc)
    central_time = utc_now - timedelta(hours=6)  # Central Time is UTC-6
    today_date = central_time.strftime("%Y-%m-%d")

    print(f"Fetching games for date: {today_date}")

    # Fetch data from the API
    api_url = f"https://api.sportsdata.io/v3/nba/scores/json/GamesByDate/{today_date}?key={api_key}"
    print(today_date)

    try:
        with urllib.request.urlopen(api_url) as response:
            data = json.loads(response.read().decode())
            print(json.dumps(data, indent=4))  # Debugging: log the raw data
    except Exception as e:
        print(f"Error fetching data from API: {e}")
        return {"statusCode": 500, "body": "Error fetching data"}

    # Include all games (final, in-progress, and scheduled)
    messages = [format_game_data(game) for game in data]
    final_message = "\n---\n".join(messages) if messages else "No games available for today."

    # Publish to SNS
    try:
        sns_client.publish(
            TopicArn=sns_topic_arn,
            Message=final_message,
            Subject="NBA Game Updates"
        )
        print("Message published to SNS successfully.")
    except Exception as e:
        print(f"Error publishing to SNS: {e}")
        return {"statusCode": 500, "body": "Error publishing to SNS"}

    return {"statusCode": 200, "body": "Data processed and sent to SNS"}
