# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{mocha}
  s.version = "0.10.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["James Mead"]
  s.date = %q{2012-02-28}
  s.description = %q{Mocking and stubbing library with JMock/SchMock syntax, which allows mocking and stubbing of methods on real (non-mock) classes.}
  s.email = %q{mocha-developer@googlegroups.com}
  s.extra_rdoc_files = ["README.rdoc", "COPYING.rdoc"]
  s.files = [".gemtest", "COPYING.rdoc", "Gemfile", "MIT-LICENSE.rdoc", "README.rdoc", "RELEASE.rdoc", "Rakefile", "examples/misc.rb", "examples/mocha.rb", "examples/stubba.rb", "gemfiles/Gemfile.minitest.1.3.0", "gemfiles/Gemfile.minitest.1.4.0", "gemfiles/Gemfile.minitest.1.4.1", "gemfiles/Gemfile.minitest.1.4.2", "gemfiles/Gemfile.minitest.2.0.0", "gemfiles/Gemfile.minitest.2.0.1", "gemfiles/Gemfile.minitest.2.3.0", "gemfiles/Gemfile.minitest.latest", "gemfiles/Gemfile.test-unit.2.0.0", "gemfiles/Gemfile.test-unit.2.0.1", "gemfiles/Gemfile.test-unit.2.0.3", "gemfiles/Gemfile.test-unit.latest", "init.rb", "lib/mocha.rb", "lib/mocha/any_instance_method.rb", "lib/mocha/api.rb", "lib/mocha/argument_iterator.rb", "lib/mocha/backtrace_filter.rb", "lib/mocha/cardinality.rb", "lib/mocha/central.rb", "lib/mocha/change_state_side_effect.rb", "lib/mocha/class_method.rb", "lib/mocha/configuration.rb", "lib/mocha/deprecation.rb", "lib/mocha/exception_raiser.rb", "lib/mocha/expectation.rb", "lib/mocha/expectation_error.rb", "lib/mocha/expectation_list.rb", "lib/mocha/in_state_ordering_constraint.rb", "lib/mocha/inspect.rb", "lib/mocha/instance_method.rb", "lib/mocha/integration.rb", "lib/mocha/integration/mini_test.rb", "lib/mocha/integration/mini_test/assertion_counter.rb", "lib/mocha/integration/mini_test/exception_translation.rb", "lib/mocha/integration/mini_test/version_13.rb", "lib/mocha/integration/mini_test/version_140.rb", "lib/mocha/integration/mini_test/version_141.rb", "lib/mocha/integration/mini_test/version_142_to_172.rb", "lib/mocha/integration/mini_test/version_200.rb", "lib/mocha/integration/mini_test/version_201_to_222.rb", "lib/mocha/integration/mini_test/version_230_to_262.rb", "lib/mocha/integration/test_unit.rb", "lib/mocha/integration/test_unit/assertion_counter.rb", "lib/mocha/integration/test_unit/gem_version_200.rb", "lib/mocha/integration/test_unit/gem_version_201_to_202.rb", "lib/mocha/integration/test_unit/gem_version_203_to_220.rb", "lib/mocha/integration/test_unit/gem_version_230_to_240.rb", "lib/mocha/integration/test_unit/ruby_version_185_and_below.rb", "lib/mocha/integration/test_unit/ruby_version_186_and_above.rb", "lib/mocha/is_a.rb", "lib/mocha/logger.rb", "lib/mocha/method_matcher.rb", "lib/mocha/mock.rb", "lib/mocha/mockery.rb", "lib/mocha/module_method.rb", "lib/mocha/multiple_yields.rb", "lib/mocha/names.rb", "lib/mocha/no_yields.rb", "lib/mocha/object.rb", "lib/mocha/options.rb", "lib/mocha/parameter_matchers.rb", "lib/mocha/parameter_matchers/all_of.rb", "lib/mocha/parameter_matchers/any_of.rb", "lib/mocha/parameter_matchers/any_parameters.rb", "lib/mocha/parameter_matchers/anything.rb", "lib/mocha/parameter_matchers/base.rb", "lib/mocha/parameter_matchers/equals.rb", "lib/mocha/parameter_matchers/has_entries.rb", "lib/mocha/parameter_matchers/has_entry.rb", "lib/mocha/parameter_matchers/has_key.rb", "lib/mocha/parameter_matchers/has_value.rb", "lib/mocha/parameter_matchers/includes.rb", "lib/mocha/parameter_matchers/instance_of.rb", "lib/mocha/parameter_matchers/is_a.rb", "lib/mocha/parameter_matchers/kind_of.rb", "lib/mocha/parameter_matchers/not.rb", "lib/mocha/parameter_matchers/object.rb", "lib/mocha/parameter_matchers/optionally.rb", "lib/mocha/parameter_matchers/query_string.rb", "lib/mocha/parameter_matchers/regexp_matches.rb", "lib/mocha/parameter_matchers/responds_with.rb", "lib/mocha/parameter_matchers/yaml_equivalent.rb", "lib/mocha/parameters_matcher.rb", "lib/mocha/pretty_parameters.rb", "lib/mocha/return_values.rb", "lib/mocha/sequence.rb", "lib/mocha/single_return_value.rb", "lib/mocha/single_yield.rb", "lib/mocha/standalone.rb", "lib/mocha/state_machine.rb", "lib/mocha/stubbing_error.rb", "lib/mocha/thrower.rb", "lib/mocha/unexpected_invocation.rb", "lib/mocha/version.rb", "lib/mocha/yield_parameters.rb", "lib/mocha_standalone.rb", "lib/stubba.rb", "mocha.gemspec", "test/acceptance/acceptance_test_helper.rb", "test/acceptance/api_test.rb", "test/acceptance/bug_18914_test.rb", "test/acceptance/bug_21465_test.rb", "test/acceptance/bug_21563_test.rb", "test/acceptance/exception_rescue_test.rb", "test/acceptance/expectations_on_multiple_methods_test.rb", "test/acceptance/expected_invocation_count_test.rb", "test/acceptance/failure_messages_test.rb", "test/acceptance/issue_65_test.rb", "test/acceptance/issue_70_test.rb", "test/acceptance/minitest_test.rb", "test/acceptance/mocha_example_test.rb", "test/acceptance/mocha_test_result_test.rb", "test/acceptance/mock_test.rb", "test/acceptance/mock_with_initializer_block_test.rb", "test/acceptance/mocked_methods_dispatch_test.rb", "test/acceptance/multiple_expectations_failure_message_test.rb", "test/acceptance/optional_parameters_test.rb", "test/acceptance/parameter_matcher_test.rb", "test/acceptance/partial_mocks_test.rb", "test/acceptance/raise_exception_test.rb", "test/acceptance/return_value_test.rb", "test/acceptance/sequence_test.rb", "test/acceptance/states_test.rb", "test/acceptance/stub_any_instance_method_test.rb", "test/acceptance/stub_class_method_defined_on_active_record_association_proxy_test.rb", "test/acceptance/stub_class_method_defined_on_class_test.rb", "test/acceptance/stub_class_method_defined_on_module_test.rb", "test/acceptance/stub_class_method_defined_on_superclass_test.rb", "test/acceptance/stub_everything_test.rb", "test/acceptance/stub_instance_method_defined_on_active_record_association_proxy_test.rb", "test/acceptance/stub_instance_method_defined_on_class_and_aliased_test.rb", "test/acceptance/stub_instance_method_defined_on_class_test.rb", "test/acceptance/stub_instance_method_defined_on_kernel_module_test.rb", "test/acceptance/stub_instance_method_defined_on_module_test.rb", "test/acceptance/stub_instance_method_defined_on_object_class_test.rb", "test/acceptance/stub_instance_method_defined_on_singleton_class_test.rb", "test/acceptance/stub_instance_method_defined_on_superclass_test.rb", "test/acceptance/stub_module_method_test.rb", "test/acceptance/stub_test.rb", "test/acceptance/stubba_example_test.rb", "test/acceptance/stubba_test.rb", "test/acceptance/stubba_test_result_test.rb", "test/acceptance/stubbing_error_backtrace_test.rb", "test/acceptance/stubbing_method_unnecessarily_test.rb", "test/acceptance/stubbing_non_existent_any_instance_method_test.rb", "test/acceptance/stubbing_non_existent_class_method_test.rb", "test/acceptance/stubbing_non_existent_instance_method_test.rb", "test/acceptance/stubbing_non_public_any_instance_method_test.rb", "test/acceptance/stubbing_non_public_class_method_test.rb", "test/acceptance/stubbing_non_public_instance_method_test.rb", "test/acceptance/stubbing_on_non_mock_object_test.rb", "test/acceptance/throw_test.rb", "test/acceptance/unstubbing_test.rb", "test/deprecation_disabler.rb", "test/execution_point.rb", "test/method_definer.rb", "test/mini_test_result.rb", "test/simple_counter.rb", "test/test_helper.rb", "test/test_runner.rb", "test/unit/any_instance_method_test.rb", "test/unit/array_inspect_test.rb", "test/unit/backtrace_filter_test.rb", "test/unit/cardinality_test.rb", "test/unit/central_test.rb", "test/unit/change_state_side_effect_test.rb", "test/unit/class_method_test.rb", "test/unit/configuration_test.rb", "test/unit/date_time_inspect_test.rb", "test/unit/exception_raiser_test.rb", "test/unit/expectation_list_test.rb", "test/unit/expectation_test.rb", "test/unit/hash_inspect_test.rb", "test/unit/in_state_ordering_constraint_test.rb", "test/unit/method_matcher_test.rb", "test/unit/mock_test.rb", "test/unit/mockery_test.rb", "test/unit/multiple_yields_test.rb", "test/unit/no_yields_test.rb", "test/unit/object_inspect_test.rb", "test/unit/object_test.rb", "test/unit/parameter_matchers/all_of_test.rb", "test/unit/parameter_matchers/any_of_test.rb", "test/unit/parameter_matchers/anything_test.rb", "test/unit/parameter_matchers/equals_test.rb", "test/unit/parameter_matchers/has_entries_test.rb", "test/unit/parameter_matchers/has_entry_test.rb", "test/unit/parameter_matchers/has_key_test.rb", "test/unit/parameter_matchers/has_value_test.rb", "test/unit/parameter_matchers/includes_test.rb", "test/unit/parameter_matchers/instance_of_test.rb", "test/unit/parameter_matchers/is_a_test.rb", "test/unit/parameter_matchers/kind_of_test.rb", "test/unit/parameter_matchers/not_test.rb", "test/unit/parameter_matchers/regexp_matches_test.rb", "test/unit/parameter_matchers/responds_with_test.rb", "test/unit/parameter_matchers/stub_matcher.rb", "test/unit/parameter_matchers/yaml_equivalent_test.rb", "test/unit/parameters_matcher_test.rb", "test/unit/return_values_test.rb", "test/unit/sequence_test.rb", "test/unit/single_return_value_test.rb", "test/unit/single_yield_test.rb", "test/unit/state_machine_test.rb", "test/unit/string_inspect_test.rb", "test/unit/thrower_test.rb", "test/unit/yield_parameters_test.rb"]
  s.homepage = %q{http://mocha.rubyforge.org}
  s.rdoc_options = ["--title", "Mocha", "--main", "README.rdoc", "--line-numbers"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{mocha}
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Mocking and stubbing library}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<metaclass>, ["~> 0.0.1"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<introspection>, ["~> 0.0.1"])
      s.add_development_dependency(%q<rdoc>, ["~> 3.1"])
      s.add_development_dependency(%q<coderay>, ["~> 0.1"])
    else
      s.add_dependency(%q<metaclass>, ["~> 0.0.1"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<introspection>, ["~> 0.0.1"])
      s.add_dependency(%q<rdoc>, ["~> 3.1"])
      s.add_dependency(%q<coderay>, ["~> 0.1"])
    end
  else
    s.add_dependency(%q<metaclass>, ["~> 0.0.1"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<introspection>, ["~> 0.0.1"])
    s.add_dependency(%q<rdoc>, ["~> 3.1"])
    s.add_dependency(%q<coderay>, ["~> 0.1"])
  end
end
