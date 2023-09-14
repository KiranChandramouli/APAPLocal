* @ValidationCode : MjotMTE0NTYzMzEyNDpDcDEyNTI6MTY4MTg5MDc3MjkxNTpzYW1hcjotMTotMTowOjA6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 19 Apr 2023 13:22:52
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.VAL.CHEQUE.PROCESS
*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.CHEQUE.PROCESS.VALIDATE
*--------------------------------------------------------------------------------
* Description:
*--------------------------------------------------------------------------------
*            This validation routine is be attached to the VERSION FUNDS.TRANSFER,REINV.WDL
* to populate DEBIT.ACCOUNT number and currency
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE             WHO         REFERENCE         DESCRIPTION
* 22-AUG-2011     JEEVA T      PACS00103288       changes made (DRAFT.CHECK)
*----------------------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*19-04-2023            Conversion Tool             R22 Auto Code conversion                      FM TO @FM VM TO @VM
*19-04-2023              Samaran T                R22 Manual Code conversion                         No Changes
*-----------------------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.TELLER
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.REDO.CHEQUE.PROCESS
    $INSERT I_F.REDO.APAP.REINV.CHQ.AMT


    GOSUB INIT
    GOSUB GET.LOC.VALUES
    GOSUB PROCESS
RETURN

*---------------------------------------------------------------------------------
INIT:
*---------------------------------------------------------------------------------

    FN.AZACCOUNT='F.AZ.ACCOUNT'
    F.AZACCOUNT=''
    R.AZACCOUNT=''
    CALL OPF(FN.AZACCOUNT,F.AZACCOUNT)

    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT=''
    R.ACCOUNT=''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.CUSTOMER='F.CUSTOMER'
    F.CUSTOMER=''
    R.CUSTOMER=''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.REDO.CHEQUE.PROCESS='F.REDO.CHEQUE.PROCESS'
    F.REDO.CHEQUE.PROCESS=''
    R.REDO.CHEQUE.PROCESS=''
    CALL OPF(FN.REDO.CHEQUE.PROCESS,F.REDO.CHEQUE.PROCESS)

    FN.REDO.APAP.REINV.CHQ.AMT='F.REDO.APAP.REINV.CHQ.AMT'
    F.REDO.APAP.REINV.CHQ.AMT= ''
    R.REDO.APAP.REINV.CHQ.AMT=''
    CALL OPF(FN.REDO.APAP.REINV.CHQ.AMT,F.REDO.APAP.REINV.CHQ.AMT)

    Y.VAL.DRAFT = ''
    Y.REINV.AMT = ''
RETURN

*-----------------------------------------------------------------------------
GET.LOC.VALUES:
*----------------
* Get the Needed Local table position
*
    LOC.REF.APPL="FUNDS.TRANSFER":@FM:'ACCOUNT':@FM:'CUSTOMER'
    LOC.REF.FIELDS='L.FT.REINV.AMT':@VM:'L.FT.ORG.DEPST':@VM:'BENEFIC.NAME':@FM:'L.AC.AV.BAL':@FM:'L.CU.TIPO.CL'
    LOC.REF.POS=" "
    CALL MULTI.GET.LOC.REF(LOC.REF.APPL,LOC.REF.FIELDS,LOC.REF.POS)
    Y.L.REIVSD.INT.POS     = LOC.REF.POS<1,1>
    Y.L.ORG.DP.AMT.POS     = LOC.REF.POS<1,2>
    POS.BENEFIC.NAME       = LOC.REF.POS<1,3>
    Y.L.AC.AV.BAL          = LOC.REF.POS<2,1>
    Y.L.CU.TIPO.CL         = LOC.REF.POS<3,1>


