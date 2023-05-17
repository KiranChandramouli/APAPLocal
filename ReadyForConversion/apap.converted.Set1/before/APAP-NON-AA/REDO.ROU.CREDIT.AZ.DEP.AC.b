*-----------------------------------------------------------------------------
* <Rating>-26</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.ROU.CREDIT.AZ.DEP.AC(Y.FIN.ARR)
*-----------------------------------------------------------------------------
*COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*-------------
*DEVELOPED BY: Temenos Application Management
*-------------
*SUBROUTINE TYPE: NOFILE ROUTINE
*------------
*DESCRIPTION:
*------------
* This nofile routine will be attached to the enquiry REDO.ROU.CONTEXT.AZ.METHOD.ENQ.
*
*---------------------------------------------------------------------------
* Input / Output
*----------------
*
* Input / Output
* IN     : -na-
* OUT    : Y.FIN.ARR
*
*------------------------------------------------------------------------------------------------------------
* Revision History
* Date           Who                Reference              Description
* 09-SEP-2011   Marimuthu S        PACS00121130
* 17-SEP-2012   Pradeep S          PACS00183693            Current variable used for customer ID
*------------------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_System
$INSERT I_F.REDO.MTS.DISBURSE
$INSERT I_F.FUNDS.TRANSFER
$INSERT I_F.AZ.ACCOUNT
$INSERT I_F.TELLER

  GOSUB PROCESS
  GOSUB PGM.END

  RETURN
*--------
PROCESS:
*--------


  FN.REDO.MTS.DISBURSE = 'F.REDO.MTS.DISBURSE'
  F.REDO.MTS.DISBURSE = ''
  CALL OPF(FN.REDO.MTS.DISBURSE,F.REDO.MTS.DISBURSE)

  FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
  F.AZ.ACCOUNT = ''
  CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)


*Y.CUS.ID = R.NEW(TT.TE.THEIR.REFERENCE)
*Y.CUS.ID = System.getVariable("CURRENT.AA.ID")

*PACS00269502-S

  Y.FT.ID = System.getVariable("CURRENT.FT")
  Y.AMT = R.NEW(TT.TE.AMOUNT.LOCAL.1)

  CALL F.READ(FN.REDO.MTS.DISBURSE,Y.FT.ID,R.MTS.DISBURSE,F.REDO.MTS.DISBURSE,MTS.ERR)
  VAR.AZ.ID = R.MTS.DISBURSE<MT.AZ.ACCOUNT>
  CALL F.READ(FN.AZ.ACCOUNT,VAR.AZ.ID,R.AZ.ACCOUNT,F.AZ.ACCOUNT,AZ.ERR)

  IF R.AZ.ACCOUNT THEN
    Y.FIN.ARR = VAR.AZ.ID
  END

*PACS00269502 - E

* SEL.CMD = 'SELECT ':FN.AZ.ACCOUNT:' WITH CUSTOMER EQ ':Y.CUS.ID:' AND PRINCIPAL EQ ':Y.AMT:' AND CO.CODE EQ ':ID.COMPANY
* CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,SEL.ERR)
* Y.FIN.ARR = SEL.LIST

  RETURN
*--------
PGM.END:
*--------

END
