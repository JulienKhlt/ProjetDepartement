function parser_import(file_path, hasheader=true, separator=',')
    i = 1 + hasheader
    open(file_path) do f
        content = readlines(f)
        parser = []
        for index in range(i, stop = length(content))
            append!(parser, [split(content[index],separator)])
        end
        return parser
    end
end
parser_import("Itineraires.csv")
