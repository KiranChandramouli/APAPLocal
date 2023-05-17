*-----------------------------------------------------------------------------
* <Rating>-76</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.E.CONV.BLOT.TXN.DATE

*********************************************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.E.CONV.BLOT.TXN.DATE
*--------------------------------------------------------------------------------------------------------
*Description       : This is a conversion routine attached to the Enquiry REDO.ENQ.FX.BLOT.POS
*                    to get the transaction date for applications.
*                    with their transaction details
*In Parameter      : O.DATA
*Out Parameter     : O.DATA
*Files  Used       : Forex,Funds Transfer and Teller
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who           Reference                      Description
*   ------         ------          -------------                  -------------
*  19/10/2011      Pradeep S       PACS00148243                   Initial Creation
*********************************************************************************************************

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.FOREX
$INSERT I_F.FUNDS.TRANSFER
$INSERT I_F.TELLER

  GOSUB INIT
  GOSUB PROCESS

  RETURN

******
INIT:
******

  Y.TXN.ID = FIELD(O.DATA,";",1)
  Y.TXN.DATE = ''

  RETURN  ;* Return END

*********
PROCESS:
*********

  BEGIN CASE
  CASE Y.TXN.ID[1,2] EQ 'FX'
    GOSUB PROCESS.FX
  CASE Y.TXN.ID[1,2] EQ 'FT'
    GOSUB PROCESS.FT
  CASE Y.TXN.ID[1,2] EQ 'TT'
    GOSUB PROCESS.TT
  END CASE

  IF Y.TXN.DATE THEN
    O.DATA = Y.TXN.DATE
  END

  RETURN  ;* Return PROCESS

************
PROCESS.FX:
************

  FN.APPL = 'F.FOREX'
  F.APPL  = ''

  FN.APPL.HIS = 'F.FOREX$HIS'
  F.APPL.HIS  = ''

  GOSUB OPEN.FILE

  GOSUB READ.FILE

  IF R.APPL.REC THEN
    Y.TXN.DATE = R.APPL.REC<FX.DEAL.DATE>
  END

  RETURN  ;* Return PROCESS.FX

************
PROCESS.FT:
************

  FN.APPL = 'F.FUNDS.TRANSFER'
  F.APPL  = ''

  FN.APPL.HIS = 'F.FUNDS.TRANSFER$HIS'
  F.APPL.HIS  = ''

  GOSUB OPEN.FILE

  GOSUB READ.FILE

  IF R.APPL.REC THEN
    Y.TXN.DATE = R.APPL.REC<FT.AUTH.DATE>
  END

  RETURN  ;* Return PROCESS.FT

************
PROCESS.TT:
************

  FN.APPL = 'F.TELLER'
  F.APPL  = ''

  FN.APPL.HIS = 'F.TELLER$HIS'
  F.APPL.HIS  = ''

  GOSUB OPEN.FILE

  GOSUB READ.FILE

  IF R.APPL.REC THEN
    Y.TXN.DATE = R.APPL.REC<TT.TE.AUTH.DATE>
  END

  RETURN  ;* Return PROCESS.TT

***********
OPEN.FILE:
***********

  CALL OPF(FN.APPL,F.APPL)
  CALL OPF(FN.APPL.HIS,F.APPL.HIS)

  RETURN  ;*Return OPEN.FILE

***********
READ.FILE:
***********

  R.APPL.REC  = ''
  CALL F.READ(FN.APPL,Y.TXN.ID,R.APPL.REC,F.APPL,ERR)
  IF ERR THEN
    CALL EB.READ.HISTORY.REC(F.APPL.HIS,Y.TXN.ID,R.APPL.REC,ERR)
  END

  RETURN  ;* Return READ.FILE
END
