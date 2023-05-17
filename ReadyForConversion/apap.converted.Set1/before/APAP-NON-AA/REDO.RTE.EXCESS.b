*-----------------------------------------------------------------------------
* <Rating>-13</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.RTE.EXCESS(Y.AGENCY,Y.AMT,TXN.CNT)

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.FUNDS.TRANSFER
$INSERT I_F.TELLER
$INSERT I_ENQUIRY.COMMON

*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.RTE.DENOM.EXCESS
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.RTE.DENOM.EXCESS is a call routine to return the transaction count and total amount
*                    exceeded in enquiry REDO.RTE.REPORT
*Linked With       : Enquiry - REDO.APAP.ENQ.CASH.WINDOW.DENOM

*In  Parameter     : NA
*Out Parameter     : Y.OUT.ARRAY - Output array for display
*Files  Used       : REDO.H.TELLER.TXN.CODES          As              I               Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                         Reference                 Description
*   ------             -----                       -------------             -------------
* 11 Mar 2011       Shiva Prasad Y              ODR-2011-03-0150 35         Initial Creation
*
*********************************************************************************************************
  Y.TEMP.D.FIELDS = D.FIELDS
  Y.TEMP.D.LOGICAL.OPERANDS = D.LOGICAL.OPERANDS
  Y.TEMP.D.RANGE.AND.VALUE = D.RANGE.AND.VALUE

  D.FIELDS           = 'TXN.DATE'
  D.LOGICAL.OPERANDS = '1'
  D.RANGE.AND.VALUE  = TODAY
  Y.DATA = ''

  FN.TELLER = 'F.TELLER'
  F.TELLER = ''
  CALL OPF(FN.TELLER,F.TELLER)

  FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'
  F.FUNDS.TRANSFER = ''
  CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

  CALL REDO.E.NOF.RTE.RTN(Y.DATA)

  Y.DATA.CNT = DCOUNT(Y.DATA,FM)
  Y.DATA.INT = 1
  TXN.CNT = 0
  Y.AMT = 0
  LOOP
    REMOVE Y.DATA.ID FROM Y.DATA SETTING Y.DATA.POS
  WHILE Y.DATA.INT LE Y.DATA.CNT
    TXN.ID = FIELD(Y.DATA.ID,'*',1)
    CALL F.READ(FN.TELLER,TXN.ID,R.TELLER,F.TELLER,TELLER.ERR)
    IF R.TELLER THEN
      COMP.CODE = R.TELLER<TT.TE.CO.CODE>
    END
    ELSE
      CALL F.READ(FN.FUNDS.TRANSFER,TXN.ID,R.FUNDS.TRANSFER,F.FUNDS.TRANSFER,FUNDS.ERR)
      COMP.CODE = R.FUNDS.TRANSFER<FT.CO.CODE>
    END
    IF COMP.CODE EQ Y.AGENCY THEN
      TXN.CNT++
      Y.AMT += FIELD(Y.DATA.ID,'*',2)
    END
    Y.DATA.INT++
  REPEAT

  RETURN
END
