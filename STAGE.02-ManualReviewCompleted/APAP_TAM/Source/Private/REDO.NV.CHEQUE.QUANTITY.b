* @ValidationCode : Mjo0MDcyMTYxMjA6Q3AxMjUyOjE2ODEzNzYwOTg3MzY6SVRTUzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 13 Apr 2023 14:24:58
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.NV.CHEQUE.QUANTITY
*-----------------------------------------------------------------------------
* Description: This routine is to check the quantity enter in FT repayment.
*-----------------------------------------------------------------------------------------------------
* Modification History:
*
* Date             Who                   Reference      Description
* 13.04.2023       Conversion Tool       R22            Auto Conversion     - FM TO @FM, VM TO @VM, SM TO @SM, ++ TO += 1
* 13.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*------------------------------------------------------------------------------------------------------



    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_GTS.COMMON
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.REDO.TRANSACTION.CHAIN
    $INSERT I_F.REDO.MULTITXN.VERSIONS


    IF OFS$SOURCE.ID EQ 'FASTPATH' THEN
        RETURN
    END

    GOSUB Y.GET.LOC.REF
    GOSUB OPEN.FILES
    GOSUB PROCESS
RETURN
*------------------------------------------
OPEN.FILES:
*------------------------------------------

    FN.REDO.TRANSACTION.CHAIN = 'F.REDO.TRANSACTION.CHAIN'
    F.REDO.TRANSACTION.CHAIN  = ''
    CALL OPF(FN.REDO.TRANSACTION.CHAIN,F.REDO.TRANSACTION.CHAIN)

    FN.TELLER = 'F.TELLER$NAU'
    F.TELLER = ''
    CALL OPF(FN.TELLER,F.TELLER)

    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER$NAU'
    F.FUNDS.TRANSFER = ''
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

    FN.REDO.MULTITXN.VERSIONS = 'F.REDO.MULTITXN.VERSIONS'
    F.REDO.MULTITXN.VERSIONS  = ''
    CALL OPF(FN.REDO.MULTITXN.VERSIONS,F.REDO.MULTITXN.VERSIONS)

RETURN
*------------------------------------------
Y.GET.LOC.REF:
*------------------------------------------

    LOC.REF.APPLICATION="FUNDS.TRANSFER":@FM:"TELLER"
    LOC.REF.FIELDS='L.FT.ADD.INFO':@VM:'L.INITIAL.ID':@VM:'L.NEXT.VERSION':@VM:'CERT.CHEQUE.NO':@VM:'L.ACTUAL.VERSIO':@FM:'L.INITIAL.ID'
    LOC.REF.POS=''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.L.FT.ADD.INFO    = LOC.REF.POS<1,1>
    POS.L.INITIAL.ID     = LOC.REF.POS<1,2>
    POS.L.NEXT.VERSION   = LOC.REF.POS<1,3>
    POS.CERT.CHEQUE.NO   = LOC.REF.POS<1,4>
    POS.L.ACTUAL.VERSIO  = LOC.REF.POS<1,5>
    POS.TT.L.INITIAL.ID  = LOC.REF.POS<2,1>
RETURN
*------------------------------------------
PROCESS:
*------------------------------------------
    IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
        GOSUB PROCESS.FT
    END
    IF APPLICATION EQ 'TELLER' THEN
        GOSUB PROCESS.TT
    END
RETURN
*------------------------------------------
PROCESS.TT:
*------------------------------------------

    Y.INITIAL.ID = R.NEW(TT.TE.LOCAL.REF)<1,POS.TT.L.INITIAL.ID>
    IF Y.INITIAL.ID EQ ID.NEW OR Y.INITIAL.ID EQ '' THEN
        RETURN
    END
    GOSUB GET.QUANTITY
    IF Y.CHK.NUMBERS ELSE
        RETURN
    END
    Y.TT.CHEQUE.QUAN = Y.CHK.QUAN + R.NEW(TT.TE.CHEQUE.NUMBER)
    CHANGE @SM TO @FM IN Y.CHK.NUMBERS
    CHANGE @VM TO @FM IN Y.CHK.NUMBERS

    Y.COUNT = DCOUNT(Y.CHK.NUMBERS,@FM)

    IF Y.COUNT NE Y.TT.CHEQUE.QUAN THEN
        AF = TT.TE.CHEQUE.NUMBER
        ETEXT = 'EB-REDO.CHECK.QUANTITY.MISMATCH'
        CALL STORE.END.ERROR
    END

