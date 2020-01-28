function parser_import(file_path, separator=',')
    open(file_path) do f
        content = readlines(f)
        parser = []
        for index in range(2, stop = length(content))
            append!(parser, [split(content[index],separator)])
        end
        return parser
    end
end
parser_import("test.csv")
