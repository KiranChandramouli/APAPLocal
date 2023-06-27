* @ValidationCode : MjoyMTE0NDU0NTM3OkNwMTI1MjoxNjg0ODUxOTg3MzMwOklUU1M6LTE6LTE6MTM4MToxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 19:56:27
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 1381
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.NOFILE.CHANGE.ALIAS.CUST.ACCTS(CUST.ACC.DET)
*-----------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : Prabhu N
* Program Name :
*-----------------------------------------------------------------------------
* Description    :  This Nofile routine will get required details of Customer Accts
* Linked with    :
* In Parameter   :
* Out Parameter  :
*-----------------------------------------------------------------------------
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE
* 13-APRIL-2023      Conversion Tool       R22 Auto Conversion  - Added IF E EQ "EB-UNKNOWN.VARIABLE" THEN , F.READ to CACHE.READ , VM to @VM , FM to @FM , ++ to +=
* 13-APRIL-2023      Harsha                R22 Manual Conversion - Call rtn modified
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_System
    $INSERT I_EB.EXTERNAL.COMMON
    $INSERT I_F.CUSTOMER.ACCOUNT
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.CATEGORY
    $INSERT I_F.AI.REDO.ARCIB.ALIAS.TABLE
    $INSERT I_F.REDO.CUSTOMER.ARRANGEMENT
    $INSERT I_F.AI.REDO.ARCIB.PARAMETER
    $INSERT I_F.RELATION.CUSTOMER
    
*Tus Start
    $INSERT I_F.EB.CONTRACT.BALANCES
*Tus End
    $USING APAP.TAM

*---------*
MAIN.PARA:
*---------*
    CUST.ACC.DET = ''
    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN
*----------*
INITIALISE:
*----------*
    FN.CUSTOMER.ACCOUNT = "F.CUSTOMER.ACCOUNT"
    F.CUSTOMER.ACCOUNT = ''
    FN.ACCOUNT = "F.ACCOUNT"
    F.ACCOUNT = ''
    FN.AZ.ACC = 'F.AZ.ACCOUNT'
    F.AZ.ACC = ''

    FN.REDO.CUS.ARR ='F.REDO.CUSTOMER.ARRANGEMENT'
    F.REDO.CUS.ARR = ''
    FN.CATEGORY = "F.CATEGORY"
    F.CATEGORY = ''

    FN.RELATION.CUSTOMER = 'F.RELATION.CUSTOMER'
    F.RELATION.CUSTOMER = ''

    FN.JOINT.CONTRACTS.XREF = 'F.JOINT.CONTRACTS.XREF'
    F.JOINT.CONTRACTS.XREF  = ''

    FN.AI.REDO.ARC.PARAM='F.AI.REDO.ARCIB.PARAMETER'
    FN.AI.REDO.ALIAS.TABLE = 'F.AI.REDO.ARCIB.ALIAS.TABLE'
    F.AI.REDO.ALIAS.TABLE = ''
    FN.ARRANGE = 'F.AA.ARRANGEMENT'
    F.ARRANGE = ''
    LREF.POS = ''
    ACCT.STATUS=''
    SAV.ACCT.POS=''
    SAVINGS.ACCT= ''
    LREF.APP='ACCOUNT'
    LREF.FIELDS='L.AC.STATUS1':@VM:'L.AC.AV.BAL'

RETURN
*----------*
OPEN.FILES:
*----------*
    CALL OPF(FN.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT)
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    CALL OPF(FN.CATEGORY,F.CATEGORY)
    CALL OPF(FN.AZ.ACC,F.AZ.ACC)
    CALL OPF(FN.AI.REDO.ALIAS.TABLE,F.AI.REDO.ALIAS.TABLE)
    CALL OPF(FN.REDO.CUS.ARR,F.REDO.CUS.ARR)
    CALL OPF(FN.ARRANGE,F.ARRANGE)
    CALL OPF(FN.RELATION.CUSTOMER,F.RELATION.CUSTOMER)
    CALL OPF(FN.JOINT.CONTRACTS.XREF,F.JOINT.CONTRACTS.XREF)
    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELDS,LREF.POS)
    ACCT.STATUS.POS=LREF.POS<1,1>
    ACCT.OUT.BAL.POS=LREF.POS<1,2>
RETURN

