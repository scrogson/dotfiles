require 'rake'

desc "Hook our dotfiles into system-standard positions."
task :install do
  linkables = Dir.glob('*/**{.symlink}')

  skip_all = false
  overwrite_all = false
  backup_all = false

  linkables.each do |linkable|
    overwrite = false
    backup = false

    file = linkable.split('/').last.split('.symlink').last
    target = "#{ENV["HOME"]}/.#{file}"

    if File.exists?(target) || File.symlink?(target)
      unless skip_all || overwrite_all || backup_all
        puts "File already exists: #{target}, what do you want to do? [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all"
        case STDIN.gets.chomp
        when 'o' then overwrite = true
        when 'b' then backup = true
        when 'O' then overwrite_all = true
        when 'B' then backup_all = true
        when 'S' then skip_all = true
        when 's' then next
        end
      end
      FileUtils.rm_rf(target) if overwrite || overwrite_all
      `mv "$HOME/.#{file}" "$HOME/.#{file}.backup"` if backup || backup_all
    end
    `ln -s "$PWD/#{linkable}" "#{target}"`
  end
end

task :uninstall do

  Dir.glob('**/*.symlink').each do |linkable|

    file = linkable.split('/').last.split('.symlink').last
    target = "#{ENV["HOME"]}/.#{file}"

    # Remove all symlinks created during installation
    if File.symlink?(target)
      FileUtils.rm(target)
    end

    # Replace any backups made during installation
    if File.exists?("#{ENV["HOME"]}/.#{file}.backup")
      `mv "$HOME/.#{file}.backup" "$HOME/.#{file}"` 
    end

  end
end

task :default => 'install'

#require 'rake'
#require 'erb'

#desc "install the dot files into user's home directory"
#task :install do
  #replace_all = false
  #Dir['*'].each do |file|
    #next if %w[Rakefile].include? file
    
    #if File.exist?(File.join(ENV['HOME'], ".#{file.sub('.erb', '')}"))
      #if File.identical? file, File.join(ENV['HOME'], ".#{file.sub('.erb', '')}")
        #puts "identical ~/.#{file.sub('.erb', '')}"
      #elsif replace_all
        #replace_file(file)
      #else
        #print "overwrite ~/.#{file.sub('.erb', '')}? [ynaq] "
        #case $stdin.gets.chomp
        #when 'a'
          #replace_all = true
          #replace_file(file)
        #when 'y'
          #replace_file(file)
        #when 'q'
          #exit
        #else
          #puts "skipping ~/.#{file.sub('.erb', '')}"
        #end
      #end
    #else
      #link_file(file)
    #end
  #end
  #download_omz
#end

#def download_omz
  #system "git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh"
#end

#def replace_file(file)
  #system %Q{rm -rf "$HOME/.#{file.sub('.erb', '')}"}
  #link_file(file)
#end

#def link_file(file)
  #if file =~ /.erb$/
    #puts "generating ~/.#{file.sub('.erb', '')}"
    #File.open(File.join(ENV['HOME'], ".#{file.sub('.erb', '')}"), 'w') do |new_file|
      #new_file.write ERB.new(File.read(file)).result(binding)
    #end
  #else
    #puts "linking ~/.#{file}"
    #system %Q{ln -s "$PWD/#{file}" "$HOME/.#{file}"}
  #end
#end
