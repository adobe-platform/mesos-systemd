# Contributing to mesos-systemd 

The following is a set of guidelines for contributing to mesos-systemd (a part of [Ethos Infrastructure](https://github.com/adobe-platform/mesos-systemd) and [Adobe Platform](https://github.com/adobe-platform) organization on GitHub.

## Making Changes

Please follow the following steps to begin working on your changes:

- Fork this repository to your GitHub account.
- Add this repository as an upstream remote (`git remote add upstream git@github.com:adobe-platform/mesos-systemd.git`).
   - You may use a branch but to do so you must change your infrastructure related control/proxy/worker.json as follows:
```
cd /home/core && rm -rf mesos-systemd && git clone https://github.com/myfork/mesos-systemd && cd /home/core/mesos-systemd && git checkout -b worker origin/worker && ./init v3
``` 

- Make your changes.
- Once done, if using a branch such as origin/worker, we would like a submit a single commit if possible/appropriate.  To generate one you can:
 
 > Note: See [Rewriting history](https://www.atlassian.com/git/tutorials/rewriting-history/git-rebase-i) for info on consolidating commits.

```
# git checkout worker 
# git rebase --interactive 
# git push -f origin worker
```


- Add all changes via commits and push to your origin (your fork).
- Create a PR to merge your forked branch into adobe-platform/mesos-systemd:master.
- Fill out the PR by answering the supplied questions. This helps us determine how your changes will affect running stacks.
