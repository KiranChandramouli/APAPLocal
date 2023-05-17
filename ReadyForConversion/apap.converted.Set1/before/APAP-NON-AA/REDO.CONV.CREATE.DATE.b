*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CONV.CREATE.DATE
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.STANDING.ORDER

  FN.STO='F.STANDING.ORDER'
  FV.STO=''
  CALL OPF(FN.STO,FV.STO)

  STO.ID = CURRENT.DATA<3>
  CALL F.READ(FN.STO,STO.ID,R.STO.REC,FV.STO,STO.ERR)

  IF NOT(STO.ERR) THEN

    DATE.TEMP=R.STO.REC<STO.DATE.TIME>[1,6]
    DATE.B4CHANGE = ICONV(DATE.TEMP,'D')
    DATE.CREATE = OCONV(DATE.B4CHANGE,'D')
    O.DATA=DATE.CREATE
  END
  RETURN
END
