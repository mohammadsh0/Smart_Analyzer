import string
import os


class Smart():
    """Reads, organizes and exports Smart data into a csv file"""
    
    def __init__(self):
        # list of Device Id's
        self.devID = []
        # list of all of the lines in smart file
        self.smart_list = []
        # list of every line starting with a new smart disk data
        self.disk_start_line = []
        # The separated list of all disk smart's data
        self.all_disks = []
        # A dict containing all disks with each disk's parmaters
        # being stored in a nested dict.
        self.disk_param = {}

    def read_smart(self, smart_file):
        """reads smarts file"""
        temp = ''

        # Reading smart file into a list.
        with open(smart_file, 'r') as smartslinux:
            smart = smartslinux.readlines()
        for line in smart:
            self.smart_list.append(line.strip())

        # Extracting Device id's from the lines, and later using them
        # to determine the line numbers of each disk's smart data beginning-
        # -(In the divider method)
        for line in self.smart_list:
            if 'Command smartctl -a' in line:
                temp = ''.join(char for char in line if char in string.digits)
                self.devID.append(temp[1:])

        # Creating a list of lists, and later using it to store each
        # disk's smart data into a sublist of this list. (In the extract method)
        for _ in range(len(self.devID)):
            self.all_disks.append([])

    def divider(self):
        """Determines the start line of each disk's smart data"""
        item_index = 0
        # Using index of the line containing the devID to determine the
        # start of each disk's smart data and appending the line numbers
        # to a list called disk_start_line and using it later to divide
        # the smart file into separate disk's smart data.
        for item in self.devID:
            txt = f'Command smartctl -a /dev/bus/0 -d megaraid,{item}'
            for i in self.smart_list:
                if txt in i:
                    item_index = self.smart_list.index(txt)
                    self.disk_start_line.append(item_index) 
    
    def extract(self):
        """Separates each smart data for a disk into a list
        and combines all these lists into one list."""
        for y,num in enumerate(self.disk_start_line):
            if y != len(self.disk_start_line)-1:
                for line in self.smart_list[num:self.disk_start_line[y+1]]:
                    self.all_disks[y].append(line)
            if y == len(self.disk_start_line)-1:
                for line in self.smart_list[num:]:
                    self.all_disks[y].append(line)
    
    def save_to_dir(self):
        """I. Creates a new path for separated smart files to be saved to.\n
        II. Saves each smart file into a file named after devID."""
        current_path = os.getcwd()
        isdir = os.path.isdir(f'{current_path}/separated_smarts/')
        if not isdir:
            os.mkdir(f'{current_path}/separated_smarts')
        self.smarts_path = f'{os.getcwd()}/separated_smarts'

        for k,item in enumerate(self.devID):
            with open(f'{self.smarts_path}/{item}.txt', 'w') as smart_file:
                for line in self.all_disks[k]:
                    smart_file.write(line+'\n')
                    # smart_file.write('\n')
   
    def device_type(self):
        """Determines the disk type."""

        for item in self.devID:
            self.disk_param[item] = {}

        for item in self.devID:
            with open(f'{self.smarts_path}/{item}.txt', 'r') as smart:
                smart_file = smart.readlines()
            for line in smart_file:
                if 'Device type:          disk' in line:
                    self.disk_param[item]['Disk_type'] = 'HDD'

                    break
                else:
                    self.disk_param[item]['Disk_type'] = 'SSD'


my_hdds = Smart()
my_hdds.read_smart("./smarts.mylinux")
# my_hdds.read_smart("/mnt/c/Users/Mohammad/Desktop/Programming/smart_analyzer/smarts.mylinux")
my_hdds.divider()
my_hdds.extract()
# for line in my_hdds.all_disks[26]:
    # print(line)
my_hdds.save_to_dir()
my_hdds.device_type()
for k,v in my_hdds.disk_param.items():
    print(k,v)