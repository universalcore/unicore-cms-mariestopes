unicore-cms-skeleton
====================

A skeleton project to use as the base for creating new apps

To use this repo as a base for your new app, do the following::

  $ git remote add skeleton https://github.com/universalcore/unicore-cms-skeleton.git
  $ git fetch skeleton
  $ git merge skeleton/develop

You then need to rename all the instances where ``skeleton`` is used.
``git grep skeleton`` should help you find all the mentions

To run the tests::

  $ pip install -r requirements-dev.txt
  $ ./run_tests.sh
