class Automata:
	def __init__(self):
		pass;

	def get(self, state, signal):
		if(state == 'M'):
			return self._getModified(signal);
		elif(state == 'E'):
			return self._getExclusive(signal);
		elif(state == 'S'):
			return self._getShared(signal);
		elif(state == 'I'):
			return self._getInvalid(signal);
		return [];

	def _getModified(self, signal):
		# if signal is BusRdX or BusRd
		if(signal == 'BX' or signal == 'BR'):
			return ['M','F'];
		# if signal is ProcessorRead or ProccesorWrite
		elif(signal == 'PR' or signal == 'PW'):
			return ['M'];
		return [];

	def _getInvalid(self, signal):
		# if signal is ProcessorRead.
		if(signal == 'PR'):
			return ['D','BR'];
		# if signal is ProcessorWrite.
		elif(signal == 'PW'):	
			return ['M','BX'];
		return [];

	def _getExclusive(self, signal):
		# if signal is ProcessorRead.
		if(signal == 'PR'):
			return ['E'];
		# if signal is ProcessorWrite
		elif(signal == 'PW'):
			return ['M'];
		# if signal is BusRd.
		elif(signal == 'BR'):
			return ['S','F'];
		# if signal is BusRdX.
		elif(signal == 'BX'):
			return ['I','F'];
		return [];

	def _getShared(self, signal):
		# if signal is ProcessorRead.
		if(signal == 'PR'):
			return ['S'];
		# if signal is ProcessorWrite.
		elif(signal == 'PW'):
			return ['M','BX'];
		# if signal is BusRdX.
		elif(signal == 'BX'):
			return ['I','F'];
		# if signal is BusRd.
		elif(signal == 'BR'):
			return ['S','F'];
		return [];
