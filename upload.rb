require 'optparse'
require 'qiniu'
options = {}
OptionParser.new do |opts|
  opts.banner = '获取命令行参数'
  opts.on('-a A,B', "--array A,B",Array, "list of arguments") do |v|
    options[:array] = v
  end
end.parse!
qnak = options[:array][0]
qnsk = options[:array][1]
qnbut = options[:array][2]
#要上传文件的本地路径
filepath = options[:array][3]
key = File.basename(filepath)
#puts qnak,qnsk,qnbut,filepath
#exit()
Qiniu.establish_connection! :access_key => qnak,
                            :secret_key => qnsk
#构建上传策略
put_policy = Qiniu::Auth::PutPolicy.new(
    qnbut,      # 存储空间
    key,   # 最终资源名，可省略，即缺省为“创建”语义，设置为nil为普通上传 
    3600    #token过期时间，默认为3600s
)
#生成上传 Token
uptoken = Qiniu::Auth.generate_uptoken(put_policy)

#调用upload_with_token_2方法上传
if File::exists?(filepath)
  code, result, response_headers = Qiniu::Storage.upload_with_token_2(
       uptoken, 
       filepath,
       key
  )
  puts code
  puts result
  if File::exists?("qnfilename")
    aa = File.open("qnfilename").readlines 
    #删除资源
      code, result, response_headers = Qiniu::Storage.delete(
      qnbut,     # 存储空间
      aa[0]         # 资源名
    )  
    puts '删除之前的备份'
    puts code
    puts result
    puts response_headers
  end
  File.open('qnfilename','w') do |f|
  f.write(key)
  f.close
end
else
  p filepath+"  not exists"
end
