* @ValidationCode : Mjo0OTg0MjUyMjk6Q3AxMjUyOjE2ODEyMDA5Njc1MDM6c2FtYXI6LTE6LTE6MDowOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 11 Apr 2023 13:46:07
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
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.INP.CHECK.TRANSFER
*----------------------------------------------------------------------------------------------------
*DESCRIPTION : This routine is used to validate the REDO.TELLER.PROCESS table fields
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : SUDHARSANAN S
* PROGRAM NAME : REDO.V.TEL.CUS.NAME
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                REFERENCE         DESCRIPTION
*14-06-2011     Sudharsanan S       PACS00062653    Initial Description
*26-09-2011     JEEVA T             PACS000063147   reomving next version for piggy bank when amount is 0.0
* -----------------------------------------------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*11-04-2023            Conversion Tool             R22 Auto Code conversion                FM TO @FM,VM TO @VM,SM TO @SM, Y.CNT.BR + 1 TO +=1
*11-04-2023              Samaran T                R22 Manual Code conversion                         No Changes
*-------------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.USER
    $INSERT I_F.REDO.TELLER.PROCESS
    $INSERT I_F.REDO.H.PIGGY.BANKS
    $INSERT I_F.CUSTOMER
    $INSERT I_GTS.COMMON
    $INSERT I_F.VERSION
    $INSERT I_REDO.TELLER.PROCESS.COMMON
    $INSERT I_F.REDO.TT.GROUP.PARAM


    Y.PIGGY.BANK.VAL = R.NEW(TEL.PRO.SUB.GROUP)
    Y.VAL.WAIVE = R.NEW(TEL.PRO.GROUP)
    IF OFS.VAL.ONLY EQ '' AND MESSAGE EQ '' THEN
        GOSUB INIT
        GOSUB PROCESS
    END
    FINDSTR "PIGGY" IN Y.PIGGY.BANK.VAL SETTING POS.AP THEN
        GOSUB PROCESS.PIGGY
        GOSUB AMT.CAL.VAL
        IF R.NEW(TEL.PRO.QUANTITY) THEN
            R.NEW(TEL.PRO.AMOUNT) = VAR.AMOUNT * R.NEW(TEL.PRO.QUANTITY)
        END
    END
    FINDSTR "ALCANCIAS" IN Y.PIGGY.BANK.VAL SETTING POS.AP THEN
        GOSUB PROCESS.PIGGY
        GOSUB AMT.CAL.VAL
        IF R.NEW(TEL.PRO.QUANTITY) THEN
            R.NEW(TEL.PRO.AMOUNT) = VAR.AMOUNT * R.NEW(TEL.PRO.QUANTITY)
        END
    END
    GOSUB PGM.END
RETURN

*------------------
PROCESS.PIGGY:
*------------------
    Y.CUS.ID = R.NEW(TEL.PRO.CLIENT.ID)
    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
    R.CUS = ''
    CALL F.READ(FN.CUSTOMER,Y.CUS.ID,R.CUS,F.CUSTOMER,Y.CUS.ER)
    IF NOT(R.CUS) AND R.NEW(TEL.PRO.CLIENT.ID) THEN
        AF = TEL.PRO.CLIENT.ID
        ETEXT = 'AC-INVALID.CU'
        CALL STORE.END.ERROR
        RETURN
    END
    FN.REDO.H.PIGGY.BANKS = 'F.REDO.H.PIGGY.BANKS'
    F.REDO.H.PIGGY.BANKS = ''
    CALL OPF(FN.REDO.H.PIGGY.BANKS,F.REDO.H.PIGGY.BANKS)

    LREF.APPLN = 'USER'
    LREF.FLDS = 'L.US.IDC.BR':@VM:'L.US.IDC.CODE'
    LREF.POS = ''

    CALL MULTI.GET.LOC.REF(LREF.APPLN,LREF.FLDS,LREF.POS)
    POS.BRANCH = LREF.POS<1,1>
    POS.DEPT = LREF.POS<1,2>
    Y.PIGGY.BANK.VAL = R.NEW(TEL.PRO.SUB.GROUP)
    Y.PIGGY.FALG = ''
    Y.BRANCH.LIST = R.USER<EB.USE.LOCAL.REF,POS.BRANCH>
    Y.CODE.LIST   = R.USER<EB.USE.LOCAL.REF,POS.DEPT>
    CHANGE @SM TO @FM IN Y.BRANCH.LIST
    CHANGE @VM TO @FM IN Y.BRANCH.LIST
    CHANGE @SM TO @FM IN Y.CODE.LIST
    CHANGE @VM TO @FM IN Y.CODE.LIST
    LOCATE ID.COMPANY IN Y.BRANCH.LIST SETTING POS.BR THEN

        Y.CODE.VAL = Y.CODE.LIST<POS.BR>

    END
    GOSUB PIGGY.BANK
    Y.PIGGY.FALG = '1'
    Y.PAY.TYPE = R.NEW(TEL.PRO.PAYMENT.TYPE)
    IF Y.PAY.TYPE EQ 'TRANSFER' THEN
        Y.CUSTOMER = R.NEW(TEL.PRO.CLIENT.ID)
        IF NOT(Y.CUSTOMER) THEN
            AF = TEL.PRO.CLIENT.ID
            ETEXT = 'EB-MAND.PAYMENT.TYPE'
            CALL STORE.END.ERROR
            GOSUB PGM.END
        END
        VAR.PROCESS.ID = ID.NEW
