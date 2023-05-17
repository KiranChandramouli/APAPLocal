*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* <Rating>-21</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.AUT.RTE.AUTH.REV
****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : GANESH R
* Program Name  : REDO.V.AUT.RTE.AUTH.REV
* ODR NUMBER    : ODR-2009-10-0472
*-------------------------------------------------------------------------

* Description : This routine is used to fetch the Ids of FT,Teller for the No file Enquiry REDO.INAO.RTE.TXNS

* In parameter : None
* out parameter : None

*----------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.TELLER
$INSERT I_F.FUNDS.TRANSFER

  GOSUB OPEN.FILES
  GOSUB PROCESS
  RETURN

OPEN.FILES:

*Opening Files
  FN.REDO.FT.TT.REV = 'F.REDO.FT.TT.REV'
  F.REDO.FT.TT.REV = ''
  CALL OPF(FN.REDO.FT.TT.REV,F.REDO.FT.TT.REV)
  RETURN

PROCESS:

*Writing the ID's to the Template

  VAR.CHK.APPLN=APPLICATION
  IF VAR.CHK.APPLN EQ 'FUNDS.TRANSFER' THEN
    VAR.REC.STAT=R.NEW(FT.RECORD.STATUS)
  END
  IF VAR.CHK.APPLN EQ 'TELLER' THEN
    VAR.REC.STAT=R.NEW(TT.TE.RECORD.STATUS)
  END
  IF VAR.REC.STAT EQ 'REVE' THEN
    REV.TXN.ID = ID.NEW
    REV.TXN.ARR = ''

*    WRITE REV.TXN.ARR ON F.REDO.FT.TT.REV,REV.TXN.ID ;*Tus Start 
    CALL F.WRITE(FN.REDO.FT.TT.REV,REV.TXN.ID,REV.TXN.ARR);*Tus End
    IF NOT(RUNNING.UNDER.BATCH) AND NOT(PGM.VERSION) THEN
    CALL JOURNAL.UPDATE('')
    END
    REV.TXN.ID = ''
  END

  RETURN
END
