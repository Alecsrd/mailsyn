class Host

	attr_reader :host, :port, :ssl, :connection

	def initialize(_options)
		@host = _options['host']
		@port = _options['port']
		@ssl = _options['ssl']
		@connection = Net::IMAP.new(@host, @port, @ssl)
	end

	def userLogin(_user,_password)
		@connection.login(_user,_password)
	end

	def getListOfFolders
		foldersList = Array.new
		unParseFoldersList = @connection.list("","*")
		unParseFoldersList.each do |f|
			#if f.attr[1].to_s == 'Hasnochildren'
				foldersList << f.name
			#end
		end
		foldersList
	end

	def setListOfFolders(_foldersList)
		_foldersList.each do |f|
			begin
				@connection.create(f)
			rescue => e

			end
		end
	end

	def getIdsFromFolder(_folder)
		@connection.examine(_folder)
		@connection.uid_search(['ALL'])

		#puts uids[1,20]
		#puts @connection.capability
		#puts "---------------"
		#puts @connection.getacl('apopov@itprogress.ru')
		#uids = @connection.uid_search(['ALL'])
		#puts uids
		#@connection.create("foo/bar")
		#puts @connection.list("","*")#[5][0]
		#@connection.create("Mail|sent-apeeeeeee")
		#msgs = @connection.search(["SINCE","30-Apr-2016"])
		#puts msgs.to_s
		#msgs.each do |mid|
 		#	env = @connection.fetch(mid, "FULL")
 		#	puts "#{env.to_s}"
 		#	#{}puts mid
		#end
		###test = @connection.uid_fetch(887, ['RFC822'])#['RFC822', 'FLAGS','INTERNALDATE'])
		###puts test[0].attr['FLAGS']

		#test = @connection.fetch([88], ["UID","RFC822"]).first
		#puts test.attr['RFC822']

		#msgs.each do |mid|
 		#	env = imap.fetch(mid, "ENVELOPE")[0].attr["ENVELOPE"]
 		#	puts "От #{env.from[0].name} #{env.subject}"
		#end
	end

	def getMessagesByIds(_folder,_ids)
		msgs = Array.new
		@connection.examine(_folder)
      	@connection.uid_fetch([_ids], ['RFC822', 'FLAGS','INTERNALDATE'])
	end

	def setMessages(_folder,_msgs)
		_msgs.each do |m|
			@connection.append(_folder, m.attr['RFC822'], m.attr['FLAGS'],m.attr['INTERNALDATE'])
		end
	end

	def getSizeOfFolder(_folder)
		uids = getIdsFromFolder(_folder)
		#@connection.examine(_folder)
		msgs = @connection.uid_fetch(uids, 'RFC822.SIZE')
		sizeOfMailbox = 0
		msgs.each do |m|
			sizeOfMailbox += m.attr['RFC822.SIZE']
		end
		sizeOfMailbox
	end
end