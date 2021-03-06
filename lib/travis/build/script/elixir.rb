module Travis
  module Build
    class Script
      class Elixir < Erlang
        DEFAULTS = {
          elixir: '1.0.2',
          otp_release: '17.4'
        }

        def export
          super
          sh.export 'TRAVIS_ELIXIR_VERSION', elixir_version, echo: false
        end

        def announce
          super
          sh.cmd "kiex use #{elixir_version} || kiex install #{elixir_version}"
          sh.cmd "elixir --version"
        end

        def install
          sh.cmd 'mix local.hex --force'
          sh.cmd 'mix deps.get'
        end

        def script
          sh.cmd 'mix test'
        end

        def cache_slug
          super << '--elixir-' << elixir_version
        end

        private

        def elixir_version
          config[:elixir].to_s
        end
      end
    end
  end
end
