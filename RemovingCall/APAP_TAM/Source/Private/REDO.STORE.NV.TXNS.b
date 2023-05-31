* @ValidationCode : MjotMTQ1NzExMDc2NDpDcDEyNTI6MTY4NDg0MjEzMjgwMjpJVFNTOi0xOi0xOjE1NTE6MTpmYWxzZTpOL0E6UjIyX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 17:12:12
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 1551
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.STORE.NV.TXNS

** 17-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 17-04-2023 Skanda R22 Manual Conversion - added APAP.TAM, CALL routine format modified
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.TELLER
    $INSERT I_F.OVERRIDE
    $INSERT I_DEAL.SLIP.COMMON
    $INSERT I_F.VERSION
    $INSERT I_GTS.COMMON
    $INSERT I_RC.COMMON
    $INSERT I_System
    $INSERT I_F.REDO.STORE.SPOOL.ID
    $USING APAP.REDOVER
*-------------------------------------------------------------------------------
*
    IF OFS$SOURCE.ID EQ 'FASTPATH' AND R.VERSION(EB.VER.VERSION.TYPE) EQ 'NV' THEN
        RETURN
    END

    Y.APLS = 'TELLER':@FM:'FUNDS.TRANSFER'
    Y.FIELDS = 'L.NEXT.VERSION':@VM:'L.INITIAL.ID':@FM:'L.NEXT.VERSION':@VM:'L.INITIAL.ID'
    PSO = ''
    CALL MULTI.GET.LOC.REF(Y.APLS,Y.FIELDS,PSO) ;*MANUAL R22 CODE CONVERSION
    Y.TT.NXT = PSO<1,1>
    Y.TT.INIT= PSO<1,2>
    Y.FT.NXT = PSO<2,1>
    Y.FT.INIT = PSO<2,2>

    FN.REDO.NV.TXN.CHAIN = 'F.REDO.NV.TXN.CHAIN'
    F.REDO.NV.TXN.CHAIN = ''
    CALL OPF(FN.REDO.NV.TXN.CHAIN,F.REDO.NV.TXN.CHAIN)

    FN.FT.NAU = 'F.FUNDS.TRANSFER$NAU'
    F.FT.NAU = ''
    CALL OPF(FN.FT.NAU,F.FT.NAU)

    FN.TT.NAU = 'F.TELLER$NAU'
    F.TT.NAU = ''
    CALL OPF(FN.TT.NAU,F.TT.NAU)

    FN.OVERRIDE = 'F.OVERRIDE'
    F.OVERRIDE = ''
    CALL OPF(FN.OVERRIDE,F.OVERRIDE)

    FN.REDO.STORE.SPOOL.ID = 'F.REDO.STORE.SPOOL.ID'
    F.REDO.STORE.SPOOL.ID = ''
    CALL OPF(FN.REDO.STORE.SPOOL.ID,F.REDO.STORE.SPOOL.ID)



    IF APPLICATION EQ 'TELLER' THEN
        Y.ID = R.NEW(TT.TE.LOCAL.REF)<1,Y.TT.INIT>
        IF R.NEW(TT.TE.LOCAL.REF)<1,Y.TT.NXT> NE '' THEN
            GOSUB READ.TXN.CHAIN
        END ELSE
            CALL F.READ(FN.REDO.NV.TXN.CHAIN,Y.ID,R.REDO.NV.TXN.CHAIN,F.REDO.NV.TXN.CHAIN,CHAIN.ERR)
            IF R.REDO.NV.TXN.CHAIN THEN
                R.REDO.NV.TXN.CHAIN<-1> = ID.NEW
                CALL F.WRITE(FN.REDO.NV.TXN.CHAIN,Y.ID,R.REDO.NV.TXN.CHAIN)
*                GOSUB PRINT.RTE.FORM        ;* Commented as RTE form will be generated in REDO.GET.SPOOL
            END
        END
    END

    IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
        Y.ID = R.NEW(FT.LOCAL.REF)<1,Y.FT.INIT>
        IF R.NEW(FT.LOCAL.REF)<1,Y.FT.NXT> NE '' THEN
            GOSUB READ.TXN.CHAIN
        END ELSE
            CALL F.READ(FN.REDO.NV.TXN.CHAIN,Y.ID,R.REDO.NV.TXN.CHAIN,F.REDO.NV.TXN.CHAIN,CHAIN.ERR)
            IF R.REDO.NV.TXN.CHAIN THEN
                R.REDO.NV.TXN.CHAIN<-1> = ID.NEW
                CALL F.WRITE(FN.REDO.NV.TXN.CHAIN,Y.ID,R.REDO.NV.TXN.CHAIN)
*                GOSUB PRINT.RTE.FORM        ;* Commented as RTE form will be generated in REDO.GET.SPOOL
            END
        END
    END

RETURN

READ.TXN.CHAIN:

    CALL F.READ(FN.REDO.NV.TXN.CHAIN,Y.ID,R.REDO.NV.TXN.CHAIN,F.REDO.NV.TXN.CHAIN,CHAIN.ERR)
    IF NOT(R.REDO.NV.TXN.CHAIN) THEN
        R.REDO.NV.TXN.CHAIN = Y.ID
        CALL F.WRITE(FN.REDO.NV.TXN.CHAIN,Y.ID,R.REDO.NV.TXN.CHAIN)
    END ELSE
        R.REDO.NV.TXN.CHAIN<-1> = ID.NEW
        CALL F.WRITE(FN.REDO.NV.TXN.CHAIN,Y.ID,R.REDO.NV.TXN.CHAIN)
    END

