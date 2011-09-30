require 'spec/spec_helper'

describe Alias do

  before do
    @infos = []
    @infos << {'name' => 'ecom', 'version' => 'trunk', 'state' => 'success', 'build_type' => 'quick'}
    @infos << {'name' => 'ecom', 'version' => 'trunk', 'state' => 'success', 'build_type' => 'package'}
    @infos << {'name' => 'notecom', 'version' => '1.0', 'state' => 'failure', 'build_type' => 'regression'}
  end

  it 'should not alias non ecom builds' do
    infos = Alias.ecom(@infos)

    infos[2]['name'].should == 'notecom'
  end

  it 'should not alias ecom builds with single type' do
    infos = Alias.ecom(@infos)

    infos[0]['name'].should == 'ecom'
    infos[1]['name'].should == 'ecom'
  end

  it 'should alias ecom builds with no market' do
    @infos = [{'name' => 'ecom', 'build_type' => 'tomcat.atol.long.isolated.functional.test'}]

    infos = Alias.ecom(@infos)

    infos[0]['name'].should == 'atol'
  end

  it 'should alias ecom builds with market' do
    @infos = [{'name' => 'ecom', 'build_type' => 'tomcat.atol.br.long.isolated.functional.test'}]

    infos = Alias.ecom(@infos)

    infos[0]['name'].should == 'atol br'
  end

  it 'should alias ecom preview builds with no market' do
    @infos = [{'name' => 'ecom', 'build_type' => 'tomcat.preview.atol.long.isolated.functional.test'}]

    infos = Alias.ecom(@infos)

    infos[0]['name'].should == 'atol'
  end

  it 'should alias ecom preview builds with market' do
    @infos = [{'name' => 'ecom', 'build_type' => 'tomcat.preview.atol.br.long.isolated.functional.test'}]

    infos = Alias.ecom(@infos)

    infos[0]['name'].should == 'atol br'
  end
end
