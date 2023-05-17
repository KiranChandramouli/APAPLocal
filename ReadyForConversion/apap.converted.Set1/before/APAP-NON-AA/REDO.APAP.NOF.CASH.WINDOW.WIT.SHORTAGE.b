*-----------------------------------------------------------------------------
* <Rating>-157</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.APAP.NOF.CASH.WINDOW.WIT.SHORTAGE(Y.CCY.LIST,Y.FINAL.ARRAY)
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.NOF.CASH.WINDOW.WIT.SHORTAGE
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.APAP.NOF.CASH.WINDOW.WIT.SHORTAGE is a routine called from another routine
*                    REDO.APAP.NOF.CASH.WINDOW.WIT, this routine is used to fetch the SHORTAGE amount
*                    details
*Linked With       : Enquiry - REDO.APAP.ENQ.CASH.WINDOW.WIT
*In  Parameter     : Y.CCY.LIST     - This variable holds the processed currency list
*Out Parameter     : Y.FINAL.ARRAY  - THe final Array to be passed out
*                    Y.CCY.LIST     - This variable holds the processed currency list
*Files  Used       : STMT.ENTRY                       As              I               Mode
*                    TELLER.PARAMETER                 As              I               Mode
*                    TELLER.ID                        As              I               Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                         Reference                 Description
*   ------             -----                       -------------             -------------
* 22 Mar 2011       Shiva Prasad Y              ODR-2010-03-0086 35         Initial Creation
*
*********************************************************************************************************
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.TELLER.PARAMETER
$INSERT I_F.STMT.ENTRY
$INSERT I_F.TELLER.ID
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

  FN.ACCOUNT = 'F.ACCOUNT'
  F.ACCOUNT  = ''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)

  FN.TELLER.PARAMETER = 'F.TELLER.PARAMETER'
  F.TELLER.PARAMETER  = ''
  CALL OPF(FN.TELLER.PARAMETER,F.TELLER.PARAMETER)

  FN.STMT.ENTRY = 'F.STMT.ENTRY'
  F.STMT.ENTRY  = ''
  CALL OPF(FN.STMT.ENTRY,F.STMT.ENTRY)

  FN.STMT.ENTRY.DETAIL = 'F.STMT.ENTRY.DETAIL'
  F.STMT.ENTRY.DETAIL = ''
  CALL OPF(FN.STMT.ENTRY.DETAIL,F.STMT.ENTRY.DETAIL)

  FN.TELLER = 'F.TELLER'
  F.TELLER  = ''
  CALL OPF(FN.TELLER,F.TELLER)

  FN.TELLER.ID = 'F.TELLER.ID'
  F.TELLER.ID  = ''
  CALL OPF(FN.TELLER.ID,F.TELLER.ID)

  FN.TELLER$HIS = 'F.TELLER$HIS'
  F.TELLER$HIS  = ''
  CALL OPF(FN.TELLER$HIS,F.TELLER$HIS)

  RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para

  LOCATE 'AGENCY' IN D.FIELDS<1> SETTING Y.AGY.POS  THEN
    Y.AGENCY = D.RANGE.AND.VALUE<Y.AGY.POS>
  END

  GOSUB GET.SHORTAGE.CATEGORY
  GOSUB FORM.SEL.CMD
  IF NOT(SEL.LIST.SHORT) THEN
    RETURN
  END

  GOSUB GET.CCY.ACCOUNT

  RETURN
*--------------------------------------------------------------------------------------------------------
**********************
GET.SHORTAGE.CATEGORY:
**********************
* In this para of the code, to fetch the SHORTAGE category from TELLER.PRAMETER file

  TELLER.PARAMETER.ID = Y.AGENCY
  GOSUB READ.TELLER.PARAMETER

  Y.SHORT.CATEG = R.TELLER.PARAMETER<TT.PAR.SHORT.CATEGORY>
  Y.SHORT.TXN.CDE = R.TELLER.PARAMETER<TT.PAR.TRAN.CODE.SHORT>

  RETURN
*--------------------------------------------------------------------------------------------------------
*************
FORM.SEL.CMD:
*************
* In this para of the code, the SELECT command is formed to get the TELLER transactions IDs for processing
  SEL.CMD.SHORT = 'SELECT ':FN.ACCOUNT:' WITH @ID LIKE ...':Y.SHORT.CATEG:'... AND WITH CO.CODE EQ ':Y.AGENCY
  CALL EB.READLIST(SEL.CMD.SHORT,SEL.LIST.SHORT,'',NO.OF.REC.SHORT,SEL.ERR.SHORT)
  Y.DUP.LIST = SEL.LIST.SHORT

  RETURN
*--------------------------------------------------------------------------------------------------------
****************
GET.CCY.ACCOUNT:
****************
* In this para of the code, the CURRECNY list is looped along to fetch the STMT.ENTRY details
  LOOP
    REMOVE Y.CCY FROM Y.CCY.LIST SETTING Y.CCY.POS
  WHILE Y.CCY : Y.CCY.POS
    GOSUB LOOP.THRU.ACCOUNTS
  REPEAT

  RETURN
*--------------------------------------------------------------------------------------------------------
*******************
LOOP.THRU.ACCOUNTS:
*******************
* In this para of the code, the ACCOUNT list is looped and corresposding accounts of currency are fetched

  SEL.LIST.SHORT = Y.DUP.LIST
  LOOP
    REMOVE Y.ACCOUNT.ID FROM SEL.LIST.SHORT SETTING Y.ACC.POS
  WHILE Y.ACCOUNT.ID : Y.ACC.POS
    IF Y.CCY EQ Y.ACCOUNT.ID[1,3] THEN
      GOSUB GET.STMT.ENTRY.DETAILS
    END
  REPEAT

  RETURN
