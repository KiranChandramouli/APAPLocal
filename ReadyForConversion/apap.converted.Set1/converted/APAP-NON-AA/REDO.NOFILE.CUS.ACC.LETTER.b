SUBROUTINE REDO.NOFILE.CUS.ACC.LETTER(Y.DATA)
*-----------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By :
* Program Name : REDO.NOFILE.AI.DROP.DOWN.ENQ
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_System
    $INSERT I_F.CUSTOMER.ACCOUNT
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CATEGORY
    $INSERT I_F.AI.REDO.ARCIB.PARAMETER

    GOSUB INITIALISE
    GOSUB FORM.ACCT.ARRAY

RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------


    F.CUSTOMER.ACCOUNT = ''
    FN.CUSTOMER.ACCOUNT = 'F.CUSTOMER.ACCOUNT'
    CALL OPF(FN.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT)

    FN.ACC = 'F.ACCOUNT'
    F.ACC = ''
    CALL OPF(FN.ACC,F.ACC)

    FN.AZ = 'F.AZ.ACCOUNT'
    F.AZ = ''
    CALL OPF(FN.AZ,F.AZ)

    FN.CATEGORY = "F.CATEGORY"
    F.CATEGORY = ''
    CALL OPF(FN.CATEGORY,F.CATEGORY)

    FN.AI.REDO.ARC.PARAM='F.AI.REDO.ARCIB.PARAMETER'

    Y.FIELD.COUNT = ''
    ACCT.REC = ''
    LOAN.FLG = ''
    DEP.FLG = ''
    AZ.REC = ''
    R.ACC = ''

    LREF.APP='ACCOUNT'
    LREF.FIELDS='L.AC.AV.BAL'
    LREF.POS = ''
    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELDS,LREF.POS)
    ACCT.OUT.BAL.POS=LREF.POS<1,1>

    LOCATE 'CUSTOMER' IN D.FIELDS<1> SETTING Y.POS1 THEN
        CUSTOMER.ID = FIELD(D.RANGE.AND.VALUE<Y.POS1>,'-',1)
    END

RETURN
******************
FORM.ACCT.ARRAY:
*****************

    CALL CACHE.READ(FN.AI.REDO.ARC.PARAM,'SYSTEM',R.AI.REDO.ARC.PARAM,PARAM.ERR)
    LIST.ACCT.TYPE=R.AI.REDO.ARC.PARAM<AI.PARAM.ACCOUNT.TYPE>

    CALL F.READ(FN.CUSTOMER.ACCOUNT,CUSTOMER.ID,ACCT.REC,F.CUSTOMER.ACCOUNT,CUST.ERR)

    LOOP
        REMOVE ACCT.ID FROM ACCT.REC SETTING ACCT.POS
    WHILE ACCT.ID:ACCT.POS

        ACC.ERR= ''
        CHECK.CATEG=''
        SAV.FLG=''
        CURR.FLG=''
        LOAN.FLG = ''
        DEP.FLG = ''
        Y.BAL.FLAG = ''

        CALL F.READ(FN.ACC,ACCT.ID,R.ACC,F.ACC,ACC.ERR)

        IF NOT(ACC.ERR) THEN

            ACCT.BAL      = R.ACC<AC.LOCAL.REF><1,ACCT.OUT.BAL.POS>
            CHECK.CATEG = R.ACC<AC.CATEGORY>

            GOSUB CHECK.STATUS.SUB

        END

    REPEAT

RETURN

******************
CHECK.STATUS.SUB:
******************

    IF ACCT.BAL GT '0' THEN

        GOSUB LOCATE.SAV.CUR.ACC
        GOSUB CHECK.LOAN.ACC
        GOSUB CHECK.AZ.ACC

        IF ((SAV.FLG EQ '1') OR (CURR.FLG EQ '1')) AND ((LOAN.FLG NE '1') AND (DEP.FLG NE '1')) THEN
            Y.DATA<-1> = ACCT.ID
        END

    END

RETURN
******************
CHECK.LOAN.ACC:
******************
    LOAN.FLG = ''
    ARR.ID = R.ACC<AC.ARRANGEMENT.ID>

    IF ARR.ID NE '' THEN
        LOAN.FLG = 1
    END

RETURN

*******************
CHECK.AZ.ACC:
******************
    DEP.FLG = ''
    CALL F.READ(FN.AZ,ACCT.ID,AZ.REC,F.AZ,AZ.ERR)

    IF AZ.REC THEN
        DEP.FLG = 1

    END

RETURN
*********************
LOCATE.SAV.CUR.ACC:
********************

    SAV.FLG = '' ; CURR.FLG = ''

    Y.CNT.LIST = DCOUNT(LIST.ACCT.TYPE,@VM)

    Y.CNT = 1
    LOOP
    WHILE Y.CNT LE Y.CNT.LIST
        Y.VAL = LIST.ACCT.TYPE<1,Y.CNT>
        IF Y.VAL EQ 'SAVINGS'  THEN
            SAV.STR.RGE = R.AI.REDO.ARC.PARAM<AI.PARAM.CATEG.START,Y.CNT>
            SAV.END.RGE = R.AI.REDO.ARC.PARAM<AI.PARAM.CATEG.END,Y.CNT>
            IF (CHECK.CATEG GE SAV.STR.RGE) AND (CHECK.CATEG LE SAV.END.RGE) THEN
                SAV.FLG = 1
            END
        END

        IF Y.VAL EQ 'CURRENT' THEN
            CURR.STR.RGE = R.AI.REDO.ARC.PARAM<AI.PARAM.CATEG.START,Y.CNT>
            CURR.END.RGE = R.AI.REDO.ARC.PARAM<AI.PARAM.CATEG.END,Y.CNT>
            IF (CHECK.CATEG GE CURR.STR.RGE) AND (CHECK.CATEG LE CURR.END.RGE) THEN
                CURR.FLG=1
            END

        END
        Y.CNT += 1
    REPEAT

RETURN
*-----------------------------------------------------------------------------
END
*---------------------------*END OF SUBROUTINE*-------------------------------