*--------*
PROCESS:
*--------*

    ARR.OWNER.ID = ''
    ARR.OTHER.ID = ''
    CUST.ID = System.getVariable("EXT.SMS.CUSTOMERS")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN	;*R22 Auto Conversion  - Added IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        CUST.ID = ""
    END

    LIST.ACCT.TYPE=''
    CALL CACHE.READ(FN.AI.REDO.ARC.PARAM,'SYSTEM',R.AI.REDO.ARC.PARAM,PARAM.ERR)
    CALL F.READ(FN.REDO.CUS.ARR,CUST.ID,R.CUS.ARR,F.REDO.CUS.ARR,REDO.CR.ERR)

    ARR.OWNER.ID = R.CUS.ARR<CUS.ARR.OWNER>
    ARR.OTHER.ID = R.CUS.ARR<CUS.ARR.OTHER.PARTY>
    CHANGE @VM TO @FM IN ARR.OTHER.ID
    LIST.ACCT.TYPE=R.AI.REDO.ARC.PARAM<AI.PARAM.ACCOUNT.TYPE>

    CALL F.READ(FN.CUSTOMER.ACCOUNT,CUST.ID,R.CUST.ACC,F.CUSTOMER.ACCOUNT,CUST.ACC.ERR)
    IF ARR.OTHER.ID THEN
        R.CUST.ACC<-1>=ARR.OTHER.ID
    END
    GOSUB MINOR.CUST.PARA
    IF R.CUST.ACC THEN

        LOOP

            REMOVE ACCT.ID FROM R.CUST.ACC SETTING CUST.ACC.POS
        WHILE ACCT.ID:CUST.ACC.POS

            IF ACCT.ID[1,2] EQ 'AA' THEN
                GOSUB GET.ACCT.ID
            END
            GOSUB READ.ACCOUNT
            GOSUB CHECK.ARR.ACC

            IF NOT(ACCT.ERR) THEN

                ARR.ID = ''
                CUR.ACCT.STATUS=R.ACCT<AC.LOCAL.REF><1,ACCT.STATUS.POS>
                GOSUB READ.ALIAS.TABLE
                GOSUB AZ.READ.ACC
                CUR.ACCT.BAL = R.ACCT<AC.LOCAL.REF><1,ACCT.OUT.BAL.POS>
                CUR.ACCT.CATEG = R.ACCT<AC.CATEGORY>
                CUR.CURRENCY = R.ACCT<AC.CURRENCY>
                CUR.ACCT.OPEN.DTE = R.ACCT<AC.OPENING.DATE>
*     CUR.ACCT.OPEN.BAL = R.ACCT<AC.OPEN.ACTUAL.BAL> ;*Tus Start
                CUR.ACCT.OPEN.BAL = R.ECB<ECB.OPEN.ACTUAL.BAL> ;*Tus End
                CUR.AC.SHRT.TITLE = R.ACCT<AC.ACCOUNT.TITLE.1>
                CALL CACHE.READ(FN.CATEGORY, CUR.ACCT.CATEG, R.CATEG, CATEG.ERR)	;*R22 Auto Conversion  - F.READ to CACHE.READ
                CATEG.DESC=R.CATEG<EB.CAT.DESCRIPTION>
                CHECK.CATEG = ''
                CHECK.CATEG=R.ACCT<AC.CATEGORY>
                CUR.ACCT.CUSTOMER = R.ACCT<AC.CUSTOMER>
                GOSUB CHECK.SAV.ACCT
                GOSUB CHECK.CUR.ACCT
                GOSUB CHECK.DEP.ACCT
                GOSUB RELATION.PARA
                IF NOT(Y.FLAG) THEN
                    GOSUB CHECK.CONDITION.PARA
                END

            END
        REPEAT
    END

RETURN
*----------------*
MINOR.CUST.PARA:
*----------------*
    CALL F.READ(FN.JOINT.CONTRACTS.XREF,CUST.ID,R.JOINT.CONTRACTS.XREF,F.JOINT.CONTRACTS.XREF,JNT.XREF.ERR)
    R.CUST.ACC<-1> = R.JOINT.CONTRACTS.XREF
RETURN
*----------------*
RELATION.PARA:
*----------------*
    Y.FLAG = ''
    Y.RELATION.CODE = R.ACCT<AC.RELATION.CODE>
    Y.REL.PARAM = R.AI.REDO.ARC.PARAM<AI.PARAM.RELATION.CODE>
    CHANGE @VM TO @FM IN Y.REL.PARAM
    IF CUR.ACCT.CUSTOMER NE CUST.ID THEN
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
*********************
CHECK.CONDITION.PARA:
*********************
    IF DEP.FLAG AND CHECK.CATEG GE DEP.STR.RGE AND CHECK.CATEG LE DEP.END.RGE AND CUR.ACCT.STATUS EQ 'ACTIVE' THEN
        CUST.ACC.DET<-1> =ACCT.ID:"@":CUR.AC.SHRT.TITLE:"@":CUR.CURRENCY:"@":CUR.ALIAS.NAME:"@":CUST.ID
    END
    IF ARR.FLG.ID THEN
        CUST.ACC.DET<-1> =ACCT.ID:"@":CUR.AC.SHRT.TITLE:"@":CUR.CURRENCY:"@":CUR.ALIAS.NAME:"@":CUST.ID
    END

    IF CUR.ACCT.STATUS EQ 'ACTIVE' THEN
        IF SAV.FLG THEN
            CUST.ACC.DET<-1> =ACCT.ID:"@":CUR.AC.SHRT.TITLE:"@":CUR.CURRENCY:"@":CUR.ALIAS.NAME:"@":CUST.ID
        END
    END

    IF CHECK.CATEG GE CUR.STR.RGE AND CHECK.CATEG LE CUR.END.RGE AND CUR.ACCT.STATUS EQ 'ACTIVE' THEN
        CUST.ACC.DET<-1> =ACCT.ID:"@":CUR.AC.SHRT.TITLE:"@":CUR.CURRENCY:"@":CUR.ALIAS.NAME:"@":CUST.ID
    END