*--------------------------------------------------------------------------------------------------------
***********************
GET.STMT.ENTRY.DETAILS:
***********************
* In this para of the code, the STMT.ENTRY IDs are fetced by calling the core enquiry
  D.FIELDS            = 'ACCOUNT'    :FM: 'BOOKING.DATE'
  D.RANGE.AND.VALUE   = Y.ACCOUNT.ID :FM: TODAY
  D.LOGICAL.OPERANDS  = 1            :FM: 1

  CALL E.STMT.ENQ.BY.CONCAT(Y.ID.LIST)

  Y.SE.COUNT = DCOUNT(Y.ID.LIST,FM)
  Y.SE.START = 1

  LOOP
  WHILE Y.SE.START LE Y.SE.COUNT
    STMT.ENTRY.ID = FIELD(FIELD(Y.ID.LIST,FM,Y.SE.START),'*',2,1)
    IF NOT(STMT.ENTRY.ID) THEN
      Y.SE.START += 1
      CONTINUE
    END
    GOSUB CHECK.STMT.ENTRY.DETAILS
    Y.SE.START += 1
  REPEAT

  RETURN
*--------------------------------------------------------------------------------------------------------
*************************
CHECK.STMT.ENTRY.DETAILS:
*************************
* In this para of the code, the STMT.ENTRY details are fetched
  GOSUB READ.STMT.ENTRY
  IF NOT(R.STMT.ENTRY) THEN
    RETURN
  END

*  IF R.STMT.ENTRY<AC.STE.PRODUCT.CATEGORY> NE Y.SHORT.CATEG THEN
*      RETURN
*  END

  IF R.STMT.ENTRY<AC.STE.TRANSACTION.CODE> NE Y.SHORT.TXN.CDE THEN
    RETURN
  END

  IF R.STMT.ENTRY<AC.STE.VALUE.DATE> NE TODAY THEN
    RETURN
  END

  TELLER.ID = R.STMT.ENTRY<AC.STE.TRANS.REFERENCE>
  TELLER.ID = FIELD(TELLER.ID,';',1)
  GOSUB READ.TELLER.ID
* GOSUB READ.TELLER.IDHIS
  IF NOT(R.TELLER.ID) THEN
    Y.STMT.DET.ID = FIELD(FIELD(Y.ID.LIST,FM,Y.SE.START),'*',7,1)
    CALL F.READ(FN.STMT.ENTRY.DETAIL,Y.STMT.DET.ID,R.STMT.ENT.DETAILS,F.STMT.ENTRY.DETAIL,STMT.ENT.ERR)
    TELLER.ID = R.STMT.ENT.DETAILS<AC.STE.TRANS.REFERENCE>
    TELLER.ID = FIELD(TELLER.ID,';',1)
    GOSUB READ.TELLER.ID
    IF NOT(R.TELLER.ID) THEN
      RETURN
    END
  END

  Y.TT.CCY = R.STMT.ENTRY<AC.STE.CURRENCY>
  IF Y.TT.CCY EQ LCCY THEN
    Y.TT.AMT = R.STMT.ENTRY<AC.STE.AMOUNT.LCY>
  END ELSE
    Y.TT.AMT = R.STMT.ENTRY<AC.STE.AMOUNT.FCY>
  END

  LOCATE Y.CCY IN Y.CCY.LIST<1> SETTING Y.CCY.POS ELSE
    RETURN
  END

  Y.VM.POS  = 31
  Y.ADD.AMT = Y.TT.AMT
  Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,3> = ''
  Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,7> += Y.ADD.AMT

  RETURN
*--------------------------------------------------------------------------------------------------------
**********************
READ.TELLER.PARAMETER:
**********************
* In this para of the code, file TELLER.PARAMETER is read
  R.TELLER.PARAMETER  = ''
  TELLER.PARAMETER.ER = ''
*TUS Start
 CALL F.READ(FN.TELLER.PARAMETER,TELLER.PARAMETER.ID,R.TELLER.PARAMETER,F.TELLER.PARAMETER,TELLER.PARAMETER.ER)
 * CALL CACHE.READ(FN.TELLER.PARAMETER,TELLER.PARAMETER.ID,R.TELLER.PARAMETER,TELLER.PARAMETER.ER)
*TUS End
  RETURN
*--------------------------------------------------------------------------------------------------------
****************
READ.STMT.ENTRY:
****************
* In this para of the code, file STMT.ENTRY is read
  R.STMT.ENTRY  = ''
  STMT.ENTRY.ER = ''
  CALL F.READ(FN.STMT.ENTRY,STMT.ENTRY.ID,R.STMT.ENTRY,F.STMT.ENTRY,STMT.ENTRY.ER)

  RETURN
*--------------------------------------------------------------------------------------------------------
***************
READ.TELLER.ID:
***************
* In this para of the code, file TELLER.ID is read
  R.TELLER.ID  = ''
  TELLER.ID.ER = ''
  CALL F.READ(FN.TELLER.ID,TELLER.ID,R.TELLER.ID,F.TELLER.ID,TELLER.ID.ER)

  RETURN
*--------------------------------------------------------------------------------------------------------
*******************
READ.TELLER.IDHIS:
*******************
* In this para of the code, file TELLER.ID$HIS is read
  R.TELLER.ID$HIS  = ''
  TELLER.ID$HIS.ER = ''
  CALL F.READ(FN.TELLER$HIS,TELLER.ID,R.TELLER.ID$HIS,F.TELLER$HIS,TELLER.ID$HIS.ER)

  RETURN
*--------------------------------------------------------------------------------------------------------
