*-----------------------------------------------------------------------------
* <Rating>-41</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.NOF.RECENT.INTERACTIONS(Y.FINAL.ARRAY)
*-------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : DHAMU S
* Program Name : REDO.NOF.RECENT.INTERACTIONS
*--------------------------------------------------------------------------------
*Description : This routine is used to display the Values of the particular user
*--------------------------------------------------------------------------------
* Linked With : ENQUIRY REDO.RECENT.INTERACTIONS
* In Parameter : None
* Out Parameter : None
*---------------------------------------------------------------------------------
*Modification History:
*------------------------
*     Date            Who                  Reference               Description
*    ------          ------               -----------             --------------
*   29-11-2011      RIYAS             PACS00024006         Initial Creation
*--------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.USER
$INSERT I_F.CUSTOMER
$INSERT I_F.CR.CONTACT.LOG
  GOSUB OPEN
  GOSUB PROCESS
  RETURN
******
OPEN:
*****

  FN.CR.CONTACT.LOG = 'F.CR.CONTACT.LOG'
  F.CR.CONTACT.LOG = ''
  CALL OPF(FN.CR.CONTACT.LOG,F.CR.CONTACT.LOG)

  FN.CUSTOMER = 'F.CUSTOMER'
  F.CUSTOMER  = ''
  CALL OPF(FN.CUSTOMER,F.CUSTOMER)

  RETURN
********
PROCESS:
********
  LOCATE "CONTACT.CLIENT" IN D.FIELDS<1> SETTING APL.POS THEN
    Y.CLIENT = D.RANGE.AND.VALUE<APL.POS>
  END

  LOCATE "L.CR.CUST.ID" IN D.FIELDS<1> SETTING CUS.POS THEN
    Y.CUST.ID = D.RANGE.AND.VALUE<CUS.POS>
  END

  LOCATE "CONTACT.DATE" IN D.FIELDS<1> SETTING CLIENT.POS THEN
    Y.DATE = D.RANGE.AND.VALUE<CLIENT.POS>
    GOSUB CHECK.DATE
  END
  FILE.NAME = FN.CR.CONTACT.LOG
  CALL REDO.E.FORM.SEL.STMT(FILE.NAME, '', '',SEL.CONTACT.CMD)
  SEL.CONTACT.CMD :=" AND CONTACT.DATE LE ":TODAY
  SEL.CONTACT.CMD :=" BY-DSND CONTACT.DATE"
  CALL EB.READLIST(SEL.CONTACT.CMD,SEL.LIST1,'',SEL.NOR1,SEL.RET1)
  Y.SEL.CUS = '1'
  Y.MAX = 20
  LOOP
  WHILE Y.SEL.CUS LE SEL.NOR1
    Y.SEL.ID<-1> = SEL.LIST1<Y.SEL.CUS>
    CALL F.READ(FN.CR.CONTACT.LOG,Y.SEL.ID,R.CR.CONTACT.LOG,F.CR.CONTACT.LOG,CONTACTS.ERR)
    Y.CONTACT.CLIENT=R.CR.CONTACT.LOG<CR.CONT.LOG.CONTACT.CLIENT>
    CALL F.READ(FN.CUSTOMER,Y.CONTACT.CLIENT,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERR)
    Y.CLIENT.NAME = R.CUSTOMER<EB.CUS.SHORT.NAME>
    Y.CONTACT.TYPE = R.CR.CONTACT.LOG<CR.CONT.LOG.CONTACT.TYPE>
    Y.CONTACT.DESC = R.CR.CONTACT.LOG<CR.CONT.LOG.CONTACT.DESC>
    Y.CONTACT.CHANNEL = R.CR.CONTACT.LOG<CR.CONT.LOG.CONTACT.CHANNEL>
    Y.CONTACT.DATE = R.CR.CONTACT.LOG<CR.CONT.LOG.CONTACT.DATE>
    Y.CONTACT.TIME = R.CR.CONTACT.LOG<CR.CONT.LOG.CONTACT.TIME>
    Y.CONTRACT.ID = R.CR.CONTACT.LOG<CR.CONT.LOG.CONTRACT.ID>
    GOSUB FINAL.ARRAY
    Y.SEL.CUS += 1
    IF Y.SEL.CUS GT '20' THEN
      RETURN
    END
  REPEAT
  RETURN
***********
CHECK.DATE:
***********
  Y.COUNT =DCOUNT(Y.DATE,SM)
  Y.TXN.DATE1 = FIELD(Y.DATE,SM,1)
  Y.TXN.DATE2 = FIELD(Y.DATE,SM,2)
  IF NOT(NUM(Y.TXN.DATE1)) OR LEN(Y.TXN.DATE1) NE '8' OR NOT(NUM(Y.TXN.DATE2)) OR LEN(Y.TXN.DATE2) NE '8' THEN
    ENQ.ERROR = "EB-REDO.DATE.RANGE"
  END ELSE
    IF Y.TXN.DATE1[5,2] GT '12' OR Y.TXN.DATE2[5,2] GT '12' OR Y.TXN.DATE1[7,2] GT '31' OR Y.TXN.DATE2[7,2] GT '31' OR Y.TXN.DATE1 GT Y.TXN.DATE2 THEN
      ENQ.ERROR = "EB-REDO.DATE.RANGE"
    END
  END
  RETURN

************
FINAL.ARRAY:
************
  Y.FINAL.ARRAY<-1> = Y.SEL.ID:"*":Y.CONTACT.CLIENT:"*":Y.CLIENT.NAME:"*":Y.CONTACT.TYPE:"*":Y.CONTACT.DESC:"*":Y.CONTACT.CHANNEL:"*":Y.CONTACT.DATE:"*":Y.CONTACT.TIME:"*":Y.CONTRACT.ID
  Y.SEL.ID = '';Y.CONTACT.CLIENT = ''; Y.CLIENT.NAME = ''; Y.CONTACT.TYPE = ''; Y.CONTACT.DESC = '';Y.CONTACT.CHANNEL = '';Y.CONTACT.DATE = '';Y.CONTACT.TIME = ''; Y.CONTRACT.ID =''
  RETURN
***********************************
END
*--------------End of Program----------------------------------------------
