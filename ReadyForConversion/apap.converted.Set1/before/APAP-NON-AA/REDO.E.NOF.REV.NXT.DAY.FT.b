*-----------------------------------------------------------------------------
* <Rating>-21</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.E.NOF.REV.NXT.DAY.FT(Y.FIN.ARR)
*-----------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : TAM
* Program Name  : REDO.E.NOF.REV.NXT.DAY.FT
* ODR NUMBER    : HD1052244
*-------------------------------------------------------------------------------
* Description   : This is nofile routine will be attached to the enquiry REDO.DISPLAY.REV.FT.ENQ
* In parameter  : none
* out parameter : Y.FIN.ARR
*-------------------------------------------------------------------------------
* Modification History :
*-------------------------------------------------------------------------------
*   DATE             WHO             REFERENCE         DESCRIPTION
* 19-01-2011      MARIMUTHU S        HD1052244       Initial Creation
*-------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.FUNDS.TRANSFER
$INSERT I_F.REDO.TEMP.VERSION.IDS
*-------------------------------------------------------------------------------
MAIN:
*-------------------------------------------------------------------------------

  FN.REDO.TEMP.VERSION.IDS = 'F.REDO.TEMP.VERSION.IDS'
  F.REDO.TEMP.VERSION.IDS = ''
  CALL OPF(FN.REDO.TEMP.VERSION.IDS,F.REDO.TEMP.VERSION.IDS)

  SEL.CMD = 'SELECT ':FN.REDO.TEMP.VERSION.IDS:' WITH @ID LIKE FUNDS.TRANSFER,CHQ...'
  CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,SEL.ERR)

  LOOP
    REMOVE Y.TEMP.ID FROM SEL.LIST SETTING POS
  WHILE Y.TEMP.ID:POS
    CALL F.READ(FN.REDO.TEMP.VERSION.IDS,Y.TEMP.ID,R.REC.TEMP,F.REDO.TEMP.VERSION.IDS,TEMP.ERR)
    Y.AUT.ID = R.REC.TEMP<REDO.TEM.AUT.TXN.ID>
    Y.AUT.DATE = R.REC.TEMP<REDO.TEM.PROCESS.DATE>
    Y.CNT = DCOUNT(Y.AUT.DATE,VM)
    FLG = ''
    LOOP
    WHILE Y.CNT GT 0 DO
      FLG += 1
      IF Y.AUT.DATE<1,FLG> LT TODAY THEN
        Y.FIN.ARR<-1> = Y.AUT.ID<1,FLG>
      END
      Y.CNT -= 1
    REPEAT
  REPEAT

  RETURN
*-------------------------------------------------------------------------------
END
