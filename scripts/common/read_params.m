% Authors:
% Date: May 05, 2022
% Goal: Encouraging research on ML/DL for sensing applications and
% providing a benchmarking tool for the developed algorithms
% ---------------------------------------------------------------------- %

function params = read_params(varargin) % filename, struct_name, main_file
    filename =  varargin{1};
    struct_name =  varargin{2};
    main_file = 0;
    if nargin == 3
        main_file = varargin{3};
    end
    
    if ~isfile(filename)
        run(main_file);
        assert(exist(struct_name, 'var'), sprintf('The %s parameters is not found.', struct_name));
    else
        run(filename);
        assert(exist(struct_name, 'var'), sprintf('The %s parameters (%s) must be contained in a struct named %s', struct_name, filename, struct_name));
    end
    
    eval(strcat('params=', struct_name, ';'));
end
