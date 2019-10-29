#[0,1,0,2,1,0,1,3,2,1,2,1]
#out:6
# 难点：需要记住每个height , 
# to: mark every Max
# [2,1,2]中间也接水的
def get_next_max_point(ob):
	global start
	part=ob[start+1:len(ob)]
	print("part:",part)
	gap=0
	decreasing_len=0
	min=0
	max=0
	for k in range(0,len(part)-1):
		gap = gap +1

		if part[k+1] <= part[k]:
			decreasing_len=decreasing_len+1
		else:
			break
	increasing_len=decreasing_len
	for k in range(decreasing_len,len(part)-1):
		gap = gap +1
		if part[k+1] >= part[k]:
			increasing_len=increasing_len+1
		else:
			break

			
			
	return decreasing_len, increasing_len

def get_left_right(i,ob):
	right = ob[i+1:]
	left = ob[:i-1]

	return min(max(left,default=0) ,max(right,default=0) )
	

def trap_ok(ob):
	area=0
	for i in range(1,len(ob)-1):
		hold = get_left_right(i,ob)
		if hold > ob[i]:
			area = area + get_left_right(i,ob)-ob[i]
			print (get_left_right(i,ob)," ", ob[i])
	print (area)


def (ob): #not working
	area=0
	for i in range(1,len(ob)-1):
		print(i)
		if ob[i]>0: #and ob[i+1]<=ob[i]:
			start=i

			tp=get_next_max_point(ob)

			print (tp)
			if ob[i] >= tp[1]:
				area=tp[0]*tp[1]
			else:
				area=ob[i]*tp[1]

			#print (area," ok")
trap_ok([0,3,4,2,0,1,3,1,1,0,1,2,1])
'''
Intuition
Water trap: evaluate each bar separately!
)

which is equal to the minimum of maximum height of bars on both the sides minus its own height.


'''