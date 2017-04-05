import random
import sys
from github import Github

ARGV = sys.argv
ARGC = len(ARGV)

if ARGC == 4:
    GITHUB_TOKEN = (ARGV[1])
    REPO_PATH = (ARGV[2])
    PULL_NO = int((ARGV[3]))
else:
    print("Usage: %s GITHUB_TOKEN" % ARGV[0])
    sys.exit()

g = Github(login_or_token = GITHUB_TOKEN)

repo = g.get_repo(REPO_PATH)
pull = repo.get_pull(PULL_NO)

if pull.assignee:
    print(pull.assignee.login + "was assignee in [" + pull.title + "]")
else:
    contributors = repo.get_contributors()
    asisignee = random.choice(contributors)
    print(contributors + "is best assignee in [" + pull.title + "]")

