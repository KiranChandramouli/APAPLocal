*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE E.ISO.RET.SPF.STATUS.REV(Y.ID.LIST)
  $INSERT I_COMMON
  $INSERT I_EQUATE
  $INSERT I_ENQUIRY.COMMON
  $INSERT I_F.SPF


  Y.ID.LIST = "STATUS:1:1=":R.SPF.SYSTEM<SPF.OP.MODE>
  Y.ID.LIST:=',UNIQUE.TXN.CODE:1:1=1'
  Y.ID.LIST := ',Y.ISO.RESPONSE:1:1='

  Y.ID.LIST := '00'

  RETURN
END
