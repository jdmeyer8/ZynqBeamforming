for i = 1:64
    gs1_i_f(i:64:end) = flipud(gs1_i(i:64:end));
    gs1_q_f(i:64:end) = flipud(gs1_q(i:64:end));
    gs2_i_f(i:64:end) = flipud(gs2_i(i:64:end));
    gs2_q_f(i:64:end) = flipud(gs2_q(i:64:end));
end

gs1_i_f = flipud(gs1_i_f);
gs1_q_f = flipud(gs1_q_f);
gs2_i_f = flipud(gs2_i_f);
gs2_q_f = flipud(gs2_q_f);