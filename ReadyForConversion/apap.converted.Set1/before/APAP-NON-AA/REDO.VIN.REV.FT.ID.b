*-----------------------------------------------------------------------------
* <Rating>-62</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.VIN.REV.FT.ID
*-----------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : TAM
* Program Name  : REDO.VIN.REV.FT.ID
* ODR NUMBER    : HD1052244
*-------------------------------------------------------------------------------
* Description   : This is input routine, will be attached to the version FT,REVERSE.CHQ
* In parameter  : none
* out parameter : none
*-------------------------------------------------------------------------------
* Modification History :
*-------------------------------------------------------------------------------
*   DATE             WHO             REFERENCE         DESCRIPTION
* 20-01-2011      MARIMUTHU S        HD1052244       Initial Creation
*-------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.FUNDS.TRANSFER
$INSERT I_F.TELLER
$INSERT I_F.REDO.TEMP.VERSION.IDS
  GOSUB MAIN
  RETURN
*-------------------------------------------------------------------------------
MAIN:
*-------------------------------------------------------------------------------

  FN.REDO.TEMP.VERSION.IDS = 'F.REDO.TEMP.VERSION.IDS'
  F.REDO.TEMP.VERSION.IDS = ''
  CALL OPF(FN.REDO.TEMP.VERSION.IDS,F.REDO.TEMP.VERSION.IDS)

  GOSUB REVERSE.PROCESS
  GOSUB INPUT.PROCESS
  RETURN
*--------------------------------------------------------------------------------
REVERSE.PROCESS:
*-------------------------------------------------------------------------------
  IF V$FUNCTION EQ 'R' THEN
    SEL.CMD = 'SELECT ':FN.REDO.TEMP.VERSION.IDS:' WITH AUT.TXN.ID EQ ':ID.NEW
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,SEL.ERR)
    CALL F.READ(FN.REDO.TEMP.VERSION.IDS,SEL.LIST,R.REC.TEMP,F.REDO.TEMP.VERSION.IDS,TEMP.ERR)
    Y.AUT.IDS = R.REC.TEMP<REDO.TEM.AUT.TXN.ID>
    Y.AUT.DATES = R.REC.TEMP<REDO.TEM.PROCESS.DATE>
    LOCATE ID.NEW IN Y.AUT.IDS<1,1> SETTING POS THEN
      DEL Y.AUT.IDS<1,POS>
      DEL Y.AUT.DATES<1,POS>
      R.REC.TEMP<REDO.TEM.AUT.TXN.ID> = Y.AUT.IDS
      R.REC.TEMP<REDO.TEM.PROCESS.DATE> = Y.AUT.DATES
      Y.REV.ID = R.REC.TEMP<REDO.TEM.REV.TXN.ID>
      Y.REV.DATE = R.REC.TEMP<REDO.TEM.REV.TXN.DATE>
      Y.CNT = DCOUNT(Y.REV.ID,VM)
      R.REC.TEMP<REDO.TEM.REV.TXN.ID,Y.CNT+1> = ID.NEW
      R.REC.TEMP<REDO.TEM.REV.TXN.DATE,Y.CNT+1> = TODAY
      CALL F.WRITE(FN.REDO.TEMP.VERSION.IDS,SEL.LIST,R.REC.TEMP)
    END
  END
  RETURN
*---------------------------------------------------------------------------------------------------------------
INPUT.PROCESS:
*---------------------------------------------------------------------------------------------------------------

  IF V$FUNCTION EQ 'I' THEN
* FOR VERSION FT,MGR.REVERSE.CHQ
    IF PGM.VERSION EQ ',MGR.REVERSE.CHQ' THEN
      GOSUB FT.CHEQUE
    END ELSE
      GOSUB ELSE.PART
    END
    GOSUB TT.PART
  END
  RETURN
