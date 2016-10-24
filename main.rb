require_relative 'lib/controller'

begin
	service = Controller.new
	service.start 
rescue => e
	error_log = File.new('log.txt','w')
	error_log << e
	error_log.close
end