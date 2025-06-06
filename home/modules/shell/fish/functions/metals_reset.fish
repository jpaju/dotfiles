function metals_reset
	remove_folder .bloop/
	remove_folder .bsp/
	remove_folder .metals/
	remove_folder .scala-build/
	remove_folder project/.bloop/
	remove_folder project/project/
	remove_folder project/target/
	remove_folder target/
	remove_file project/metals.sbt
end

function remove_folder 
	if test -d $argv[1]
		echo (set_color red)Removing folder: (set_color normal)$argv[1]
		rm -rf $argv[1]
	else
		echo (set_color cyan)Folder not found: (set_color normal)$argv[1]
	end
end

function remove_file 
	if test -f $argv[1]
		echo (set_color red)Removing file: (set_color normal)$argv[1]
		rm $argv[1]
	else
		echo (set_color cyan)File not found: (set_color normal)$argv[1]
	end
end
