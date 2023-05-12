* @ValidationCode : MjoyMDg5ODc1NjY4OkNwMTI1MjoxNjgyNTI4NDY0MDA2OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 26 Apr 2023 22:31:04
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
SUBROUTINE REDO.LY.V.PROGFORA
**
* Subroutine Type : VERSION
* Attached to     : REDO.LY.PROGAERO,NEW
* Attached as     : INPUT.ROUTINE
* Primary Purpose : Validate if program selected is marked as "Airline Program".
*-----------------------------------------------------------------------------
* MODIFICATIONS HISTORY
*
* 3/12/13 - First Version
*           ODR Reference: ODR-2011-06-0243
*           Project: NCD Asociacion Popular de Ahorros y Prestamos (APAP)
*           Roberto Mondragon - TAM Latin America
*           rmondragon@temenos.com
*-----------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*11/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION           VM TO @VM, ++ TO +=
*11/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-----------------------------------------------------------------------------------
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE

    $INSERT I_F.REDO.LY.PROGRAM
    $INSERT I_F.REDO.LY.PROGAERO

    GOSUB OPEN.FILES
    Y.PROGRAM = R.NEW(REDO.PA.PROGRAM.ID)
    GOSUB PROCESS

RETURN

***********
OPEN.FILES:
***********

    FN.REDO.LY.PROGRAM = 'F.REDO.LY.PROGRAM'
    F.REDO.LY.PROGRAM = ''
    CALL OPF(FN.REDO.LY.PROGRAM,F.REDO.LY.PROGRAM)

RETURN

********
PROCESS:
********

    Y.TOT.PROGRAMS = DCOUNT(Y.PROGRAM,@VM)

    CNT.PROG = 1
    LOOP
    WHILE CNT.PROG LE Y.TOT.PROGRAMS
        Y.PROGRAM.ID = FIELD(Y.PROGRAM,@VM,CNT.PROG)
        R.PROG = ''; PROG.ERR = ''
        CALL F.READ(FN.REDO.LY.PROGRAM,Y.PROGRAM.ID,R.PROG,F.REDO.LY.PROGRAM,PROG.ERR)
        IF R.PROG THEN
            Y.PROG.AIRLINE = R.PROG<REDO.PROG.AIRL.PROG>
        END

        GOSUB VAL.PROG

        CNT.PROG += 1 ;*AUTO R22 CODE CONVERSION
    REPEAT

RETURN

*********
VAL.PROG:
*********

    IF Y.PROG.AIRLINE EQ 'NO' THEN
        AF = REDO.PA.PROGRAM.ID
        AV = CNT.PROG
        ETEXT = 'EB-REDO.LY.V.PROGFORA'
        CALL STORE.END.ERROR
        CNT.PROG = Y.TOT.PROGRAMS + 1
        RETURN
    END

    CNT.DUP = 1
    LOOP
    WHILE CNT.DUP LE Y.TOT.PROGRAMS
        Y.PROGRAM.DUP = FIELD(Y.PROGRAM,@VM,CNT.DUP)
        IF (CNT.PROG NE CNT.DUP) AND (Y.PROGRAM.ID EQ Y.PROGRAM.DUP) THEN
            AF = REDO.PA.PROGRAM.ID
            AV = CNT.DUP
            ETEXT = 'EB-REDO.LY.V.PROGFORA2'
            CALL STORE.END.ERROR
            CNT.DUP = Y.TOT.PROGRAMS + 1
            CNT.PROG = Y.TOT.PROGRAMS + 1
        END
        CNT.DUP += 1 ;*AUTO R22 CODE CONVERSION
    REPEAT

RETURN

END
