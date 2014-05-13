Scenario A: Refactoring with ChefSpec
=====================================

The included cookbook needs to be refactored from a collection of script
resources into a real Chef cookbook.


Objectives
----------
- Write tests for how the cookbook should behave (BDD)
- Refactor the existing cookbook to use pure Chef resources
- Collaborate and ask questions - if you get stuck, ask your neighbor :)


Doneness
--------
- 100% test coverage
- All tests pass
- No `execute`, `script`, `bash`, etc resources


Getting Started
---------------
This scenario includes a cookbook named `acme-pos`. Inside the `acme-pos`
folder is a Chef cookbook and supporting files. Open the `acme-pos` folder in
your terminal and run the `bundle` command to install everything. Depending on
the Internet connection, this may take a few minutes.

```bash
$ cd /path/to/acme-pos
$ bundle install --binstubs
```

The `--binstubs` option tells Bundler to install gem shims in this project's
local `bin` directory. Instead of running `bundle exec`, you can use `./bin`.

You may want to take a moment to examine the `Gemfile`. If you are not familiar
with Ruby development, the `Gemfile` describes all of the dependencies a Ruby
program needs to execute. Bundler evaluates the Gemfile and installs the listed
dependencies for you automatically. The Gemfile in this scenario is heavily
commented for your education. We will be using a Gemfile for all scenarios in
this course.

Execute ChefSpec using the `rspec` binstub:

```text
$ ./bin/rspec
F

Failures:

  1) acme-pos::default installs apache2
     Failure/Error: expect(chef_run).to install_package('apache2')
       expected "package[apache2]" with action :install to be in Chef run. Other package resources:



     # ./spec/recipes/default_spec.rb:8:in `block (2 levels) in <top (required)>'

Finished in 0.00473 seconds
1 example, 1 failure

Failed examples:

rspec ./spec/recipes/default_spec.rb:7 # acme-pos::default installs apache2
```

As you can see from the output, there is already a failing test to get you
started

1 .Take a few moments to study the default recipe and discover the high-level
objective:

  > Deploy a static HTML file using Apache

2. **Write your tests first** for how you think the system should behave. For
example, if you think the system should write a template, write the test for
that in the `spec/recipes/default_spec.rb`:

   ```ruby
   it 'writes the index.html' do
     expect(chef_run).to create_template('/var/www/acme-pos/index.html')
   end
   ```

3. Run the failing tests:

  ```bash
  $ ./bin/rspec
  ```

4. Re-write the Chef recipe in `recipes/default.rb` to pass your tests. It is
recommended that you run `./bin/rspec` after each code change.



Helpful Links
-------------
- Docs: http://code.sethvargo.com/chefspec
- Examples: https://github.com/sethvargo/chefspec/tree/master/examples
- Blog: http://jtimberman.housepub.org/blog/2013/05/09/starting-chefspec-example/


Tips
----
- You can enable colored output by specifying the `--color` flag on the CLI

  ```ruby
  ./bin/rspec --color
  ```


"On your own" Resources
-----------------------
- Practical ChefSpec: http://files.meetup.com/1780846/ChefSpec.pdf
- Test Driven Development for Chef: http://www.youtube.com/watch?v=o2e0aZUAVGw
- Chef recipe code coverage: https://sethvargo.com/chef-recipe-code-coverage/
- TDDing tmux: http://www.confreaks.com/videos/2364-mwrc2013-tdding-tmux
