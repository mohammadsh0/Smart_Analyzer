file_path = 'D:\smarts.mylinux'
with open(file_path, 'r') as smart_file:
    smart_var = smart_file.readlines()

start_line_nums = []
first_lines = []
last_line = 0
for line_num, line in enumerate(smart_var):
    last_line += 1
    if 'smartctl -a' in line:
        first_lines.append(line)
        start_line_nums.append(line_num)


# print(start_line_nums)
end_line_nums = []
for line_num in start_line_nums:
    if line_num == 0:
        pass
    else:
        end_line_nums.append(line_num - 1)

end_line_nums.append(last_line)
# print(end_line_nums)
# print(last_line)
# print(len(start_line_nums), len(end_line_nums))
device_id = []
for line in first_lines:
    index = (line.index(','))
    device_id.append(line[index+1:].strip())

print(len(smart_var))
print(end_line_nums)
print(start_line_nums)
i = 0
for line_num, line in enumerate(smart_var):
    print(start_line_nums[i], end_line_nums[i])
    # if line_num in range(start_line_nums[i], end_line_nums[i]):
        # print(line)
    i += 1
# print(len(first_lines))
# print(device_id)