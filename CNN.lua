local base = {
    {0, 0, 0, 0, 0},
    {0, 1, 1, 1, 0},
    {0, 0, 0, 1, 0},
    {0, 0, 0, 1, 0},
    {0, 0, 0, 1, 0},
}

local filter = {
    {1, 0, 1},
    {0, 1, 0},
    {1, 0, 1},
}
-- You can have etc. 5 x 3 filters mapped on 7 x 9 matrices.
local output = {}

-- Filter column & row fitting / check how many placements can be made.
local matrix_fitting_y = (#base - #filter) + 1 -- +1 for first placement & fit in column
local matrix_fitting_x = (#base[1] - #filter[1]) + 1 --  -||- fit in row

-- Construct size of output
for output_tbls = 1, matrix_fitting_y do
    table.insert(output, {})
    for output_vals = 1, matrix_fitting_x do
        table.insert(output[output_tbls], 0)
    end
end

-- Per output y and x, we calculate the y, x index of filter toward base & sum it into output.
for mxf_y = 1, matrix_fitting_y do
    for mxf_x = 1, matrix_fitting_x do
        for y = 1, #filter do
            for x = 1, #filter[1] do
                local calc = base[(mxf_y + y)-1][(mxf_x + x)-1] * filter[y][x]
                if calc >= 1 then
                    output[mxf_y][mxf_x] += calc
                end
            end
        end
    end
end

print(output)