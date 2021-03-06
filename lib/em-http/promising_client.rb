begin                                                                                                                                                                                                      
  require 'em-promise'                                                                                                                                                                                     
  module PromisingHttpRequest                                                                                                                                                                              
    def then(success_back = nil, error_back = nil, &blk)                                                                                                                                                   
      deferred = EM::Q.defer                                                                                                                                                                               
                                                                                                                                                                                                           
      self.callback {                                                                                                                                                                                      
        if self.response_header.status == 200                                                                                                                                                              
          deferred.resolve(self)                                                                                                                                                                           
        else                                                                                                                                                                                               
          deferred.reject(self)                                                                                                                                                                            
        end                                                                                                                                                                                                
      }                                                                                                                                                                                                    
      self.errback {                                                                                                                                                                                       
        deferred.reject("Connection failure")                                                                                                                                                              
      }                                                                                                                                                                                                    
      deferred.promise.then(success_back, error_back, &blk)                                                                                                                                                
    end                                                                                                                                                                                                    
                                                                                                                                                                                                           
    def is_a?(klass)                                                                                                                                                                                       
      return true if klass == EventMachine::Q::Promise && ! self.finished?                                                                                                                                 
      super(klass)                                                                                                                                                                                         
    end                                                                                                                                                                                                    
  end                                                                                                                                                                                                      
  EM::HttpClient.send(:include, PromisingHttpRequest)                                                                                                                                                      
rescue LoadError => e                                                                                                                                                                                      
end   
