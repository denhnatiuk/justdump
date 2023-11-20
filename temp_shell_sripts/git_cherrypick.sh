  #!/bin/bash

  # The branch you want to pick the commit from
  SOURCE_BRANCH="source-branch"

  # The branch you want to apply the commit to
  TARGET_BRANCH="target-branch"

  # Get the last commit from the source branch
  LAST_COMMIT=$(git log $SOURCE_BRANCH -n 1 --pretty=format:"%H")

  # Checkout to the target branch
  git checkout $TARGET_BRANCH

  # Cherry-pick the last commit from the source branch
  git cherry-pick $LAST_COMMIT
  
