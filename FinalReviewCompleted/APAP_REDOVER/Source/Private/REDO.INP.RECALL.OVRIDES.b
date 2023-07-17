* @ValidationCode : MjozODI3MDI2MTI6Q3AxMjUyOjE2ODI2OTE0OTU1ODQ6SVRTUzotMTotMTotMjQ6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 28 Apr 2023 19:48:15
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -24
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.INP.RECALL.OVRIDES
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
*       DATE             WHO                REFERENCE                      DESCRIPTION
*06-04-2023           Conversion Tool       R22 Auto Code conversion      FM TO @FM,VM TO @VM ,SM TO @SM, ++ TO +=1
*06-04-2023            Samaran T            Manual R22 Code Conversion    CALL routine format modified
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
    Y.FINAL.OVR = ''

    BEGIN CASE
        CASE APPLICATION EQ "FOREX"
            GOSUB FX.OVRIDES.PARA
        CASE APPLICATION EQ "MM.MONEY.MARKET"
            GOSUB MM.OVRIDES.PARA
        CASE APPLICATION EQ "SEC.TRADE"
            GOSUB SC.OVRIDES.PARA
    END CASE
RETURN
********************
FX.OVRIDES.PARA:
********************

    Y.FX.OVERRIDE.DET = R.NEW(FX.LOCAL.REF)<1,Y.FX.LIMIT.OVR.POS>
    Y.TOT.OVR = DCOUNT(Y.FX.OVERRIDE.DET,@SM)
    Y.CNT = 1
    LOOP
    WHILE Y.CNT LE Y.TOT.OVR
        Y.LAST.OVR =  R.NEW(FX.LOCAL.REF)<1,Y.FX.LIMIT.OVR.POS,Y.TOT.OVR>
        IF OFS$OPERATION EQ 'PROCESS' AND V$FUNCTION EQ 'I' THEN
            CURR.NO = DCOUNT(R.NEW(FX.OVERRIDE),@VM) + 1
            TEXT = R.NEW(FX.LOCAL.REF)<1,Y.FX.LIMIT.OVR.POS,Y.CNT>
            CALL STORE.OVERRIDE(CURR.NO)
        END
        Y.CNT += 1
    REPEAT

    Y.APP.OVERRIDES  = R.NEW(FX.OVERRIDE)
    IF Y.APP.OVERRIDES THEN
        APAP.REDOAPAP.redoApiIdentifyClass(Y.APP.OVERRIDES,Y.CR.FLAG,Y.TR.FLAG) ;*Manual R22 Code Conversion
    END
    IF Y.CR.FLAG THEN
        R.NEW(FX.LOCAL.REF)<1,Y.FX.CR.USER.POS> = 'O1'
    END
    IF Y.TR.FLAG THEN
        R.NEW(FX.LOCAL.REF)<1,Y.FX.TR.USER.POS> = 'O2'
    END

RETURN
********************
MM.OVRIDES.PARA:
********************
    Y.MM.OVERRIDE.DET = R.NEW(MM.LOCAL.REF)<1,Y.MM.LIMIT.OVR.POS>
    Y.TOT.OVR = DCOUNT(Y.MM.OVERRIDE.DET,@SM)
    Y.CNT = 1
    LOOP
    WHILE Y.CNT LE Y.TOT.OVR
        Y.LAST.OVR = R.NEW(MM.LOCAL.REF)<1,Y.MM.LIMIT.OVR.POS,Y.TOT.OVR>
        IF OFS$OPERATION EQ 'PROCESS' AND V$FUNCTION EQ 'I' THEN
            CURR.NO = DCOUNT(R.NEW(MM.OVERRIDE),@VM) + 1
            TEXT = R.NEW(MM.LOCAL.REF)<1,Y.MM.LIMIT.OVR.POS,Y.CNT>
            CALL STORE.OVERRIDE(CURR.NO)
        END
        Y.CNT += 1
    REPEAT
    Y.APP.OVERRIDES  = R.NEW(MM.OVERRIDE)
    IF Y.APP.OVERRIDES THEN
        APAP.REDOAPAP.redoApiIdentifyClass(Y.APP.OVERRIDES,Y.CR.FLAG,Y.TR.FLAG) ;*Manual R22 Code Conversion
    END
    IF Y.CR.FLAG THEN
        R.NEW(MM.LOCAL.REF)<1,Y.MM.CR.USER.POS> = 'O1'
    END
    IF Y.TR.FLAG THEN
        R.NEW(MM.LOCAL.REF)<1,Y.MM.TR.USER.POS> = 'O2'
    END

RETURN
********************
SC.OVRIDES.PARA:
********************
    Y.SC.OVERRIDE.DET = R.NEW(SC.SBS.LOCAL.REF)<1,Y.SC.LIMIT.OVR.POS>
    Y.TOT.OVR = DCOUNT(Y.SC.OVERRIDE.DET,@SM)
    Y.CNT = 1
    LOOP
    WHILE Y.CNT LE Y.TOT.OVR
        Y.LAST.OVR=R.NEW(SC.SBS.LOCAL.REF)<1,Y.SC.LIMIT.OVR.POS,Y.TOT.OVR>
        IF OFS$OPERATION EQ 'PROCESS' AND V$FUNCTION EQ 'I' THEN
            CURR.NO = DCOUNT(R.NEW(SC.SBS.OVERRIDE),@VM) + 1
            TEXT = R.NEW(SC.SBS.LOCAL.REF)<1,Y.SC.LIMIT.OVR.POS,Y.CNT>
            CALL STORE.OVERRIDE(CURR.NO)
        END
        Y.CNT += 1
    REPEAT

    Y.APP.OVERRIDES = R.NEW(SC.SBS.OVERRIDE)
    IF Y.APP.OVERRIDES THEN
        APAP.REDOAPAP.redoApiIdentifyClass(Y.APP.OVERRIDES,Y.CR.FLAG,Y.TR.FLAG) ;*Manual R22 Code Conversion
    END
    IF Y.CR.FLAG THEN
        R.NEW(SC.SBS.LOCAL.REF)<1,Y.SC.CR.USER.POS> = 'O1'
    END
    IF Y.TR.FLAG THEN
        R.NEW(SC.SBS.LOCAL.REF)<1,Y.SC.TR.USER.POS> = 'O2'
    END

RETURN
END
