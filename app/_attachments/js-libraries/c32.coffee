class C32

  @ENCODE_MAP : {"o":"0","O":"0","0":"0","i":"1","I":"1","l":"1","1":"1","2":"2","3":"3","4":"4","5":"5","6":"6","7":"7","8":"8","9":"9","a":"A","A":"A","B":"B","c":"C","C":"C","d":"D","D":"D","e":"E","E":"E","f":"F","F":"F","g":"G","G":"G","h":"H","H":"H","j":"J","J":"J","k":"K","K":"K","m":"M","M":"M","n":"N","N":"N","p":"P","P":"P","q":"Q","Q":"Q","r":"R","R":"R","s":"S","S":"S","t":"T","T":"T","v":"V","V":"V","w":"W","W":"W","x":"X","X":"X","y":"Y","Y":"Y","z":"Z","Z":"Z"}
  @POOL : "0123456789ABCDEFGHJKMNPQRSTVWXYZ".split("")
  @POOL_MAP : {"0":0,"1":1,"2":2,"3":3,"4":4,"5":5,"6":6,"7":7,"8":8,"9":9,"A":10,"B":11,"C":12,"D":13,"E":14,"F":15,"G":16,"H":17,"J":18,"K":19,"M":20,"N":21,"P":22,"Q":23,"R":24,"S":25,"T":26,"V":27,"W":28,"X":29,"Y":30,"Z":31}
  @CHECKSUM_POOL : "0123456789ABCDEFGHJKMNPQRSTVWZYZ*~$=U".split("")

  constructor: ->
    @value = "0"

  parseInt: ( unclean = "" ) =>
    @value = (C32.ENCODE_MAP[c] for c in unclean).join("")

  toTen: ( value = @value ) =>
    _(C32.POOL_MAP[n] * Math.pow(32,value.length-(i+1)) for n, i in value).reduce((a,b)->a+b)

  addChecksum: =>
    checksum = @calcChecksum()
    @value = @value + checksum

  calcChecksum: ( ten = @toTen() ) =>
    C32.CHECKSUM_POOL[ten % 37]

  isValid: ( value = @value ) =>
    return value.substr(-1,1) == @calcChecksum(@toTen(value.substring(0, value.length-1)))

  getRandom: ( length = 0 ) =>
    @value = ( $(C32.POOL).getRandom() for i in [0..length-1] ).join("")
