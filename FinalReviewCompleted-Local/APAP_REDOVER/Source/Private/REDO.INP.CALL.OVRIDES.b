* @ValidationCode : MjoxNTU3OTk5MjUyOkNwMTI1MjoxNjgyNjkxNDk0MTIxOklUU1M6LTE6LTE6LTI4OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 28 Apr 2023 19:48:14
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -28
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.INP.CALL.OVRIDES
*-----------------------------------------------------------------------------
*------------------------------------------------------------------------------------------
* DESCRIPTION :   This routine will be executed at check Record Routine for TELLER VERSIONS
*------------------------------------------------------------------------------------------
*
* COMPANY NAME : APAP
* DEVELOPED BY : VICTOR NAVA
* PROGRAM NAME : REDO.V.CHK.FX.OVR
*
*------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE            WHO                REFERENCE                         DESCRIPTION
*04-04-2023     Conversion Tool     R22 Auto Code conversion      FM TO @FM,VM TO @VM ,SM TO @SM, ++ TO +=1
*05-04-2023       Samaran T         Manual R22 Code Conversion       Call Routine Format Modified
* -----------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_System
    $INSERT I_REDO.FX.OVR.COMMON
*
    $INSERT I_F.FOREX
    $INSERT I_F.MM.MONEY.MARKET
    $INSERT I_F.SEC.TRADE
    $USING APAP.REDOAPAP


*
    LOC.REF.APPL="FOREX":@FM:"MM.MONEY.MARKET":@FM:"SEC.TRADE"
    LOC.REF.FIELDS="L.LIMIT.OVR":@VM:"L.CR.USER.APAP":@VM:"L.TR.USER.APAP":@FM:"L.LIMIT.OVR":@VM:"L.CR.USER.APAP":@VM:"L.TR.USER.APAP":@FM:"L.LIMIT.OVR":@VM:"L.CR.USER.APAP":@VM:"L.TR.USER.APAP"
    LOC.REF.POS=" "
    CALL MULTI.GET.LOC.REF(LOC.REF.APPL,LOC.REF.FIELDS,LOC.REF.POS)
    Y.FX.LIMIT.OVR.POS  = LOC.REF.POS<1,1>
    Y.FX.CR.USER.POS =  LOC.REF.POS<1,2>
    Y.FX.TR.USER.POS =  LOC.REF.POS<1,3>

    Y.MM.LIMIT.OVR.POS  = LOC.REF.POS<2,1>
    Y.MM.CR.USER.POS =  LOC.REF.POS<2,2>
    Y.MM.TR.USER.POS =  LOC.REF.POS<2,3>

    Y.SC.LIMIT.OVR.POS  = LOC.REF.POS<3,1>
    Y.SC.CR.USER.POS =  LOC.REF.POS<3,2>
    Y.SC.TR.USER.POS =  LOC.REF.POS<3,3>


    Y.OFS.OVERRIDES= OFS$OVERRIDES
    Y.APPLICATION = APPLICATION
    Y.FINAL.OVRD.LIST = ''

    BEGIN CASE
        CASE Y.APPLICATION EQ "FOREX"
            GOSUB FX.OVRIDES.PARA
        CASE Y.APPLICATION EQ "MM.MONEY.MARKET"
            GOSUB MM.OVRIDES.PARA
        CASE Y.APPLICATION EQ "SEC.TRADE"
            GOSUB SC.OVRIDES.PARA
    END CASE
*
RETURN
*****************
FX.OVRIDES.PARA:
*****************
    IF V$FUNCTION EQ 'I' THEN
        CURR.NO=DCOUNT(R.NEW(FX.OVERRIDE),@VM) + 1
        TEXT = "REDO.TRADE.DUP"
        CALL STORE.OVERRIDE(CURR.NO)
        Y.FX.OVERRIDE.DET<-1> = 'REDO.TRADE.DUP'
    END
    IF Y.OFS.OVERRIDES<2,1> NE 'YES' THEN
        Y.TOT.OVRDS = DCOUNT(Y.FX.OVERRIDE.DET,@FM)
        Y.OVRD.CNT = 1
        LOOP
        WHILE Y.OVRD.CNT LE Y.TOT.OVRDS
            LOCATE Y.FX.OVERRIDE.DET<Y.OVRD.CNT> IN Y.FINAL.OVRD.LIST<1> SETTING POS THEN
            END ELSE
                Y.FINAL.OVRD.LIST<-1> = Y.FX.OVERRIDE.DET<Y.OVRD.CNT>
            END
            Y.OVRD.CNT += 1  ;*R22 AUTO CODE CONVERSION
        REPEAT
        LOCATE '0' IN Y.FINAL.OVRD.LIST SETTING ZERO.POS THEN
            DEL Y.FINAL.OVRD.LIST<ZERO.POS>
        END
        CHANGE @FM TO @SM IN Y.FINAL.OVRD.LIST
        R.NEW(FX.LOCAL.REF)<1,Y.FX.LIMIT.OVR.POS>  = Y.FINAL.OVRD.LIST
    END

    Y.APP.OVERRIDES  = R.NEW(FX.OVERRIDE)
    IF Y.APP.OVERRIDES THEN
        CALL APAP.REDOAPAP.redoApiIdentifyClass(Y.APP.OVERRIDES,Y.CR.FLAG,Y.TR.FLAG) ;*Manual R22 Code Conversion
    END
    IF Y.CR.FLAG THEN
        R.NEW(FX.LOCAL.REF)<1,Y.FX.CR.USER.POS> = 'O1'
    END
    IF Y.TR.FLAG THEN
        R.NEW(FX.LOCAL.REF)<1,Y.FX.TR.USER.POS> = 'O2'
    END
