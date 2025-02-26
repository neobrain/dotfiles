set history save
set disassembly-flavor intel
catch throw std::runtime_error
catch throw std::out_of_range
set print pretty

alias ninja = shell ninja
