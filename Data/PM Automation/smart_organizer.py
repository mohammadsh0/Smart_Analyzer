file_path = 'D:\smarts.mylinux'



with open(file_path, 'r') as smart_data:
    smart_var = smart_data.readlines()
# i=0
# lines_to_print = [i+5, i+6, i+8, i+16, i+18, i+25, i+27, i+35, i+45]
smart_data = ['smartctl -a', 'product', 'revision', 'user capacity', 'serial number', 'device type', 'transport protocol', 'smart health', 'current drive temp', 'elements', 'powered up', 'reallocated_sector_ct', 'used_rsvd_blk_cnt_tot', 'unused_rsvd_blk_cnt_tot', 'runtime_bad_block', 'Firmware Version']
for line_num, line in enumerate(smart_var):
    for item in smart_data:
        if item in line.lower():
            print(line_num, line)
        