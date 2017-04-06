""" Get assignee from GitHub """
import random
import sys
import os
from github import Github

ARGV = sys.argv
ARGC = len(ARGV)

if ARGC == 3:
    REPO_PATH = (ARGV[1])
    PULL_NO = int((ARGV[2]))
else:
    print ARGV
    print "Usage: %s GITHUB_TOKEN" % ARGV[0]
    sys.exit()

GH = Github(os.environ["HUBOT_GITHUB_TOKEN"])

REPO = GH.get_repo(REPO_PATH)
PULL = REPO.get_pull(PULL_NO)
TITLE = PULL.title.encode('utf-8')

if PULL.assignee:
    ASSIGNEE = PULL.assignee.login.encode('utf-8')
    print u"@%s was assignee in [ %s ]".encode('utf-8') % (ASSIGNEE, TITLE)
else:
    CONTRIBUTORS = REPO.get_contributors()
    ASSIGNEE = random.choice(CONTRIBUTORS).login.encode('utf-8')
    print u"@%s is best assignee in [ %s ]".encode('utf-8') % (ASSIGNEE, TITLE)
