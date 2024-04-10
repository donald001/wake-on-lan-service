import encoding.hex
fn main(){
	mac_arr:='84-47-09-31-F2-09'.split('-')
	mut mac_byte:=[]u8{cap: 6,len: 0}
	 
	for i:=0;i<mac_arr.len;i++ {
		mac_byte<<hex.decode(mac_arr[i])!
	}
	print(mac_byte)
}