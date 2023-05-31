* @ValidationCode : MjoyMTIwOTgzNDU2OkNwMTI1MjoxNjgyMDc4ODczMzk1OklUU1M6LTE6LTE6OTE5OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 21 Apr 2023 17:37:53
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 919
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.NOFILE.CUS.ACC(Y.DATA)
*-----------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By :
* Program Name : REDO.NOFILE.AI.DROP.DOWN.ENQ
*-----------------------------------------------------------------------------
*In Parameter:
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 18-APR-2023     Conversion tool    R22 Auto conversion       FM TO @FM, VM to @VM, ++ to +=, if condition added
* 18-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_System
    $INSERT I_EB.EXTERNAL.COMMON
    $INSERT I_F.CUSTOMER.ACCOUNT
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CATEGORY
    $INSERT I_F.AI.REDO.ARCIB.PARAMETER
    $INSERT I_F.AI.REDO.ARCIB.ALIAS.TABLE
    $INSERT I_F.FT.TXN.TYPE.CONDITION
    $INSERT I_F.FT.COMMISSION.TYPE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.AI.REDO.ACCT.RESTRICT.PARAMETER
    $INSERT I_F.REDO.APAP.STO.DUPLICATE
    $INSERT I_F.RELATION.CUSTOMER

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

    Y.VAR.EXT.CUSTOMER = ''
    Y.VAR.EXT.ACCOUNTS=''
    FN.CATEGORY = "F.CATEGORY"
    F.CATEGORY = ''
    FN.AI.REDO.ARC.PARAM='F.AI.REDO.ARCIB.PARAMETER'
    FN.AI.REDO.ACCT.RESTRICT.PARAMETER = 'F.AI.REDO.ACCT.RESTRICT.PARAMETER'
    CALL OPF(FN.CATEGORY,F.CATEGORY)

    FN.RELATION.CUSTOMER = 'F.RELATION.CUSTOMER'
    F.RELATION.CUSTOMER = ''
    CALL OPF (FN.RELATION.CUSTOMER,F.RELATION.CUSTOMER)

    FN.JOINT.CONTRACTS.XREF = 'F.JOINT.CONTRACTS.XREF'
    F.JOINT.CONTRACTS.XREF  = ''
    CALL OPF(FN.JOINT.CONTRACTS.XREF,F.JOINT.CONTRACTS.XREF)

    Y.FIELD.COUNT = ''
    ACCT.REC = ''
    LOAN.FLG = ''
    DEP.FLG = ''
    AZ.REC = ''
    R.ACC = ''
    LREF.APP='ACCOUNT'
    LREF.FIELDS='L.AC.STATUS1':@VM:'L.AC.AV.BAL':@VM:'L.AC.NOTIFY.1':'L.AC.STATUS2'
    LREF.POS = ''
    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELDS,LREF.POS)
    ACCT.STATUS.POS=LREF.POS<1,1>
    ACCT.OUT.BAL.POS=LREF.POS<1,2>
    NOTIFY.POS = LREF.POS<1,3>
    Y.ACCT.STATUS2.POS=LREF.POS<1,4>
    CUSTOMER.ID = System.getVariable('EXT.SMS.CUSTOMERS')
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;*R22 Auto conversion - start
        CUSTOMER.ID = ""
    END					;*R22 Auto conversion - end

RETURN
******************
FORM.ACCT.ARRAY:
*****************

    CALL CACHE.READ(FN.AI.REDO.ARC.PARAM,'SYSTEM',R.AI.REDO.ARC.PARAM,PARAM.ERR)
    CALL CACHE.READ(FN.AI.REDO.ACCT.RESTRICT.PARAMETER,'SYSTEM',R.AI.REDO.ACCT.RESTRICT.PARAMETER,RES.ERR)
    LIST.ACCT.TYPE=R.AI.REDO.ARC.PARAM<AI.PARAM.ACCOUNT.TYPE>
    Y.RESTRICT.ACCT.TYPE = R.AI.REDO.ACCT.RESTRICT.PARAMETER<AI.RES.PARAM.RESTRICT.ACCT.TYPE>
    CHANGE @VM TO @FM IN Y.RESTRICT.ACCT.TYPE
    CALL F.READ(FN.CUSTOMER.ACCOUNT,CUSTOMER.ID,ACCT.REC,F.CUSTOMER.ACCOUNT,CUST.ERR)

    GOSUB MINOR.CUST.PARA
    LOOP
        REMOVE ACCT.ID FROM ACCT.REC SETTING ACCT.POS
    WHILE ACCT.ID:ACCT.POS

        ACC.ERR= ''
        CHECK.CATEG=''
        SAV.FLG=''
        CURR.FLG=''
        Y.FLAG = ''
        CUR.ACCT.STATUS = ''
        AC.NOFITY.STATUS = ''
        Y.POSTING.RESTRICT = ''
        Y.BAL.FLAG = ''

        CALL F.READ(FN.ACC,ACCT.ID,R.ACC,F.ACC,ACC.ERR)
        IF R.ACC THEN
            GOSUB CHECK.ACCOUNT
        END
    REPEAT

RETURN