*IF Y.PIGGY.FALG THEN
*R.VERSION(EB.VER.NEXT.VERSION) = "FUNDS.TRANSFER,SER.CREATE I F3"
*END ELSE
        R.VERSION(EB.VER.NEXT.VERSION) = "FUNDS.TRANSFER,SERVICE.CREATE I F3"
* END
    END

    Y.AMOUNT.PIGGY = ''
    Y.AMOUNT.PIGGY = R.NEW(TEL.PRO.AMOUNT)
    CHANGE '.' TO '' IN Y.AMOUNT.PIGGY
    CHANGE '0' TO '' IN Y.AMOUNT.PIGGY
    IF Y.PAY.TYPE EQ 'TRANSFER' AND Y.PIGGY.FALG EQ '1' AND NOT(Y.AMOUNT.PIGGY) THEN

        IF R.NEW(TEL.PRO.QUANTITY) THEN
            R.NEW(TEL.PRO.AMOUNT) = R.NEW(TEL.PRO.QUANTITY) * Y.AMOUNT.PIGGY
        END

        R.VERSION(EB.VER.NEXT.VERSION) = ''
        R.NEW(TEL.PRO.STATUS)  =  "PROCESSED"
    END
    IF Y.VAL.WAIVE EQ 'WAIVE FEE' AND Y.AMOUNT.PIGGY THEN
        ETEXT = 'IC-CANT.ENT.NEW.AMT.IF.WAIVE.FLAG.YES'
        CALL STORE.END.ERROR
        RETURN
    END

RETURN
*------------------
AMT.CAL.VAL:
*------------------
    FN.REDO.TT.GROUP.PARAM = 'F.REDO.TT.GROUP.PARAM'
    F.REDO.TT.GROUP.PARAM = ''
    CALL OPF(FN.REDO.TT.GROUP.PARAM,F.REDO.TT.GROUP.PARAM)

    Y.SUB.GROUP = ''
    CALL CACHE.READ(FN.REDO.TT.GROUP.PARAM,'SYSTEM',R.REDO.TT.GROUP.PARAM,GRO.ERR)
    VAR.GROUP = R.REDO.TT.GROUP.PARAM<TEL.GRO.GROUP>

    Y.GROUP = R.NEW(TEL.PRO.GROUP)
    Y.SUB.GROUP = Y.PIGGY.BANK.VAL
    CHANGE @VM TO @FM IN VAR.GROUP
    LOCATE Y.GROUP IN VAR.GROUP SETTING POS.VM THEN
        VAR.SUB.GROUP = R.REDO.TT.GROUP.PARAM<TEL.GRO.SUB.GROUP,POS.VM>
        CHANGE @SM TO @FM IN VAR.SUB.GROUP
        LOCATE Y.SUB.GROUP IN VAR.SUB.GROUP SETTING POS.SM THEN
            VAR.DESCRIPTION = R.REDO.TT.GROUP.PARAM<TEL.GRO.DESCRIPTION,POS.VM,POS.SM>
            VAR.AMOUNT = R.REDO.TT.GROUP.PARAM<TEL.GRO.CHG.AMOUNT,POS.VM,POS.SM>
        END
    END
