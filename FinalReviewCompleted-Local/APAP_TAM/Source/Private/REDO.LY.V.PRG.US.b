* @ValidationCode : Mjo5ODkxNjcxMDM6Q3AxMjUyOjE2ODEzNzYwOTgwODk6SVRTUzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
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
SUBROUTINE  REDO.LY.V.PRG.US
*----------------------------------------------------------------------------------------------------
*DESCRIPTION : This routine is used to validate the parameters of use accounting movements in the
*              program used.
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : RMONDRAGON
* PROGRAM NAME : REDO.LY.V.PRG.US
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                REFERENCE         DESCRIPTION
*16.06.2012    RMONDRAGON         ODR-2011-06-0243     FIRST VERSION
*13.04.2023    Conversion Tool       R22               Auto Conversion     - No changes
*13.04.2023    Shanmugapriya M       R22               Manual Conversion   - No changes
*
* -----------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.LY.PROGRAM
    $INSERT I_F.REDO.LY.POINTS.US
    $INSERT I_GTS.COMMON

    Y.US.PROGRAM = COMI

    IF Y.US.PROGRAM EQ '' THEN
        RETURN
    END

    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN

*----------
OPEN.FILES:
*----------

    FN.REDO.LY.PROGRAM = 'F.REDO.LY.PROGRAM'
    F.REDO.LY.PROGRAM = ''
    CALL OPF(FN.REDO.LY.PROGRAM,F.REDO.LY.PROGRAM)

RETURN

*-------
PROCESS:
*-------

    Y.NO.PROCEED = 'N'

    Y.TXN.TYPE = ''; Y.ACCT.DR = ''; Y.ACCT.CR = ''; Y.PT.USE = ''
    R.REDO.LY.PROGRAM = '' ; PRG.ERR = ''
    CALL F.READ(FN.REDO.LY.PROGRAM,Y.US.PROGRAM,R.REDO.LY.PROGRAM,F.REDO.LY.PROGRAM,PRG.ERR)
    IF R.REDO.LY.PROGRAM THEN
        Y.AIR.TYPE = R.REDO.LY.PROGRAM<REDO.PROG.AIRL.PROG>
        Y.TXN.TYPE = R.REDO.LY.PROGRAM<REDO.PROG.TXN.TYPE.US>
        Y.ACCT.DR = R.REDO.LY.PROGRAM<REDO.PROG.DR.ACCT.US>
        Y.ACCT.CR = R.REDO.LY.PROGRAM<REDO.PROG.CR.ACCT.US>
        Y.PT.USE = R.REDO.LY.PROGRAM<REDO.PROG.POINT.USE>
    END

    IF Y.AIR.TYPE EQ 'SI' THEN
        AF = REDO.PT.US.PROGRAM
        ETEXT = 'EB-REDO.LY.V.PRG.US'
        CALL STORE.END.ERROR
        RETURN
    END

    IF Y.PT.USE EQ 3 OR Y.PT.USE EQ 4 THEN
        Y.NO.PROCEED = 'Y'
    END

    IF PGM.VERSION EQ ',CREATE.MAN' AND Y.NO.PROCEED EQ 'Y' THEN
        AF = REDO.PT.US.PROGRAM
        ETEXT = 'EB-REDO.LY.V.PRG.US2'
        CALL STORE.END.ERROR
        RETURN
    END

    IF PGM.VERSION EQ ',CREATE.REP' AND Y.PT.USE EQ 4 THEN
        AF = REDO.PT.US.PROGRAM
        ETEXT = 'EB-REDO.LY.V.PRG.US3'
        CALL STORE.END.ERROR
        RETURN
    END

    IF PGM.VERSION EQ ',CREATE.REPC' AND Y.PT.USE EQ 3 THEN
        AF = REDO.PT.US.PROGRAM
        ETEXT = 'EB-REDO.LY.V.PRG.US3'
        CALL STORE.END.ERROR
        RETURN
    END

    IF PGM.VERSION EQ ',CREATE.IB' AND Y.PT.USE EQ 3 THEN
        AF = REDO.PT.US.PROGRAM
        ETEXT = 'EB-REDO.LY.V.PRG.US'
        CALL STORE.END.ERROR
        RETURN
    END

    IF Y.TXN.TYPE EQ '' OR Y.ACCT.DR EQ '' OR Y.ACCT.CR EQ '' THEN
        AF = REDO.PT.US.PROGRAM
        ETEXT = 'EB-REDO.LY.V.TXNTOSAVC3'
        CALL STORE.END.ERROR
        RETURN
    END

RETURN

*----------------------------------------------------------------------------------
END