RETURN
*****************
MM.OVRIDES.PARA:
*****************
    IF V$FUNCTION EQ 'I' THEN
        CURR.NO=DCOUNT(R.NEW(MM.OVERRIDE),@VM) + 1
        TEXT = "REDO.TRADE.DUP"
        CALL STORE.OVERRIDE(CURR.NO)
        Y.FX.OVERRIDE.DET<-1> = 'REDO.TRADE.DUP'
    END
    IF Y.OFS.OVERRIDES<2,1> NE 'YES' THEN

        Y.TOT.OVRDS = DCOUNT(Y.FX.OVERRIDE.DET,@FM)
        Y.OVRD.CNT = 1
        LOOP
        WHILE Y.OVRD.CNT LE Y.TOT.OVRDS
            LOCATE Y.FX.OVERRIDE.DET<Y.OVRD.CNT> IN Y.FINAL.OVRD.LIST<1> SETTING POS THEN
            END ELSE
                Y.FINAL.OVRD.LIST<-1> = Y.FX.OVERRIDE.DET<Y.OVRD.CNT>
            END
            Y.OVRD.CNT += 1 ;*R22 AUTO CODE CONVERSION
        REPEAT
        LOCATE '0' IN Y.FINAL.OVRD.LIST SETTING ZERO.POS THEN
            DEL Y.FINAL.OVRD.LIST<ZERO.POS>
        END
        CHANGE @FM TO @SM IN Y.FINAL.OVRD.LIST
        R.NEW(MM.LOCAL.REF)<1,Y.MM.LIMIT.OVR.POS> = Y.FINAL.OVRD.LIST
    END
    Y.APP.OVERRIDES = R.NEW(MM.OVERRIDE)
    IF Y.APP.OVERRIDES THEN
        CALL APAP.REDOAPAP.redoApiIdentifyClass(Y.APP.OVERRIDES,Y.CR.FLAG,Y.TR.FLAG)  ;*R22 MANUAL CODE CONVETRSION
    END
    IF Y.CR.FLAG THEN
        R.NEW(MM.LOCAL.REF)<1,Y.MM.CR.USER.POS> = 'O1'
    END
    IF Y.TR.FLAG THEN
        R.NEW(MM.LOCAL.REF)<1,Y.MM.TR.USER.POS> = 'O2'
    END
RETURN

*****************
SC.OVRIDES.PARA:
*****************
    IF V$FUNCTION EQ 'I' THEN
        CURR.NO=DCOUNT(R.NEW(SC.SBS.OVERRIDE),@VM) + 1
        TEXT = "REDO.TRADE.DUP"
        CALL STORE.OVERRIDE(CURR.NO)
        Y.FX.OVERRIDE.DET<-1> = 'REDO.TRADE.DUP'
    END
    IF Y.OFS.OVERRIDES<2,1> NE 'YES' THEN

        Y.TOT.OVRDS = DCOUNT(Y.FX.OVERRIDE.DET,@FM)
        Y.OVRD.CNT = 1
        LOOP
        WHILE Y.OVRD.CNT LE Y.TOT.OVRDS
            LOCATE Y.FX.OVERRIDE.DET<Y.OVRD.CNT> IN Y.FINAL.OVRD.LIST<1> SETTING POS THEN
            END    ELSE
                Y.FINAL.OVRD.LIST<-1> = Y.FX.OVERRIDE.DET<Y.OVRD.CNT>
            END
            Y.OVRD.CNT += 1  ;*R22 AUTO CODE CONVERSION
        REPEAT
        LOCATE '0' IN Y.FINAL.OVRD.LIST SETTING ZERO.POS THEN
            DEL Y.FINAL.OVRD.LIST<ZERO.POS>
        END
        CHANGE @FM TO @SM IN Y.FINAL.OVRD.LIST

        R.NEW(SC.SBS.LOCAL.REF)<1,Y.SC.LIMIT.OVR.POS> = Y.FINAL.OVRD.LIST
    END

    Y.APP.OVERRIDES = R.NEW(SC.SBS.OVERRIDE)
    IF Y.APP.OVERRIDES THEN
        CALL APAP.REDOAPAP.redoApiIdentifyClass(Y.APP.OVERRIDES,Y.CR.FLAG,Y.TR.FLAG) ;*R22 MANUAL CODE CONVETRSION
    END
    IF Y.CR.FLAG THEN
        R.NEW(SC.SBS.LOCAL.REF)<1,Y.SC.CR.USER.POS> = 'O1'
    END
    IF Y.TR.FLAG THEN
        R.NEW(SC.SBS.LOCAL.REF)<1,Y.SC.TR.USER.POS> = 'O2'
    END
RETURN
END