RETURN

PRINT.RTE.FORM:

    Y.CNT = DCOUNT(R.REDO.NV.TXN.CHAIN,@FM)
    FLG = ''
    LOOP
    WHILE Y.CNT GT 0 DO
        FLG += 1
        Y.TXN.IDS = R.REDO.NV.TXN.CHAIN<FLG>
        IF Y.TXN.IDS[1,2] EQ 'FT' THEN
            CALL F.READ(FN.FT.NAU,Y.TXN.IDS,R.FT.NAU,F.FT.NAU,FT.NAU.ERR)
            IF R.FT.NAU THEN
                Y.OVRRIDES = R.FT.NAU<FT.OVERRIDE>
                GOSUB ANALYSE.OVERRIDE
            END ELSE
                Y.NEWID = ID.NEW
                IF Y.NEWID EQ Y.TXN.IDS THEN
                    Y.OVRRIDES = OFS$OVERRIDES<1>
                    GOSUB ANALYSE.OVERRIDE.1
                END
            END
            IF Y.RTE EQ 'YES' THEN
                GOSUB GEN.RTE
            END
        END
        Y.CNT -= 1
    REPEAT

RETURN

ANALYSE.OVERRIDE:

    VAR.OVERRIDE.ID = 'AML.TXN.AMT.EXCEED'
    CALL CACHE.READ(FN.OVERRIDE, VAR.OVERRIDE.ID, R.OVERRIDE, ERR.MSG) ;* R22 Auto conversion

    VAR.MESSAGE1 = R.OVERRIDE<EB.OR.MESSAGE,1,2>
    VAR.MESSAGE2 = 'YES'

    VAR.OFS.OVERRIDE1 = Y.OVRRIDES
    CHANGE @VM TO @FM IN VAR.OFS.OVERRIDE1

    VAR.RTE.CHK = ""

    FINDSTR VAR.OVERRIDE.ID IN VAR.OFS.OVERRIDE1 SETTING POS1 THEN
        Y.RTE = 'YES'
    END ELSE
        Y.RTE = 'NO'
    END

RETURN

ANALYSE.OVERRIDE.1:

    CALL CACHE.READ(FN.OVERRIDE, VAR.OVERRIDE.ID, R.OVERRIDE, ERR.MSG) ;* R22 Auto conversion
*
* Getting the Override Message
*
    VAR.MESSAGE1 = R.OVERRIDE<EB.OR.MESSAGE,1,2>
    VAR.MESSAGE2 = 'YES'
*
*  Getting the Override Message Values
*
    VAR.OFS.OVERRIDE1 = OFS$OVERRIDES<1>
    VAR.OFS.OVERRIDE2 = OFS$OVERRIDES<2>
*
*  Converting to FM for locate Purpose
*
    CHANGE @VM TO @FM IN VAR.OFS.OVERRIDE1
    CHANGE @VM TO @FM IN VAR.OFS.OVERRIDE2
*
*  Checking FOR the override MESSAGE
*
    VAR.RTE.CHK = ""
*
    LOCATE VAR.MESSAGE1 IN VAR.OFS.OVERRIDE1 SETTING POS1 THEN
        Y.SETT = 'YES'
    END ELSE
        POS1 = ''
    END

    LOCATE VAR.MESSAGE2 IN VAR.OFS.OVERRIDE2 SETTING POS2 THEN
        IF Y.SETT EQ 'YES' THEN
            Y.RTE = 'YES'
        END ELSE
            Y.RTE = 'NO'
        END
    END

RETURN

GEN.RTE:

    Y.DUP.ID = ID.NEW
    ID.NEW = Y.TXN.IDS
    OFS$DEAL.SLIP.PRINTING = 1
    CALL PRODUCE.DEAL.SLIP('AML.FT.RTEFRD')
    ID.NEW = Y.DUP.ID

    Y.HID = C$LAST.HOLD.ID
    Y.HID = CHANGE(Y.HID,',',@VM)

    WTT.ID = System.getVariable("CURRENT.INDA.ID")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;* R22 Auto conversion
        WTT.ID = "" ;* R22 Auto conversion
    END ;* R22 Auto conversion

    R.REDO.STORE.SPOOL.ID = ''
    CALL F.READ(FN.REDO.STORE.SPOOL.ID,WTT.ID,R.REDO.STORE.SPOOL.ID,F.REDO.STORE.SPOOL.ID,SPL.ERR)
    IF NOT(R.REDO.STORE.SPOOL.ID) THEN
        R.REDO.STORE.SPOOL.ID = Y.HID
        CALL F.WRITE(FN.REDO.STORE.SPOOL.ID,WTT.ID,R.REDO.STORE.SPOOL.ID)
    END ELSE
        R.REDO.STORE.SPOOL.ID<RD.SPL.SPOOL.ID,-1> = Y.HID
        CALL F.WRITE(FN.REDO.STORE.SPOOL.ID,WTT.ID,R.REDO.STORE.SPOOL.ID)
    END

    CALL APAP.REDOVER.redoVAutRteReprint(Y.HID) ;*MANUAL R22 CODE CONVERSION
    PRT.ADVICED.PRODUCED = ""

RETURN

END
