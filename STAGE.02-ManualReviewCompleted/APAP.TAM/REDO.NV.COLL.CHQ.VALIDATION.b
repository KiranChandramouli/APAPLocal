* @ValidationCode : MjotMTI0NDI0NTk0NjpDcDEyNTI6MTY4MTM3NjA5ODc4ODpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
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
SUBROUTINE REDO.NV.COLL.CHQ.VALIDATION
*--------------------------------------------------
*Description: This Input routine is to validation the Collection area
* version for entering the cheque no.
*--------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* Modification History:
*
* Date             Who                   Reference      Description
* 13.04.2023       Conversion Tool       R22            Auto Conversion     - FM TO @FM, VM TO @VM, SM TO @SM, ++ TO += 1
* 13.04.2023       Shanmugapriya M       R22            Manual Conversion   - Add call routine prefix
*
*------------------------------------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_GTS.COMMON
    $INSERT I_F.REDO.MULTITXN.VERSIONS
    $INSERT I_F.REDO.TRANSACTION.CHAIN


    IF OFS$SOURCE.ID EQ 'FASTPATH' THEN
        RETURN
    END
    GOSUB GET.LOC.REF
    IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
        GOSUB PROCESS
    END
    IF APPLICATION EQ 'TELLER' THEN
        GOSUB PROCESS.TELLER
    END

RETURN
*--------------------------------------------------
GET.LOC.REF:
*--------------------------------------------------

    FN.REDO.MULTITXN.VERSIONS = 'F.REDO.MULTITXN.VERSIONS'
    F.REDO.MULTITXN.VERSIONS = ''
    CALL OPF(FN.REDO.MULTITXN.VERSIONS,F.REDO.MULTITXN.VERSIONS)

    FN.REDO.TRANSACTION.CHAIN = 'F.REDO.TRANSACTION.CHAIN'
    F.REDO.TRANSACTION.CHAIN  = ''
    CALL OPF(FN.REDO.TRANSACTION.CHAIN,F.REDO.TRANSACTION.CHAIN)

    FN.FT = 'F.FUNDS.TRANSFER'
    F.FT  = ''
    CALL OPF(FN.FT,F.FT)

    FN.FT.NAU = 'F.FUNDS.TRANSFER$NAU'
    F.FT.NAU  = ''
    CALL OPF(FN.FT.NAU,F.FT.NAU)


    LOC.REF.APPLICATION   = "FUNDS.TRANSFER":@FM:"TELLER"
    LOC.REF.FIELDS        = 'L.ACTUAL.VERSIO':@VM:'L.NEXT.VERSION':@VM:'CERT.CHEQUE.NO':@FM:'L.INITIAL.ID':@VM:'L.NEXT.VERSION'
    LOC.REF.POS           = ''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.L.ACTUAL.VERSIO   = LOC.REF.POS<1,1>
    POS.L.NEXT.VERSION    = LOC.REF.POS<1,2>
    POS.CERT.CHEQUE.NO    = LOC.REF.POS<1,3>
    POS.TT.L.INITIAL.ID   = LOC.REF.POS<2,1>
    POS.TT.L.NEXT.VERSION = LOC.REF.POS<2,2>

RETURN
*--------------------------------------------------
PROCESS:
*--------------------------------------------------
    Y.CURRENT.VERSION = R.NEW(FT.LOCAL.REF)<1,POS.L.ACTUAL.VERSIO>

    SEL.CMD = 'SELECT ':FN.REDO.MULTITXN.VERSIONS:' WITH VERSION.NAME EQ ':Y.CURRENT.VERSION
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',SEL.NOR,SEL.RET)
    Y.MUL.TXN.ID = SEL.LIST<1>
    CALL F.READ(FN.REDO.MULTITXN.VERSIONS,Y.MUL.TXN.ID,R.REDO.MULTITXN.VERSIONS,F.REDO.MULTITXN.VERSIONS,MULTXN.ERR)
    IF R.REDO.MULTITXN.VERSIONS THEN
        Y.VERSION.TYPES = R.REDO.MULTITXN.VERSIONS<RMV.VERSION.TYPE>
        Y.PROC.TYPE     = R.REDO.MULTITXN.VERSIONS<RMV.PROC.TYPE>
        Y.RECEP.METHOD  = R.REDO.MULTITXN.VERSIONS<RMV.RECEP.METHOD>
    END ELSE
        RETURN
    END

    IF Y.VERSION.TYPES EQ 'AA.COLLECTION' THEN
        GOSUB CHECK.CHEQUE
        GOSUB CHEQUE.NO.VAL
    END
RETURN
*--------------------------------------------------
CHECK.CHEQUE:
*--------------------------------------------------
    Y.NEXT.VERSION = R.NEW(FT.LOCAL.REF)<1,POS.L.NEXT.VERSION>

    SEL.CMD = 'SELECT ':FN.REDO.MULTITXN.VERSIONS:' WITH VERSION.NAME EQ ':Y.NEXT.VERSION
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',SEL.NOR,SEL.RET)
    Y.MUL.TXN.ID = SEL.LIST<1>
    CALL F.READ(FN.REDO.MULTITXN.VERSIONS,Y.MUL.TXN.ID,R.REDO.MULTITXN.VERSIONS,F.REDO.MULTITXN.VERSIONS,MULTXN.ERR)
    IF R.REDO.MULTITXN.VERSIONS THEN
        Y.NEXT.VERSION.TYPE = R.REDO.MULTITXN.VERSIONS<RMV.VERSION.TYPE>
        IF R.REDO.MULTITXN.VERSIONS<RMV.VERSION.TYPE> EQ 'CHEQUE' THEN
            GOSUB CHECK.CHEQUE.OTHER
        END
    END