RETURN
*--------------------------------------------------------------------------------
PROCESS:
*--------------------------------------------------------------------------------
    Y.FT.ACC.REF = ''
    Y.FT.ACC.REF=COMI
    IF NOT(Y.FT.ACC.REF) THEN
        R.NEW(FT.DEBIT.ACCT.NO)  = ''
        R.NEW(CHQ.PRO.DEBIT.CUR)= ''
        R.NEW(CHQ.PRO.ORG.DEPST) = ''
        R.NEW(CHQ.PRO.INT.AMT) = ''
        RETURN
    END
    CALL F.READ(FN.AZACCOUNT,Y.FT.ACC.REF,R.AZACCOUNT,F.AZACCOUNT,Y.ERR)
    Y.INT.LIQ.ACCT = R.AZACCOUNT<AZ.INTEREST.LIQU.ACCT>
    IF Y.INT.LIQ.ACCT THEN
        CALL F.READ(FN.ACCOUNT,Y.INT.LIQ.ACCT,R.ACCOUNT,F.ACCOUNT,Y.ERR)
        Y.FIN.INT.AMT = R.ACCOUNT<AC.LOCAL.REF,Y.L.AC.AV.BAL>
        CALL F.READ(FN.REDO.APAP.REINV.CHQ.AMT,Y.INT.LIQ.ACCT,R.REDO.APAP.REINV.CHQ.AMT,F.REDO.APAP.REINV.CHQ.AMT,REINV.ERR)
        IF  R.REDO.APAP.REINV.CHQ.AMT THEN
            Y.REINV.AMOUNT = R.REDO.APAP.REINV.CHQ.AMT<REDO.CHQ.AMOUNT>
            Y.REINV.COUNT = DCOUNT(Y.REINV.AMOUNT,@VM)
            Y.INT = 1
            LOOP
            WHILE Y.INT LE Y.REINV.COUNT
                Y.STATUS  = R.REDO.APAP.REINV.CHQ.AMT<REDO.CHQ.STATUS,Y.INT>
                IF NOT(Y.STATUS) THEN
                    Y.REINV.AMT + = R.REDO.APAP.REINV.CHQ.AMT<REDO.CHQ.AMOUNT,Y.INT>
                END
                Y.INT + = 1
            REPEAT
            IF Y.REINV.AMT THEN
                Y.REINV.AMT = Y.FIN.INT.AMT - Y.REINV.AMT
            END
        END ELSE
            Y.REINV.AMT = R.ACCOUNT<AC.LOCAL.REF,Y.L.AC.AV.BAL>
        END
    END ELSE
        ETEXT = 'EB-REDO.REINV.INT.MISS'
        CALL STORE.END.ERROR
        RETURN
    END
    Y.FIN.DEP.AMT  = R.AZACCOUNT<AZ.PRINCIPAL>
    R.NEW(CHQ.PRO.DEBIT.CUR) = R.AZACCOUNT<AZ.CURRENCY>
    R.NEW(CHQ.PRO.ORG.DEPST) = TRIMB(FMT(Y.FIN.DEP.AMT,'L2,#15'))
    R.NEW(CHQ.PRO.INT.AMT) = TRIMB(FMT(Y.REINV.AMT,'L2,#15'))
    Y.DEBIT.AMOUNT = R.NEW(CHQ.PRO.DEBIT.AMOUNT)

    IF Y.REINV.AMT THEN
        R.NEW(CHQ.PRO.INT.AMT) = TRIMB(FMT(Y.REINV.AMT,'L2,#15'))
        IF Y.DEBIT.AMOUNT GT Y.REINV.AMT THEN
            ETEXT="FT-REINV.WDL"
            CALL STORE.END.ERROR
        END
    END ELSE
        R.NEW(CHQ.PRO.INT.AMT) = TRIMB(FMT(Y.FIN.INT.AMT,'L2,#15'))
        IF Y.DEBIT.AMOUNT GT Y.FIN.INT.AMT THEN
            ETEXT="FT-REINV.WDL"
            CALL STORE.END.ERROR
        END
    END


    Y.CUS.ID = R.AZACCOUNT<AZ.CUSTOMER>
    CALL F.READ(FN.CUSTOMER,Y.CUS.ID,R.CUSTOMER,F.CUSTOMER,CUS.ERR)
    VAR.TIPO.CL = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.L.CU.TIPO.CL>
    IF VAR.TIPO.CL EQ 'PERSONA JURIDICA' THEN
        Y.NAME1 = R.CUSTOMER<EB.CUS.NAME.1>
        Y.NAME2 = R.CUSTOMER<EB.CUS.NAME.2>
    END ELSE
        Y.NAME1 = R.CUSTOMER<EB.CUS.GIVEN.NAMES>
        Y.NAME2 = R.CUSTOMER<EB.CUS.FAMILY.NAME>
    END
    CHANGE @VM TO ' ' IN Y.NAME1
    CHANGE @VM TO ' ' IN Y.NAME2

    Y.L = LEN(Y.NAME1)
    Y.L1 =  LEN(Y.NAME2)
    Y.JOIN.NAME = Y.NAME1:' ':Y.NAME2
    Y.LEN.VAL = LEN(Y.JOIN.NAME)
    IF Y.LEN.VAL GT 65 THEN
        R.NEW(CHQ.PRO.BEN.NAME)<1,1>= Y.JOIN.NAME[1,65]
        R.NEW(CHQ.PRO.BEN.NAME)<1,2>= Y.JOIN.NAME[66,Y.LEN.VAL]
    END ELSE
        R.NEW(CHQ.PRO.BEN.NAME)<1,1> = Y.JOIN.NAME
    END

END
