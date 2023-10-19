* @ValidationCode : MjoxMjE5ODQyMjc0OkNwMTI1MjoxNjgyNTgxODU0NTc3OnZpZ25lc2h3YXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 27 Apr 2023 13:20:54
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.NOF.RECENT.CASES(Y.FINAL.ARRAY)
*-------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : RIYAS
* Program Name : REDO.NOF.RECENT.CASES
*--------------------------------------------------------------------------------
*Description : This routine is used to display the Values of the particular user
*--------------------------------------------------------------------------------
* Linked With : ENQUIRY REDO.RECENT.CASES
* In Parameter : None
* Out Parameter : None
*---------------------------------------------------------------------------------
*Modification History:
*------------------------
*     Date            Who                  Reference               Description
*    ------          ------               -----------             --------------
*   29-11-2011      RIYAS             PACS00024006         Initial Creation
*
* 13-APR-2023     Conversion tool    R22 Auto conversion       SM to @SM
* 13-APR-2023      Harishvikram C   Manual R22 conversion     CALL routine format modified
*--------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.USER
    $INSERT I_F.CUSTOMER
    $INSERT I_F.CR.CONTACT.LOG
    GOSUB OPEN
    GOSUB GET.LOCAL.REF
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
    CALL APAP.REDOENQ.RedoEFormSelStmt(FILE.NAME, '', '',SEL.CONTACT.CMD) ;*Manual R22 conversion
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
        Y.CONTACT.CHANNEL = R.CR.CONTACT.LOG<CR.CONT.LOG.CONTACT.CHANNEL>
        Y.CONTACT.DATE = R.CR.CONTACT.LOG<CR.CONT.LOG.CONTACT.DATE>
        Y.CONTACT.TIME = R.CR.CONTACT.LOG<CR.CONT.LOG.CONTACT.TIME>
        Y.CONTRACT.ID = R.CR.CONTACT.LOG<CR.CONT.LOG.CONTRACT.ID>
        Y.CONTRACT.STATUS = R.CR.CONTACT.LOG<CR.CONT.LOG.LOCAL.REF,LOC.L.CR.STATUS.POS>
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
    Y.COUNT =DCOUNT(Y.DATE,@SM)
    Y.TXN.DATE1 = FIELD(Y.DATE,@SM,1)
    Y.TXN.DATE2 = FIELD(Y.DATE,@SM,2)
    IF NOT(NUM(Y.TXN.DATE1)) OR LEN(Y.TXN.DATE1) NE '8' OR NOT(NUM(Y.TXN.DATE2)) OR LEN(Y.TXN.DATE2) NE '8' THEN
        ENQ.ERROR = "EB-REDO.DATE.RANGE"
    END ELSE
        IF Y.TXN.DATE1[5,2] GT '12' OR Y.TXN.DATE2[5,2] GT '12' OR Y.TXN.DATE1[7,2] GT '31' OR Y.TXN.DATE2[7,2] GT '31' OR Y.TXN.DATE1 GT Y.TXN.DATE2 THEN
            ENQ.ERROR = "EB-REDO.DATE.RANGE"
        END
    END
RETURN
**************
GET.LOCAL.REF:
**************
    APL.ARRAY = 'CR.CONTACT.LOG'
    APL.FIELD = 'L.CR.STATUS'
    FLD.POS   = ''
    CALL MULTI.GET.LOC.REF(APL.ARRAY,APL.FIELD,FLD.POS)
    LOC.L.CR.STATUS.POS = FLD.POS<1,1>
RETURN
************
FINAL.ARRAY:
************
    Y.FINAL.ARRAY<-1> = Y.SEL.ID:"*":Y.CONTACT.CLIENT:"*":Y.CLIENT.NAME:"*":Y.CONTACT.TYPE:"*":Y.CONTRACT.STATUS:"*":Y.CONTACT.CHANNEL:"*":Y.CONTACT.DATE:"*":Y.CONTACT.TIME:"*":Y.CONTRACT.ID
    Y.SEL.ID = '';Y.CONTACT.CLIENT = ''; Y.CLIENT.NAME = ''; Y.CONTACT.TYPE = ''; Y.CONTRACT.STATUS = '';Y.CONTACT.CHANNEL = '';Y.CONTACT.DATE = '';Y.CONTACT.TIME = ''; Y.CONTRACT.ID =''
RETURN
***********************************
END
*--------------End of Program----------------------------------------------
