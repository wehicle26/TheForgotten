# The Forgotten

Space game made by the CollabCrew.

## Download Godot Engine

Get the latest version (4.2.1).  
[Godot Download](https://godotengine.org/)


## Guide to using GitHub

Collaboration is fun! But sometimes it can be tricky to keep everyone's work in sync, which makes it important to communicate your changes with the group. Here are some sensible steps to keep all the changes synchronized.


### Create a Fork

The first part of the process is to make a fork of the main repository. This is your "area" where no one else can disturb you.

Look to the top right and click on the Fork button to create your fork:

![Fork](screenshots/github_fork_create.png)

Click the green button and leave the default repository name unchanged:

![Fork2](screenshots/github_fork_create2.png)

Open up the GitHub Desktop app and clone the new fork with the link of your repository (File -> Clone Repository):

![Fork3](screenshots/github_fork_create3.png)

Choose the option to contribute to the parent project:

![Fork4](screenshots/github_fork_create4.png)


### Create a Branch

Now you want to create a new local branch to save your work with:

![Branch](screenshots/github_branch_create.png)

On this branch you can make commits which will be merged to the master repository through a pull request.


### Making a Commit

Next, it is time to make a commit or save your changes with git. Think of commits like checkpoints, they are snapshots of the files at a point in time and they can be merged with other commits and manipulated in many ways. The commits are added to the git database locally and online to keep a history of any changes made and to make sure to catch things which might cause someone's work to be overwritten.

Make sure everything is saved in Godot! You will not be able to see your changes unless you have all your files saved.

From the Github Desktop app, you can view your changes:

![Github Desktop](screenshots/github_app.png)

Go down the list and select the items you have worked on and wish to push to the main branch:

![Commit](screenshots/github_commit.png)

You should uncheck the files you do not want to send and then Right Click -> Discard Changes to mimimize any conflicts:

![Discard Changes](screenshots/github_discard.png)

Now enter an informative message about what the commit contains and hit the commit button!

![Finalize Commit](screenshots/github_commit_finalize.png)

After you commit, your screen should look like this:

![After Commit](screenshots/github_commit_after.png)


### Pushing

Now it is time to push your branch with your commits to your fork! This is as simple as pressing the button near the top right:

![Push](screenshots/github_push.png)

This will push your branch to Github.


### Pull Request

Finally, you can make a pull request to sync your changes into the main repository.

Now click on "Preview Pull Request":

![PR](screenshots/github_pull_request.png)

Make sure the right side is your repository name and the branch you just created is selected and hit create:

![PR2](screenshots/github_pull_request2.png)

After the pull request is created, go back to the Github Desktop app to switch back to the main branch. You can delete the branch you just created but it is also fine to leave them up as long as you can keep track of everything:

![Branch Delete](screenshots/github_branch_delete.png)

From here you can pull and sync the changes from the main repository. Follow the same process from [Create a Branch](#create-a-branch) to make more changes.


Congrats! If you made it this far you are better at coding than most of my co-workers who have been working 20+ years :)