*---------------------------------------------------------------------------------
FT.CHEQUE:
*----------------------------------------------------------------------------------
  Y.ID = 'FUNDS.TRANSFER,MGR.REVERSE.CHQ.AUT'
  CALL BUILD.USER.VARIABLES(Y.DATA)
  Y.FT.ID = FIELD(Y.DATA,"*",2)
  CALL F.READ(FN.REDO.TEMP.VERSION.IDS,Y.ID,R.REC.TEMP.VERSION,F.REDO.TEMP.VERSION.IDS,TEMP.ERR)
  IF R.REC.TEMP.VERSION EQ '' THEN
    R.REC.TEMP<REDO.TEM.TXN.ID> = ID.NEW
    R.REC.TEMP<REDO.TEM.PRV.TXN.ID> = Y.FT.ID
    R.NEW(FT.MESSAGE) = Y.FT.ID
    CALL F.WRITE(FN.REDO.TEMP.VERSION.IDS,Y.ID,R.REC.TEMP)
  END ELSE
    Y.TXN.ID = R.REC.TEMP.VERSION<REDO.TEM.TXN.ID>
    Y.CNT = DCOUNT(Y.TXN.ID,VM)
    R.REC.TEMP.VERSION<REDO.TEM.TXN.ID,Y.CNT+1> = ID.NEW
    R.NEW(FT.MESSAGE) = Y.FT.ID
    R.REC.TEMP.VERSION<REDO.TEM.PRV.TXN.ID,Y.CNT+1> = Y.FT.ID
    CALL F.WRITE(FN.REDO.TEMP.VERSION.IDS,Y.ID,R.REC.TEMP.VERSION)
  END
  RETURN
*---------------------------------------
ELSE.PART:
*-----------------------------------------
  Y.ID = 'FUNDS.TRANSFER,REVERSE.CHQ.NXT.AU'
  CALL BUILD.USER.VARIABLES(Y.DATA)
  Y.FT.ID = FIELD(Y.DATA,"*",2)
  CALL F.READ(FN.REDO.TEMP.VERSION.IDS,Y.ID,R.REC.TEMP.VERSION,F.REDO.TEMP.VERSION.IDS,TEMP.ERR)
  IF R.REC.TEMP.VERSION EQ '' THEN
    R.REC.TEMP<REDO.TEM.TXN.ID> = ID.NEW
    R.REC.TEMP<REDO.TEM.PRV.TXN.ID> = Y.FT.ID
    CALL F.WRITE(FN.REDO.TEMP.VERSION.IDS,Y.ID,R.REC.TEMP)
  END ELSE
    Y.TXN.ID = R.REC.TEMP.VERSION<REDO.TEM.TXN.ID>
    Y.CNT = DCOUNT(Y.TXN.ID,VM)
    R.REC.TEMP.VERSION<REDO.TEM.TXN.ID,Y.CNT+1> = ID.NEW
    R.REC.TEMP.VERSION<REDO.TEM.PRV.TXN.ID,Y.CNT+1> = Y.FT.ID
    CALL F.WRITE(FN.REDO.TEMP.VERSION.IDS,Y.ID,R.REC.TEMP.VERSION)
  END
  RETURN
*----------------------------------------------------
TT.PART:
*---------------------------------------------------
*FOR VERSION TELLER,CASH.CHQ
  IF PGM.VERSION EQ ',CASH.CHQ' THEN
    Y.ID = 'TELLER,CASH.CHQ.AUT'
    CALL BUILD.USER.VARIABLES(Y.DATA)
    Y.TT.ID = FIELD(Y.DATA,"*",2)
    CALL F.READ(FN.REDO.TEMP.VERSION.IDS,Y.ID,R.REC.TEMP.VERSION,F.REDO.TEMP.VERSION.IDS,TEMP.ERR)
    IF R.REC.TEMP.VERSION EQ '' THEN
      R.REC.TEMP<REDO.TEM.TXN.ID> = ID.NEW
      R.REC.TEMP<REDO.TEM.PRV.TXN.ID> = Y.TT.ID
      R.NEW(TT.MESSAGE) = Y.TT.ID
      CALL F.WRITE(FN.REDO.TEMP.VERSION.IDS,Y.ID,R.REC.TEMP)
    END ELSE
      Y.TXN.ID = R.REC.TEMP.VERSION<REDO.TEM.TXN.ID>
      Y.CNT = DCOUNT(Y.TXN.ID,VM)
      R.REC.TEMP.VERSION<REDO.TEM.TXN.ID,Y.CNT+1> = ID.NEW
      R.NEW(TT.MESSAGE) = Y.TT.ID
      R.REC.TEMP.VERSION<REDO.TEM.PRV.TXN.ID,Y.CNT+1> = Y.TT.ID
      CALL F.WRITE(FN.REDO.TEMP.VERSION.IDS,Y.ID,R.REC.TEMP.VERSION)
    END
  END
  RETURN
*-------------------------------------------------------------------------------
END
