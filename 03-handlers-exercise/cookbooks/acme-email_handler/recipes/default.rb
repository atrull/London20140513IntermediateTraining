#
# All Rights Reserved
#

# Raise an exception at converge time. All your custom code should be placed
# ABOVE this line!
ruby_block 'raise_exception' do
  block do
    raise RuntimeError, 'Oh no! If you see this message in your inbox, great!'
  end
end
