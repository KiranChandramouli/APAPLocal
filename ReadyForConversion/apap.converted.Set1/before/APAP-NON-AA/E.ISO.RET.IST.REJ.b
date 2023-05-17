*-----------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------
  SUBROUTINE E.ISO.RET.IST.REJ(Y.ID.LIST)
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.SPF
$INSERT I_AT.ISO.COMMON



  Y.ID.LIST = "STATUS:1:1=":R.SPF.SYSTEM<SPF.OP.MODE>
  Y.ID.LIST:=',UNIQUE.TXN.CODE:1:1=1'
  Y.ID.LIST := ',Y.ISO.RESPONSE:1:1=00'
  AT$AT.ISO.RESP.CODE=AT$INCOMING.ISO.REQ(39)

  IF AT$AT.ISO.RESP.CODE NE '00' THEN
    CALL REDO.UPD.ATM.REJ
  END

  RETURN
END
