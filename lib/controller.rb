require 'clipboard'
require 'win32/sound'
require_relative 'fetch'

class Controller
	DELTA_TIME = 3 #sec
	PROGRAM_STATUS = 
	    {
	    	'stop' => 0,
	    	'detect' => 1,
	    	'found' => 2,
	    }

	def initialize
		@status = PROGRAM_STATUS['stop']
		@fetch = Fetch.new
	end

	def start
		@status = PROGRAM_STATUS['detect']
		depatch_state
	end

	private
	def depatch_state
		puts '開始偵測'
		while @status != PROGRAM_STATUS['stop']
			case @status
			when PROGRAM_STATUS['detect']
				sleep DELTA_TIME
				@new_rows = @fetch.new_rows				
				puts "偵測中...\t\t" + DateTime.now.strftime('%H:%M:%S')		
				@status = PROGRAM_STATUS['found'] if @new_rows
			when PROGRAM_STATUS['found']
				id = @new_rows[0][1]
				puts "發現目標ID: #{id}, 複製中..."
				Clipboard.copy id
				Win32::Sound.play('alert.wav') 
				@status = PROGRAM_STATUS['detect'] 
			end
		end
	end
end