# git pull depth

https://stackoverflow.com/questions/19352894/how-to-git-fetch-efficiently-from-a-shallow-clone/19528379#19528379

clone 一个大型仓库，可以 `git clone url --depth=1`
同步上游的时候，可以 `git fetch origin remoteBranch:localBranch --depth=1`
