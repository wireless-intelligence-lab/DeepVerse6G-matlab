% Check the validity of the given parameters
% Add default parameters if they don't exist in the current file
function [params] = compare_default_params(params, default_params_name, type)

    % Load Default Parameters
    run(default_params_name);
    eval(strcat('default_params = ', type, ';'));
    
    default_fields = fieldnames(default_params);
    fields = fieldnames(params);
    default_fields_exist = zeros(1, length(default_fields));
    for i = 1:length(fields)
        comp = strcmp(fields{i}, default_fields);
        if sum(comp) == 1
            default_fields_exist(comp) = 1;
        else
            if ~strcmp(fields{i}, "dataset_folder") % Exception for the dataset folder - this may not be defined
                fprintf('\nThe parameter "%s" defined in the given parameters is not used by the generator', fields{i}) 
            end
        end
    end
    default_fields_exist = ~default_fields_exist;
    default_nonexistent_fields = find(default_fields_exist);
    for i = 1:length(default_nonexistent_fields)
        field = default_fields{default_nonexistent_fields(i)};
        value = getfield(default_params, field);
        params = setfield(params, field, value);
        % fprintf('\nAdding default parameter: %s - %s', field, num2str(value)) 
    end
end