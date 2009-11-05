
module Bones::App
class Freeze < Command

  def self.initialize_freeze
    synopsis 'bones freeze [options] [skeleton_name]'

    description <<-__
Freeze the project skeleton to the current Mr Bones project skeleton.
If a name is not given, then the default name "data" will be used.
Optionally a git or svn repository can be frozen as the project
skeleton.
    __

    option(standard_options[:repository])
    option(standard_options[:verbose])
  end

  def run
    fm = FileManager.new(
      :source => repository || ::Bones.path('data'),
      :destination => output_dir,
      :stdout => stdout,
      :stderr => stderr,
      :verbose => verbose?
    )

    fm.archive_destination
    return freeze_to_repository if repository

    fm.copy

    stdout.puts "Project skeleton #{name.inspect} " <<
                "has been frozen to Mr Bones #{::Bones::VERSION}"
  end

  def parse( args )
    opts = super args
    config[:name] = args.empty? ? 'data' : args.join('_')
    config[:output_dir] = File.join(mrbones_dir, name)
  end

  # Freeze the project skeleton to the git or svn repository that the user
  # passed in on the command line. This essentially creates an alias to the
  # reposiory using the name passed in on the command line.
  #
  def freeze_to_repository
    FileUtils.mkdir_p(File.dirname(output_dir))
    File.open(output_dir, 'w') {|fd| fd.puts repository}
    stdout.puts "Project skeleton #{name.inspect} " <<
                "has been frozen to #{repository.inspect}"
  end

end  # class Freeze
end  # module Bones::App

# EOF