RETURN
*--------------------------------------------------
CHECK.CHEQUE.OTHER:
*--------------------------------------------------
    Y.CHEQUES.NO = R.NEW(FT.LOCAL.REF)<1,POS.CERT.CHEQUE.NO>
    IF Y.CHEQUES.NO EQ '' THEN
        AF = FT.LOCAL.REF
        AV = POS.CERT.CHEQUE.NO
        AS = 1
        ETEXT = 'EB-REDO.CHEQUE.MAND'
        CALL STORE.END.ERROR
    END
    Y.VAR1 = 1
    Y.CHQ.CNT = DCOUNT(Y.CHEQUES.NO,@SM)
    LOOP
    WHILE Y.VAR1 LE Y.CHQ.CNT
        IF Y.CHEQUES.NO<1,1,Y.VAR1> EQ '' THEN
            AF = FT.LOCAL.REF
            AV = POS.CERT.CHEQUE.NO
            AS = Y.VAR1
            ETEXT = 'EB-REDO.CHEQUE.MAND'
            CALL STORE.END.ERROR
        END
        Y.VAR1 += 1                ;** R22 Auto conversion - ++ TO += 1
    REPEAT
RETURN
*-------------------------------------------------
CHEQUE.NO.VAL:
*-------------------------------------------------
    Y.CHEQUES.NO = R.NEW(FT.LOCAL.REF)<1,POS.CERT.CHEQUE.NO>
    IF Y.CHEQUES.NO THEN
        IF Y.NEXT.VERSION.TYPE NE 'CHEQUE' THEN
            AF = FT.LOCAL.REF
            AV = POS.L.NEXT.VERSION
            ETEXT = 'EB-REDO.NEXT.VERSION.CHQ'
            CALL STORE.END.ERROR
        END
    END
RETURN

*-------------------------------------------------
PROCESS.TELLER:
*-------------------------------------------------

    Y.TRANS.ID = R.NEW(TT.TE.LOCAL.REF)<1,POS.TT.L.INITIAL.ID>

    IF Y.TRANS.ID ELSE
        RETURN
    END

*CALL REDO.GET.NV.VERSION.TYPES(Y.TRANS.ID,Y.VERSION.NAMES,Y.VERSION.TYPES,Y.PROC.TYPE,Y.RECEP.METHOD)
** R22 Manual conversion
    CALL APAP.TAM.REDO.GET.NV.VERSION.TYPES(Y.TRANS.ID,Y.VERSION.NAMES,Y.VERSION.TYPES,Y.PROC.TYPE,Y.RECEP.METHOD)

    LOCATE 'AA.COLLECTION' IN Y.VERSION.TYPES SETTING POS1 THEN
        GOSUB GET.NEXT.VERSION
        IF Y.VERSION.TYPE.TT EQ 'CHEQUE' THEN
            GOSUB PROCESS.CHECK.TT
        END
    END


RETURN
*-------------------------------------------------
GET.NEXT.VERSION:
*-------------------------------------------------
    Y.NEXT.VERSION.TT = R.NEW(TT.TE.LOCAL.REF)<1,POS.TT.L.NEXT.VERSION>
    SEL.CMD = 'SELECT ':FN.REDO.MULTITXN.VERSIONS:' WITH VERSION.NAME EQ ':Y.NEXT.VERSION.TT
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',SEL.NOR,SEL.RET)
    Y.MUL.TXN.ID = SEL.LIST<1>
    CALL F.READ(FN.REDO.MULTITXN.VERSIONS,Y.MUL.TXN.ID,R.REDO.MULTITXN.VERSIONS,F.REDO.MULTITXN.VERSIONS,MULTXN.ERR)
    IF R.REDO.MULTITXN.VERSIONS THEN
        Y.VERSION.TYPE.TT = R.REDO.MULTITXN.VERSIONS<RMV.VERSION.TYPE>
    END ELSE
        RETURN
    END

RETURN
*-------------------------------------------------
PROCESS.CHECK.TT:
*-------------------------------------------------

    CALL F.READ(FN.REDO.TRANSACTION.CHAIN,Y.TRANS.ID,R.RTC,F.REDO.TRANSACTION.CHAIN,ERR.RTC)
    IF R.RTC ELSE
        RETURN
    END
    Y.CHEQUE.NO.FT = ''
    Y.TRANSACTION.REF = R.RTC<RTC.TRANS.ID>
    Y.TRANS.CNT = DCOUNT(Y.TRANSACTION.REF,@VM)
    Y.VAR1 = 1
    LOOP
    WHILE Y.VAR1 LE Y.TRANS.CNT
        Y.FT.ID = Y.TRANSACTION.REF<1,Y.VAR1>
        IF Y.FT.ID[1,2] EQ 'FT' ELSE
            Y.VAR1 += 1                  ;** R22 Auto conversion - ++ TO += 1
            CONTINUE
        END
        CALL F.READ(FN.FT,Y.FT.ID,R.FT,F.FT,FT.ERR)
        IF R.FT ELSE
            CALL F.READ(FN.FT.NAU,Y.FT.ID,R.FT,F.FT.NAU,FT.ERR)
        END
        IF R.FT<FT.LOCAL.REF,POS.CERT.CHEQUE.NO> THEN
            Y.CHEQUE.NO.FT = R.FT<FT.LOCAL.REF,POS.CERT.CHEQUE.NO>
        END
        Y.VAR1 += 1                   ;** R22 Auto conversion - ++ TO += 1
    REPEAT

    IF Y.CHEQUE.NO.FT EQ '' THEN
        ETEXT = 'EB-REDO.NO.CHQ.ALLOWED'
        AF = TT.TE.LOCAL.REF
        AV = POS.TT.L.NEXT.VERSION
        CALL STORE.END.ERROR

    END
RETURN
END