***********************
CHECK.ACCOUNT:
***********************
    AC.NOFITY.STATUS = R.ACC<AC.LOCAL.REF><1,NOTIFY.POS>
    CUR.ACCT.STATUS1 =R.ACC<AC.LOCAL.REF><1,ACCT.STATUS.POS>
    ACCT.BAL      = R.ACC<AC.LOCAL.REF><1,ACCT.OUT.BAL.POS>
    CUR.ACCT.STATUS2 = R.ACC<AC.LOCAL.REF><1,Y.ACCT.STATUS2.POS>
    CHECK.CATEG = R.ACC<AC.CATEGORY>
    Y.POSTING.RESTRICT= R.ACC<AC.POSTING.RESTRICT>
    CUR.ACCT.CUSTOMER = R.ACC<AC.CUSTOMER>
    GOSUB RELATION.PARA
    GOSUB ACCT.CATEG.PARA
    IF NOT(Y.FLAG) AND NOT(Y.BAL.FLAG) THEN
        GOSUB LOCATE.CURR.ACC
        GOSUB LOCATE.SAV.ACC
        GOSUB CHECK.STATUS.SUB
    END
RETURN

*----------------*
MINOR.CUST.PARA:
*----------------*

    CALL F.READ(FN.JOINT.CONTRACTS.XREF,CUSTOMER.ID,R.JOINT.CONTRACTS.XREF,F.JOINT.CONTRACTS.XREF,JNT.XREF.ERR)
    ACCT.REC<-1> = R.JOINT.CONTRACTS.XREF
RETURN

*----------------*
RELATION.PARA:
*----------------*
    Y.RELATION.CODE = R.ACC<AC.RELATION.CODE>
    Y.REL.PARAM = R.AI.REDO.ARC.PARAM<AI.PARAM.RELATION.CODE>
    CHANGE @VM TO @FM IN Y.REL.PARAM
    IF CUR.ACCT.CUSTOMER NE CUSTOMER.ID THEN
        IF Y.REL.PARAM THEN
            Y.CNT.REL.CODE  = DCOUNT(Y.RELATION.CODE,@VM)
            Y.CNT.REL = 1
            LOOP
            WHILE Y.CNT.REL LE Y.CNT.REL.CODE
                Y.REL.CODE = Y.RELATION.CODE<1,Y.CNT.REL>
                LOCATE Y.REL.CODE IN Y.REL.PARAM SETTING Y.REL.POS THEN
                    RETURN
                END ELSE
                    Y.FLAG = 1
                END
                Y.CNT.REL += 1
            REPEAT
        END ELSE
            Y.FLAG = 1
        END
    END

RETURN
*----------------*
ACCT.CATEG.PARA:
*----------------*
    Y.RES.ACCT.CATEG = R.AI.REDO.ACCT.RESTRICT.PARAMETER<AI.RES.PARAM.ACCT.CATEGORY>
    CHANGE @VM TO @FM IN Y.RES.ACCT.CATEG
    LOCATE CHECK.CATEG IN Y.RES.ACCT.CATEG SETTING RES.ACCT.POS THEN
        Y.FLAG = 1
    END
RETURN
******************
CHECK.STATUS.SUB:
******************
    IF ACCT.BAL GT '0' THEN

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
*******************
LOCATE.SAV.ACC:
*****************

    SAV.STG.RGE = ''
    SAV.END.RGE = ''
    SAV.FLG = ''

    CHANGE @VM TO @FM IN LIST.ACCT.TYPE
    Y.CNT.CATEG.TYPE  = DCOUNT(LIST.ACCT.TYPE,@FM)
    Y.CNT.CAT = 1
    LOOP
    WHILE  Y.CNT.CAT LE Y.CNT.CATEG.TYPE
        Y.CATEG.ID = LIST.ACCT.TYPE<Y.CNT.CAT>
        IF 'SAVINGS' EQ Y.CATEG.ID THEN
            SAV.STR.RGE=R.AI.REDO.ARC.PARAM<AI.PARAM.CATEG.START,Y.CNT.CAT>
            SAV.END.RGE=R.AI.REDO.ARC.PARAM<AI.PARAM.CATEG.END,Y.CNT.CAT>
            IF CHECK.CATEG GE SAV.STR.RGE AND CHECK.CATEG LE SAV.END.RGE THEN
                SAV.FLG = 1
                RETURN
            END
        END
        Y.CNT.CAT += 1
    REPEAT

RETURN

***************
LOCATE.CURR.ACC:
***************
    CHANGE @VM TO @FM IN LIST.ACCT.TYPE
    LOCATE 'CURRENT' IN LIST.ACCT.TYPE SETTING SAV.ACCT.POS THEN
        SAV.STR.RGE=R.AI.REDO.ARC.PARAM<AI.PARAM.CATEG.START,SAV.ACCT.POS>
        SAV.END.RGE=R.AI.REDO.ARC.PARAM<AI.PARAM.CATEG.END,SAV.ACCT.POS>
        IF CHECK.CATEG GE SAV.STR.RGE AND CHECK.CATEG LE SAV.END.RGE THEN

            CURR.FLG=1
        END
    END

RETURN
*-----------------------------------------------------------------------------
END
*---------------------------*END OF SUBROUTINE*-------------------------------
