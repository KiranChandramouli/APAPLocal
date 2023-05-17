*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.AUT.REV.NXT.DAY.FT.ID
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : TAM
* Program Name  : REDO.AUT.REV.NXT.DAY.FT.ID
* ODR NUMBER    : HD1052244
*-------------------------------------------------------------------------------
* Description   : This is auth routine will be attached to the version FT,CHQ.TAX
* In parameter  : none
* out parameter : none
*-------------------------------------------------------------------------------
* Modification History :
*-------------------------------------------------------------------------------
*   DATE             WHO             REFERENCE         DESCRIPTION
* 21-01-2011      MARIMUTHU S        HD1052244       Initial Creation
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

  Y.ID = APPLICATION:PGM.VERSION
  CALL F.READ(FN.REDO.TEMP.VERSION.IDS,Y.ID,R.REC.TEMP,F.REDO.TEMP.VERSION.IDS,TEMP.ERR)
  Y.TXN.IDS = R.REC.TEMP<REDO.TEM.TXN.ID>
  Y.PRV.IDS = R.REC.TEMP<REDO.TEM.PRV.TXN.ID>

  LOCATE ID.NEW IN Y.TXN.IDS<1,1> SETTING POS THEN
    DEL Y.TXN.IDS<1,POS>
    DEL Y.PRV.IDS<1,POS>
    R.REC.TEMP<REDO.TEM.TXN.ID> = Y.TXN.IDS
    R.REC.TEMP<REDO.TEM.PRV.TXN.ID> = Y.PRV.IDS

    CALL F.WRITE(FN.REDO.TEMP.VERSION.IDS,Y.ID,R.REC.TEMP)
  END

  RETURN
*-------------------------------------------------------------------------------
END
