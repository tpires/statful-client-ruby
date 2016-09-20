require 'spec_helper'

describe StatfulConfig do
  before do
    ENV['STATFUL_CONFIG'] = 'config/statful.yml.dist'
  end

  after do
    ENV['STATFUL_CONFIG'] = nil
  end

  describe 'with default enviroment' do
    before do
      @statful = StatfulClient.new({'transport' => 'udp',
                                    'token' => 'test',
                                    'app' => 'test_app',
                                    'tags' => {:tag => 'test_tag'},
                                    'flush_size' => 1
                                   })
    end

    describe '#load_config_file' do
      it 'with dryrun enable' do
        @statful.config[:dryrun].must_equal true
      end

      it 'with transport udp' do
        @statful.config[:transport].must_equal 'udp'
      end
    end
  end

  describe 'with staging enviroment' do
    before do
      @statful = StatfulClient.new({'transport' => 'udp',
                                    'token' => 'test',
                                    'app' => 'test_app',
                                    'tags' => {:tag => 'test_tag'}
                                   },
                                   'staging')
    end

    describe '#load_config_file' do
      it 'with dryrun disable' do
        @statful.config[:dryrun].must_equal false
      end

      it 'with flush_size 10' do
        @statful.config[:flush_size].must_equal 10
      end
    end
  end
end