RETURN
*---
INIT:
*---
    Y.PAY.TYPE = ''
    Y.CUSTOMER = ''

RETURN
*-------
PROCESS:
*-------
*To validate the fields and updates the value


    Y.PAY.TYPE = R.NEW(TEL.PRO.PAYMENT.TYPE)
    IF Y.PAY.TYPE EQ 'TRANSFER' THEN
        Y.CUSTOMER = R.NEW(TEL.PRO.CLIENT.ID)
        IF NOT(Y.CUSTOMER) THEN
            AF = TEL.PRO.CLIENT.ID
            ETEXT = 'EB-MAND.PAYMENT.TYPE'
            CALL STORE.END.ERROR
            GOSUB PGM.END
        END
        VAR.PROCESS.ID = ID.NEW
*IF Y.PIGGY.FALG THEN
*R.VERSION(EB.VER.NEXT.VERSION) = "FUNDS.TRANSFER,SER.CREATE I F3"
*END ELSE
        R.VERSION(EB.VER.NEXT.VERSION) = "FUNDS.TRANSFER,SERVICE.CREATE I F3"
*END
    END

RETURN

*-------------------------------------------------------------------------------------------
PIGGY.BANK:
*-------------------------------------------------------------------------------------------

    Y.QNTY.VAL = ''
    Y.UPD.FLAG = ''
    Y.SYSTEM = 'SYSTEM'
    CALL CACHE.READ(FN.REDO.H.PIGGY.BANKS,Y.SYSTEM,R.REDO.H.PIGGY.BANKS,Y.ERRR)
    IF R.REDO.H.PIGGY.BANKS THEN
        Y.BRANCH = R.REDO.H.PIGGY.BANKS<REDO.PIG.BRANCH.DEPT>
        Y.COUNT.BRAN = DCOUNT(Y.BRANCH,@VM)
        Y.CNT.BR = 1
        LOOP
        WHILE Y.CNT.BR LE Y.COUNT.BRAN
            IF ID.COMPANY EQ R.REDO.H.PIGGY.BANKS<REDO.PIG.BRANCH.DEPT,Y.CNT.BR> THEN
                Y.CODE.VAL.1 = R.REDO.H.PIGGY.BANKS<REDO.PIG.BRANCH.DEPT,Y.CNT.BR>
                GOSUB CHECK.CODE
            END
            Y.CNT.BR += 1
        REPEAT
    END
    IF R.NEW(TEL.PRO.QUANTITY) THEN
        IF Y.QNTY.VAL LT R.NEW(TEL.PRO.QUANTITY) THEN
            ETEXT = 'AC-QTY.REGISTER.L.QTY.ENTRY'
            AF = TEL.PRO.QUANTITY
            CALL STORE.END.ERROR
        END
    END ELSE
        IF Y.QNTY.VAL LE 0 THEN
            ETEXT = 'AC-QTY.REGISTER.L.QTY.ENTRY'
            AF = TEL.PRO.QUANTITY
            CALL STORE.END.ERROR
        END
    END
RETURN
*---------------------------------------------------------------------------------------------
CHECK.CODE:
*---------------------------------------------------------------------------------------------
    IF Y.CODE.VAL AND Y.CODE.VAL EQ R.REDO.H.PIGGY.BANKS<REDO.PIG.DEPT,Y.CNT.BR> THEN
        Y.QNTY.VAL =  R.REDO.H.PIGGY.BANKS<REDO.PIG.NO.AVBL,Y.CNT.BR>
    END
    IF NOT(Y.CODE.VAL) AND NOT(R.REDO.H.PIGGY.BANKS<REDO.PIG.DEPT,Y.CNT.BR>) THEN
        Y.QNTY.VAL = R.REDO.H.PIGGY.BANKS<REDO.PIG.NO.AVBL,Y.CNT.BR>
    END
RETURN
*-------------------------------------------------------------------------------------------
PGM.END:
*-----------------------------------------------------------------------------------------
END
