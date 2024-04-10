import vweb
import net
import strings
import encoding.hex

struct App {
    vweb.Context
}

struct WolRequest {
    mac          string @[required]
    broadcast_ip string
}

// 十六进制字符串转字节数组
fn hex_to_bytes(hex_str string) ![]u8 {
    if hex_str.len % 2 != 0 {
        return error('Invalid hex string')
    }
    mut bytes := []u8{len: hex_str.len / 2}
    for i in 0 .. bytes.len {
        bytes[i] = hex.decode(hex_str[i * 2..i * 2 + 2])![0]        
    }
    return bytes
}

// 发送 Wake-on-LAN 魔术包的函数
fn send_wol_packet(mac_address string, broadcast_ip string) !bool {
    mut socket := net.dial_udp("${broadcast_ip}:9")!
    socket.sock.set_option_bool(net.SocketOption.broadcast, true)!
    

    // 构建一个魔术包，它以 6 个 0xFF 字节开始
    mut magic_packet := strings.repeat_string("FF", 6)

    // 然后跟随 16 个目标 MAC 地址的重复
    mac_hex := mac_address.replace(':', '').replace('-', '')
    for _ in 0 .. 16 {
        magic_packet += mac_hex
    }

    // 转换十六进制字符串到字节数组
    packet := hex_to_bytes(magic_packet)!
    //packet:=mac_address.bytes()
    // 发送魔术包
    socket.write(packet)!

    socket.close()!
    return true
}

fn main() {
    mut app := App{}
    vweb.run<App>(app, 8009)
}

@['/wake-on-lan'; get]
pub fn (mut app App) send_wol() vweb.Result {

    wol_req := WolRequest{
        mac: app.query['mac']
        broadcast_ip: app.query['ip'] or { '255.255.255.255' }
    }

    send_wol_packet(wol_req.mac, wol_req.broadcast_ip) or {
        app.error("Error sending WOL packet: $err")
    }
    return app.ok('Magic packet sent successfully to $wol_req.mac')
}