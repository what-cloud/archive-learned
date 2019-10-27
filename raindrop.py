class Int(object):
	def __init__(self, begin):
		self.begin=begin
		self.new=0
	def add_new(self, new):
		self.new+=new
	def get_begin(self):
		return self.begin
	def get_sum(self):
		return self.begin+self.new
	def __add__(self, new):
		if new.__class__==Int:
			new_begin=self.begin+new.begin
			new_new=self.new+new.new
			result=Int(new_begin)
			result.add_new(new_new)
			return result
def max(the_list):
	"""positive integers"""
	max_num=the_list[0]
	for i in the_list:
		if i == the_list[0]:
			continue
		if i > max_num:
			max_num=[i][0]

def raindrop(drops):
	new=[]
	for i in drops:
		new.append(Int(i))
	max_num=max(drops)
	max_num=Int(max_num)