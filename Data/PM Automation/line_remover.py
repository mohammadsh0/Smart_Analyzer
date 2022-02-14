file_path = input('Enter the file path: ')
new_file = f'{file_path[:-4]}New.txt'
with open(file_path, 'r') as file_obj:
    my_file = file_obj.readlines()

to_remove = input('What do you want to remove? ')
deep_level = int(input('how many lines do you want to remove under this line as well?'))
new_file_list = []

for line in my_file:
    if to_remove in line:
        pass
    else:
        new_file_list.append(line)

with open(new_file, 'a') as file_obj:
    for line_obj in new_file_list:
        file_obj.write(line_obj)