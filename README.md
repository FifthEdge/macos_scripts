These three scripts are useful for bundling a macOS application with it's dependencies.

copy_dep_dylibs.zsh recursivly copies a dependency into a given folder. Ideally the Frameworks folder.
change_dep_dylib_install_names.zsh changes the runpath names of the copied dependencies so they can be found. 
sign_dep_dylibs.zsh re-signs said dependencies for notorization.