RETURN

*---------------*
AZ.READ.ACC:
*---------------*
    R.AZ.REC=''
    AZ.PRIN.AMT = ''
    DEP.FLAG = ''
    CALL F.READ(FN.AZ.ACC,ACCT.ID,R.AZ.REC,F.AZ.ACC,AZ.ERR)
    IF R.AZ.REC THEN

        AZ.PRIN.AMT = R.AZ.REC<AZ.PRINCIPAL>
        IF AZ.PRIN.AMT GT '0' THEN
            DEP.FLAG = 1
        END
    END

RETURN

*----------------*
READ.ALIAS.TABLE:
*---------------*
    R.ALIAS.REC = ''
    CUR.ALIAS.NAME = ''
    CALL F.READ(FN.AI.REDO.ALIAS.TABLE,ACCT.ID,R.ALIAS.REC,F.AI.REDO.ALIAS.TABLE,ALIAS.ERR)
    IF R.ALIAS.REC THEN
        CUR.ALIAS.NAME = R.ALIAS.REC<AI.ALIAS.ALIAS.NAME>

    END

RETURN

*---------------*
CHECK.ARR.ACC:
*---------------*
    ARR.FLG.ID = ''
    IF CHECK.ARR.ID THEN
        LOCATE CHECK.ARR.ID IN ARR.OWNER.ID<1,1> SETTING OWNER.POS THEN
            ARR.FLG.ID = 1
        END

        LOCATE CHECK.ARR.ID IN ARR.OTHER.ID SETTING OTHER.POS THEN

            ARR.FLG.ID = 1
        END

    END

RETURN


***************
READ.ACCOUNT:
**************
    R.ACCT= ''
    CALL F.READ(FN.ACCOUNT,ACCT.ID,R.ACCT,F.ACCOUNT,ACCT.ERR)
    R.ECB= '' ; ECB.ERR='' ;*Tus Start
    CALL EB.READ.HVT("EB.CONTRACT.BALANCES",ACCT.ID,R.ECB,ECB.ERR) ;*Tus End
    IF R.ACCT THEN
        CHECK.ARR.ID = R.ACCT<AC.ARRANGEMENT.ID>

    END

RETURN

************
GET.ACCT.ID:
************

    Y.ARR.ID = ''
    IN.ACC.ID=''
    IN.ARR.ID=ACCT.ID
    OUT.ID=''
    APAP.TAM.redoConvertAccount(IN.ACC.ID,IN.ARR.ID,OUT.ID,ERR.TEXT);*R22 Manual Conversion
    ACCT.ID=OUT.ID

RETURN


***************
CHECK.SAV.ACCT:
***************
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

*****************
CHECK.CUR.ACCT:
****************
    CHANGE @VM TO @FM IN LIST.ACCT.TYPE
    CUR.STR.RGE = ''
    CUR.END.RGE = ''
    LOCATE 'CURRENT' IN LIST.ACCT.TYPE SETTING SAV.ACCT.POS THEN
        CUR.STR.RGE=R.AI.REDO.ARC.PARAM<AI.PARAM.CATEG.START,SAV.ACCT.POS>
        CUR.END.RGE=R.AI.REDO.ARC.PARAM<AI.PARAM.CATEG.END,SAV.ACCT.POS>
    END

RETURN
***************
CHECK.DEP.ACCT:
***************
    CHANGE @VM TO @FM IN LIST.ACCT.TYPE
    DEP.STR.RGE=''
    DEP.END.RGE=''
    LOCATE 'DEPOSIT' IN LIST.ACCT.TYPE SETTING DEP.ACCT.POS THEN
        DEP.STR.RGE=R.AI.REDO.ARC.PARAM<AI.PARAM.CATEG.START,DEP.ACCT.POS>
        DEP.END.RGE=R.AI.REDO.ARC.PARAM<AI.PARAM.CATEG.END,DEP.ACCT.POS>
    END
RETURN
****************
*READ.ARR.ACCOUNT:
***************
*   CALL F.READ(FN.ARRANGE,ARRANGE.ID,R.ARR.REC,F.ARRANGE,ARR.ERR)
*   IF NOT(ARR.ERR) THEN

*      ARR.FLG=1
*  END

* RETURN

END
