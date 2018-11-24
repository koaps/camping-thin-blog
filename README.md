##Camping Microframework Blog Example using Sequel, Thin and Rake

This is the camping microframework blog example using Sequel instead of ActiveRecord, Thin instead of Webrick, and a Rake file to start, stop, and migrate.

Run rake -T for a task list.

Set the RACK_ENV="debug" or production to run the migrate tasks, or start the app.

rake app:debug will start the app in the foreground, with trace and debug enabled, you can modify the config/debug.yml to turn off trace or debug options if only keeping the process in the foreground but not having tons of output is desired.

I removed the Comment model since there was no controller/view code in the example for it.

This code was hacked on pretty hard, so there's most likely issues somewhere, while being a simple example, there's a of changes that could easily cause the app to break.
Feel free to post an issue or ask a question, I'll do my bexst to answer, but anything too complex would most likely be best asked on the respective mailing lists, IRC channels or Google Groups.

#Notes
You will need to create at least the development_blog database with the blog user having rights.

In the config dir, the yml files will need to have the change dir updated:

    chdir: /path/to/app

Adjust to your own needs.


Help
=================
###Camping
[webpage] (http://camping.io/)
[github] (https://github.com/camping/camping/)

###Sequel
[webpage] (http://sequel.jeremyevans.net/)
[github] (https://github.com/jeremyevans/sequel/)

###Thin
[webpage] (http://code.macournoyer.com/thin/)
[github] (https://github.com/macournoyer/thin/)

###RedCloth
[webpage] (http://redcloth.org/)
[github] (https://github.com/jgarber/redcloth/)