RETURN
*------------------------------------------
PROCESS.FT:
*------------------------------------------
*Y.VERSION.TYPE = R.NEW(FT.LOCAL.REF)<1,POS.L.FT.ADD.INFO>
    Y.NEXT.VERSION = R.NEW(FT.LOCAL.REF)<1,POS.L.NEXT.VERSION>
    Y.INITIAL.ID   = R.NEW(FT.LOCAL.REF)<1,POS.L.INITIAL.ID>
    Y.VERSION.NAME = R.NEW(FT.LOCAL.REF)<1,POS.L.ACTUAL.VERSIO>
    GOSUB GET.VERSION.NAME
    IF Y.VERSION.TYPES NE 'AA.PAYMENT' AND Y.VERSION.TYPES NE 'AA.COLLECTION'  OR Y.INITIAL.ID EQ ID.NEW THEN   ;*  If it is not a repayment version or this is first transaction then skip.
        RETURN
    END

    IF Y.VERSION.TYPES EQ 'AA.PAYMENT' AND Y.RECEP.METHOD EQ 'E' THEN   ;* In case of Payment area version but cash & transfer.
        RETURN
    END


    GOSUB GET.QUANTITY

    IF Y.CHK.QUAN EQ 0 AND Y.CHK.NUMBERS EQ '' THEN
        RETURN
    END

    Y.NEW.CHK.NO   = R.NEW(FT.LOCAL.REF)<1,POS.CERT.CHEQUE.NO>
    IF Y.CHK.QUAN GT 0 THEN
        GOSUB CHECK.QUANTITY
    END
    IF Y.CHK.NUMBERS THEN
        GOSUB CHECK.CHEQ.NOS
    END

RETURN
*-------------------------------------------------
CHECK.QUANTITY:
*-------------------------------------------------
    Y.CUR.QUANTITY = DCOUNT(Y.NEW.CHK.NO,@SM)
    IF Y.CHK.QUAN NE Y.CUR.QUANTITY THEN
        AF = FT.LOCAL.REF
        AV = POS.CERT.CHEQUE.NO
        ETEXT = 'EB-REDO.CHECK.QUANTITY.MISMATCH'
        CALL STORE.END.ERROR
    END

RETURN
*------------------------------------------
CHECK.CHEQ.NOS:
*------------------------------------------
    Y.SORT.CHK.NUMBERS = SORT(Y.CHK.NUMBERS)
    Y.SORT.CUR.NUMBERS = SORT(Y.NEW.CHK.NO)

    IF Y.SORT.CHK.NUMBERS NE Y.SORT.CUR.NUMBERS THEN
        AF = FT.LOCAL.REF
        AV = POS.CERT.CHEQUE.NO
        ETEXT = 'EB-REDO.CHEQUE.NO.MISMATCH'
        CALL STORE.END.ERROR
    END


RETURN
*------------------------------------------
GET.QUANTITY:
*------------------------------------------
    CALL F.READ(FN.REDO.TRANSACTION.CHAIN,Y.INITIAL.ID,R.RTC,F.REDO.TRANSACTION.CHAIN,RTC.ERR)
    Y.TRANSACTION.REF = R.RTC<RTC.TRANS.ID>
    Y.TRANS.CNT = DCOUNT(Y.TRANSACTION.REF,@VM)
    Y.CHK.QUAN    = 0
    Y.CHK.NUMBERS = ''

    Y.VAR1 = 1
    LOOP
    WHILE Y.VAR1 LE Y.TRANS.CNT

        Y.TRANS.ID =  Y.TRANSACTION.REF<1,Y.VAR1>
        IF Y.TRANS.ID[1,2] EQ 'TT' THEN
            CALL F.READ(FN.TELLER,Y.TRANS.ID,R.TT,F.TELLER,TT.ERR)
            Y.CHK.QUAN += R.TT<TT.TE.CHEQUE.NUMBER>

        END ELSE
            CALL F.READ(FN.FUNDS.TRANSFER,Y.TRANS.ID,R.FT,F.FUNDS.TRANSFER,FT.ERR)
            IF R.FT<FT.LOCAL.REF,POS.CERT.CHEQUE.NO> THEN
                Y.CHK.NUMBERS = R.FT<FT.LOCAL.REF,POS.CERT.CHEQUE.NO>
            END
        END

        Y.VAR1 += 1                ;** R22 Auto conversion - ++ TO += 1
    REPEAT

RETURN
*--------------------------------------------------------
GET.VERSION.NAME:
*--------------------------------------------------------

    SEL.CMD = 'SELECT ':FN.REDO.MULTITXN.VERSIONS:' WITH VERSION.NAME EQ ':Y.VERSION.NAME
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',SEL.NOR,SEL.RET)
    Y.MUL.TXN.ID = SEL.LIST<1>
    CALL F.READ(FN.REDO.MULTITXN.VERSIONS,Y.MUL.TXN.ID,R.REDO.MULTITXN.VERSIONS,F.REDO.MULTITXN.VERSIONS,MULTXN.ERR)
    Y.VERSION.TYPES = ''
    IF R.REDO.MULTITXN.VERSIONS THEN
        Y.VERSION.TYPES = R.REDO.MULTITXN.VERSIONS<RMV.VERSION.TYPE>
        Y.RECEP.METHOD  = R.REDO.MULTITXN.VERSIONS<RMV.RECEP.METHOD>
    END

RETURN
END
