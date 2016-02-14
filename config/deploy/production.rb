# role-based syntax
# ==================

# Defines a role with one or multiple servers. The primary server in each
# group is considered to be the first unless any  hosts have the primary
# property set. Specify the username and a domain or IP for the server.
# Don't use `:all`, it's a meta role.

role :app, %w{deploy@62.113.208.27}
role :web, %w{deploy@62.113.208.27}
role :db,  %w{deploy@62.113.208.27}

set :rails_env, :production
set :stage, :production

server '62.113.208.27',
  user: 'deploy',
  roles: %w{web app db},
  primary: true

# Custom SSH Options
# ==================
# You may pass any option but keep in mind that net/ssh understands a
# limited set of options, consult the Net::SSH documentation.
# http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start
#
# Global options
# --------------
set :ssh_options, {
 keys: %w(/home/ought/.ssh/id_rsa),
 forward_agent: true,
 auth_methods: %w(publickey),
 port: 22069
}
