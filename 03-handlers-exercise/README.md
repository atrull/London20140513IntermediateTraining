Scenario B: Writing Chef Handlers
=================================

The included cookbook needs to be refactored from a collection of script
resources into a real Chef cookbook.


Objectives
----------
- Write a custom Chef Handler
- Implement the resources in the `chef_handler` cookbook
- Collaborate and ask questions - if you get stuck, ask your neighbor :)


Doneness
--------
- Receiving an email when the Chef Client run fails


Getting Started
---------------
This scenario includes a cookbook named `acme-email_handler`. Inside the
`acme-email_handler` folder is a Chef cookbook and supporting files. Open the
`acme-email_handler` folder in your terminal and run the `bundle` command to
install everything. Depending on the Internet connection, this may take a few
minutes.

```bash
$ cd /path/to/this/project
$ bundle install --binstubs
```

You should execute all `knife` using the `knife` binstub:

```text
$ ./bin/knife
```

### Setup

1. Copy your client.pem and validator.pem files from your training Chef setup
into the `.chef` directory in this folder:

  ```text
  $ cp -R ~/.chef-training .chef
  ```

2. Verify `knife` is still communicating with your Chef Server correctly:

  ```text
  $ knife client list
  (output)
  ```

  If you see an exception, ask the instructor to help you.

3. Download and untar the `chef_handler` cookbook from the CHEF community site:

  ```text
  $ ./bin/knife cookbook site download chef_handler 1.1.6
  Downloading chef_handler from the cookbooks site at version 1.1.6 to ...

  Cookbook saved: .../chef_handler-1.1.6.tar.gz
  ```

  ```text
  $ tar -zxvf chef_handler-1.1.6.tar.gz -C cookbooks/
  $ rm chef_handler-1.1.6.tar.gz
  ```

  This is a "library" cookbook. We will not be altering/changing this cookbook.

4. Upload the `chef_handler` cookbook to your Chef Server:

  ```text
  $ knife cookbook upload chef_handler
  Uploading chef_handler         [1.1.6]
  Uploaded 1 cookbook.
  ```

### Implementation

1. Add an entry to the `metadata.rb` for the `acme-email_handler` cookbook to
depends on the `chef_handler` cookbook. This will allow us to use the
`chef_handler` resource in our Chef recipes.

  ```ruby
  # metadata.rb
  # ...
  depends 'chef_handler'
  ```

2. This scenario will make the use of a Ruby gem called "pony", which makes
sending email with Ruby a breeze. But in order to use the pony gem, we need it
installed on the system. Thankfully, we can use `chef_gem` for this. Add the
following to the default recipe:

  ```ruby
  chef_gem 'pony'
  ```

3. Then we need include the `chef_handler` cookbook's default recipe. This
recipe performs some of the setup tasks required to work with Chef handlers.

  ```ruby
  include_recipe 'chef_handler::default'
  ```

4. Create the email handler in `files/default/email_handler.rb`

  ```ruby
  require 'pony'

  module MyCompany
    class EmailMe < Chef::Handler
      def report
        subject = "Chef run failed on #{node.name}!"

        body =  "Chef run failed on #{node.name}\n"
        body << "#{run_status.formatted_exception}\n"
        Array(run_status.backtrace).each do |line|
          body << "#{line.strip}\n"
        end

        Pony.mail(
          to: '<REPLACE WITH YOUR EMAIL>',
          subject: subject,
          body: body,
        )
      end
    end
  end
  ```

  Be sure to replace the `<REPLACE WITH YOUR EMAIL>` with your email address!

5. Tell Chef to render this cookbook file in the default recipe at
`node['chef_handler']['handler_path']/email_handler.rb`. (HINT: Use
`cookbook_file` resource). If you need help, ask the instructor.

6. Use the `chef_handler` resource to create a new Chef Handler. This must come
**after** the code you wrote from the previous step.

  ```ruby
  chef_handler 'MyCompany::EmailMe' do
    source   "#{node['chef_handler']['handler_path']}/email_handler.rb"
    supports :exception => true
  end
  ```

  The first attribute `source` defines the path where the handler Ruby program
  lives. It is the the same path from the previous step. The second attribute
  `supports` defines which type of handler this is. In our example, we only want
  an exception handler, but it could easily support `:report` as well.

7. You could upload and execute this cookbook now, but the handler would fail to
execute. That is because most base systems do not install a Mail Transfer Agent
(MTA) such as postfix. We can use the Postfix community cookbook to install and
manage Postfix for us. As with the `chef_handler` cookbook, download and install
the postfix cookbook from the community site:

  ```text
  $ knife cookbook site download postfix 3.1.8
  Downloading postfix from the cookbooks site at version 3.1.8 to ... postfix-3.1.8.tar.gz

  Cookbook saved: .../postfix-3.1.8.tar.gz
  ```

  ```text
  $ tar -zxvf postfix-3.1.8.tar.gz -C cookbooks/
  $ rm postfix-3.1.8.tar.gz
  ```

  Upload the `postfix` cookbook to the Chef Server:

  ```text
  $ knife cookbook upload postfix
  Uploading postfix             [3.1.8]
  Uploaded 1 cookbook.
  ```

8. Add the postfix cookbook as a dependency in the `metadata.rb`:

  ```ruby
  # metadata.rb
  # ...
  depends 'postfix'
  ```

9. include postfix recipe in `acme-email_handler::default`

  ```ruby
  include_recipe 'acme-email_handler::default'
  ```

10. Upload the `acme-email_handler` cookbook to the Chef Server:

  ```text
  $ knife cookbook upload acme-email_handler
  Uploading acme-chef_handler   [1.0.0]
  Uploaded 1 cookbook.
  ```

11. Bootstrap your node with the `acme-email_handler` recipe in the run_list.
You should have obtained a cloudshare account from the instructor.

  ```text
  $ knife bootstrap IP_OR_FQDN \
    --ssh-user opscode \
    --ssh-password opscode \
    --run-list "recipe[acme-email_handler]"
  ```

  If everything works correctly, you should see a failed Chef Client run with
  the reason "Oh no! If you see this message in your inbox, great!". If you see
  a different exception and you do not know how to debug, please ask the
  instructor for assistance.

  Finally, check your inbox (and JUNK folder) to see if you received an email
  from the Chef Client. If you did not, it is possible that your email provider
  rejected the message.


Helpful Links
-------------
- Docs: http://docs.opscode.com/handlers.html


"On your own" Resources
-----------------------
- Community Chef Handlers: http://community.opscode.com/search?query=handler&scope=home
