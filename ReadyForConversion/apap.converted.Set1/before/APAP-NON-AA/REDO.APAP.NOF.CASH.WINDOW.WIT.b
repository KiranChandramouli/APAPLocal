*-----------------------------------------------------------------------------
* <Rating>-103</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.APAP.NOF.CASH.WINDOW.WIT(Y.OUT.ARRAY)
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.NOF.CASH.WINDOW.WIT
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.APAP.NOF.CASH.WINDOW.WIT is an No-file enquiry routine, this routine is used to
*                    extract data from relevant files so as to display in the CASH WINDOW TRANSACTION report
*                    with WITHDRAWALS details
*Linked With       : Enquiry - REDO.APAP.ENQ.CASH.WINDOW.WIT
*In  Parameter     : NA
*Out Parameter     : Y.OUT.ARRAY - Output array for display
*Files  Used       : REDO.H.TELLER.TXN.CODES          As              I               Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                         Reference                 Description
*   ------             -----                       -------------             -------------
* 11 Mar 2011       Shiva Prasad Y              ODR-2010-03-0086 35         Initial Creation
*
*********************************************************************************************************
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.REDO.H.TELLER.TXN.CODES
*-------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
* This is the para from where the execution of the code starts
  GOSUB OPEN.PARA
  GOSUB PROCESS.PARA

  RETURN
*--------------------------------------------------------------------------------------------------------
**********
OPEN.PARA:
**********
* In this para of the code, file variables are initialised and opened
  FN.REDO.H.TELLER.TXN.CODES = 'F.REDO.H.TELLER.TXN.CODES'
  F.REDO.H.TELLER.TXN.CODES  = ''
  *CALL OPF(FN.REDO.H.TELLER.TXN.CODES,F.REDO.H.TELLER.TXN.CODES)

  RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para

  Y.CCY.LIST = LCCY

  REDO.H.TELLER.TXN.CODES.ID = 'SYSTEM'
  GOSUB READ.REDO.H.TELLER.TXN.CODES

  GOSUB GET.SAV.CURR.DEBIT.DETAILS
*    GOSUB GET.SHORTAGE.AMT
*    GOSUB GET.CASH.TELLER.TXN
  GOSUB ADD.STATIC.TEXT
  GOSUB CONVERT.TO.STARS
  RETURN
*--------------------------------------------------------------------------------------------------------
********************
GET.CASH.TELLER.TXN:
********************
  CALL REDO.APAP.NOF.CASH.WINDOW.WIT.CTT(Y.CCY.LIST,Y.AGENCY,Y.FINAL.ARRAY)
  RETURN
*--------------------------------------------------------------------------------------------------------
***************************
GET.SAV.CURR.DEBIT.DETAILS:
***************************
* In this para of the code, the TELLER TRANSACTION details are read and checked if the transaction can be
** consdiered or not for calculations and display

  CALL REDO.APAP.NOF.CASH.WINDOW.WIT.SAV.CUR(Y.CCY.LIST,R.REDO.H.TELLER.TXN.CODES,Y.FINAL.ARRAY,SET.CUR,Y.DUP.CUR)
  RETURN
*--------------------------------------------------------------------------------------------------------
*****************
GET.SHORTAGE.AMT:
*****************
* In this para of the code, the SHORTAGE amount details are fetched

*    CALL REDO.APAP.NOF.CASH.WINDOW.WIT.SHORTAGE(Y.CCY.LIST,Y.FINAL.ARRAY)
  RETURN
*--------------------------------------------------------------------------------------------------------
****************
ADD.STATIC.TEXT:
****************
* In this para of the code, a CALL is made to an routine to add the static text in the report for display

  CALL REDO.APAP.NOF.CASH.WINDOW.WIT.TEXT.R32(Y.CCY.LIST,Y.FINAL.ARRAY)
  Y.CNT.FIN = DCOUNT(Y.FINAL.ARRAY,FM)
  Y.CNTT = 0
  LOOP
  WHILE Y.CNT.FIN GE 0 DO
    Y.CNTT += 1
    IF Y.FINAL.ARRAY<Y.CNTT> EQ '' THEN
      DEL Y.FINAL.ARRAY<Y.CNTT>
    END
    Y.CNT.FIN -= 1
  REPEAT
  RETURN
  RETURN
*--------------------------------------------------------------------------------------------------------
*****************
CONVERT.TO.STARS:
*****************
* In this para of the code, the fianl array is formatted so as to display the output in enquiry

  CHANGE VM TO FM  IN Y.FINAL.ARRAY
  CHANGE SM TO '*' IN Y.FINAL.ARRAY

  Y.OUT.ARRAY = Y.FINAL.ARRAY

  RETURN
*--------------------------------------------------------------------------------------------------------
*****************************
READ.REDO.H.TELLER.TXN.CODES:
*****************************
* In this para of the code, file REDO.H.TELLER.TXN.CODES is read
  R.REDO.H.TELLER.TXN.CODES  = ''
  REDO.H.TELLER.TXN.CODES.ER = ''
*  CALL F.READ(FN.REDO.H.TELLER.TXN.CODES,REDO.H.TELLER.TXN.CODES.ID,R.REDO.H.TELLER.TXN.CODES,F.REDO.H.TELLER.TXN.CODES,REDO.H.TELLER.TXN.CODES.ER) ;*Tus Start 
CALL CACHE.READ(FN.REDO.H.TELLER.TXN.CODES,REDO.H.TELLER.TXN.CODES.ID,R.REDO.H.TELLER.TXN.CODES,REDO.H.TELLER.TXN.CODES.ER) ; * Tus End

  RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* End of Program
