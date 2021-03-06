require 'resolv'

class Redmine::Resolver < Resolv
  def initialize
    @cache = {}
    %w(getaddresses getnames getaddress getname).each do |method|
      @cache[method.to_sym] = {}
    end
    super
  end
  
  def getaddresses(name)
    @cache[:getaddresses][name] ||= super(name).map{|a|a.to_s}
  end
  
  def getnames(address)
    @cache[:getnames][address] ||= super(address).map{|a|a.to_s}
  end
  
  def getaddress(name)
    @cache[:getaddress][name] ||= super(name).to_s
  end
  
  def getname(address)
    @cache[:getnames][address] ||= super(address).to_s
  end
  
  def deeplook(info)
    ret = []
    while info && !ret.include?(info) && ret.length <= 30
      ret << info
      info = (ipaddress?(info) ? getname(info) : getaddress(info))
    end
    ret
  end
  
  def ipaddress?(string)
    string.match(/^(?:\d+\.){3}\d+$/)
  end 
end
