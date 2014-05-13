require 'chefspec'
require 'chefspec/coverage'

describe 'acme-pos::default' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'installs apache2' do
    expect(chef_run).to install_package('apache2')
  end
end
