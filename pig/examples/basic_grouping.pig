%DEFAULT includepath pig/include.pig
RUN $includepath;

%DEFAULT time 60

packets = load '$pcap' using com.packetloop.packetpig.loaders.pcap.packet.PacketLoader() AS (
    ts,

    ip_version:int,
    ip_header_length:int,
    ip_tos:int,
    ip_total_length:int,
    ip_id:int,
    ip_flags:int,
    ip_frag_offset:int,
    ip_ttl:int,
    ip_proto:int,
    ip_checksum:int,
    ip_src:chararray,
    ip_dst:chararray,

    tcp_sport:int,
    tcp_dport:int,
    tcp_seq_id:long,
    tcp_ack_id:long,
    tcp_offset:int,
    tcp_ns:int,
    tcp_cwr:int,
    tcp_ece:int,
    tcp_urg:int,
    tcp_ack:int,
    tcp_psh:int,
    tcp_rst:int,
    tcp_syn:int,
    tcp_fin:int,
    tcp_window:int,
    tcp_len:int,

    udp_sport:int,
    udp_dport:int,
    udp_len:int,
    udp_checksum:chararray
);

packets = group packets by tcp_dport; 

packets = FOREACH packets GENERATE group, COUNT(packets) as count_packets;

ordered = ORDER packets by count_packets desc; 

limit_packets = LIMIT ordered 10;

DUMP limit_packets;
