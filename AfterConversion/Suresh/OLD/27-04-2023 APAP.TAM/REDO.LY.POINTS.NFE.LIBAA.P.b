* @ValidationCode : MjoxNzg1NTExNjI1OkNwMTI1MjoxNjgxMjA5NDQxMzUwOjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 11 Apr 2023 16:07:21
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.LY.POINTS.NFE.LIBAA.P(ENQ.DATA)
*-------------------------------------------------------------------------------------------
*DESCRIPTION:
* This subroutine is performed during enquiry called REDO.LY.POINTS.E.LIB.P (nofile enquiry)
* The functionality is to get the points generated and available for program per customer
* ------------------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : ENQ.DATA
*
* Dependencies:
*---------------
* CALLS     : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date             who           Reference            Description
* 05-MAY-2014     RMONDRAGON    ODR-2009-12-0276      Initial Creation
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*11/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION          VM TO @VM, SM TO @SM,++ TO +=
*11/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.LY.POINTS
    $INSERT I_F.REDO.LY.PROGRAM
    $INSERT I_ENQUIRY.COMMON

*----
MAIN:
*----

    GOSUB OPENFILES
    GOSUB PROCESS

RETURN

*---------
OPENFILES:
*---------

    FN.REDO.LY.POINTS = 'F.REDO.LY.POINTS'
    F.REDO.LY.POINTS = ''
    CALL OPF(FN.REDO.LY.POINTS,F.REDO.LY.POINTS)

    FN.REDO.LY.PROGRAM = 'F.REDO.LY.PROGRAM'
    F.REDO.LY.PROGRAM = ''
    CALL OPF(FN.REDO.LY.PROGRAM,F.REDO.LY.PROGRAM)

RETURN

*-------
PROCESS:
*-------

    LOCATE 'PROGRAM.ID' IN D.FIELDS SETTING POS THEN
        Y.PRGM.ID = D.RANGE.AND.VALUE<POS>
    END

    LOCATE 'CUSTOMER.NO' IN D.FIELDS SETTING POS2 THEN
        Y.PTS.ID = D.RANGE.AND.VALUE<POS2>
    END

    LOCATE 'DATES.RANGE' IN D.FIELDS SETTING POS3 THEN
        Y.DATES.RANGE = D.RANGE.AND.VALUE<POS3>
        Y.DATE.START = FIELD(Y.DATES.RANGE,@SM,1)
        Y.DATE.END = FIELD(Y.DATES.RANGE,@SM,2)
    END

    IF Y.PRGM.ID THEN
        GOSUB GET.PROG.NAME
        IF Y.AIR.PRG EQ 'NO' THEN
            RETURN
        END
        GOSUB GET.INFO
    END

RETURN

*-------------
GET.PROG.NAME:
*-------------

    R.PROGRAM = ''; PROG.ERR = ''
    CALL F.READ(FN.REDO.LY.PROGRAM,Y.PRGM.ID,R.PROGRAM,F.REDO.LY.PROGRAM,PROG.ERR)
    IF R.PROGRAM THEN
        Y.PROG.NAME = R.PROGRAM<REDO.PROG.NAME>
        Y.AIR.PRG = R.PROGRAM<REDO.PROG.AIRL.PROG>
    END

RETURN

*--------
GET.INFO:
*--------

    CALL F.READ(FN.REDO.LY.POINTS,Y.PTS.ID,R.REC.POINTS,F.REDO.LY.POINTS,PTS.ERR.R)
    IF R.REC.POINTS THEN
        Y.PROGRAM.ID=R.REC.POINTS<REDO.PT.PROGRAM>
        VAR.PRODUCT=R.REC.POINTS<REDO.PT.PRODUCT>
        VAR.POINTS=R.REC.POINTS<REDO.PT.QUANTITY>
        VAR.PT.VALUE=R.REC.POINTS<REDO.PT.QTY.VALUE>
        VAR.GEN.DATE=R.REC.POINTS<REDO.PT.GEN.DATE>
        VAR.AV.DATE=R.REC.POINTS<REDO.PT.AVAIL.DATE>
        VAR.DUE.DATE=R.REC.POINTS<REDO.PT.EXP.DATE>
        VAR.STATUS=R.REC.POINTS<REDO.PT.STATUS>
        GOSUB GET.INFO2
    END

RETURN

*---------
GET.INFO2:
*---------

    Y.TOT.PROD = DCOUNT(VAR.PRODUCT,@VM)
    Y.CNTPROD = 1

    LOOP
    WHILE Y.CNTPROD LE Y.TOT.PROD
        Y.PROD = FIELD(VAR.PRODUCT,@VM,Y.CNTPROD)
        Y.PROG.PROD = FIELD(Y.PROGRAM.ID,@VM,Y.CNTPROD)
        Y.PTS.PROD = FIELD(VAR.POINTS,@VM,Y.CNTPROD)
        Y.PT.VALUE.PROD = FIELD(VAR.PT.VALUE,@VM,Y.CNTPROD)
        Y.GEN.DATE.PROD = FIELD(VAR.GEN.DATE,@VM,Y.CNTPROD)
        Y.AV.DATE.PROD = FIELD(VAR.AV.DATE,@VM,Y.CNTPROD)
        Y.DUE.DATE.PROD = FIELD(VAR.DUE.DATE,@VM,Y.CNTPROD)
        Y.STATUS.PROD = FIELD(VAR.STATUS,@VM,Y.CNTPROD)
        GOSUB GET.INFO3
        Y.CNTPROD += 1 ;*AUTO R22 CODE CONVERSION

    REPEAT

RETURN

*---------
GET.INFO3:
*---------

    Y.TOT.PRG.PROD = DCOUNT(Y.PROG.PROD,@SM)
    POS1 = 1

    LOOP
    WHILE POS1 LE Y.TOT.PRG.PROD
        Y.PROC = 'N'
        Y.FIRST.LINE = 'N'
        Y.PROG = FIELD(Y.PROG.PROD,@SM,POS1)
        Y.STAT = FIELD(Y.STATUS.PROD,@SM,POS1)
        Y.GEN.DATE = FIELD(Y.GEN.DATE.PROD,@SM,POS1)
        Y.PT = FIELD(Y.PTS.PROD,@SM,POS1)
        Y.PT.VAL = FIELD(Y.PT.VALUE.PROD,@SM,POS1)
        Y.AV.DATE = FIELD(Y.AV.DATE.PROD,@SM,POS1)
        Y.DUE.DATE = FIELD(Y.DUE.DATE.PROD,@SM,POS1)
        GOSUB CHECK.STAT
        IF Y.DATE.START AND Y.DATE.END THEN
            IF (Y.PROG EQ Y.PRGM.ID) AND (Y.GEN.DATE GE Y.DATE.START AND Y.GEN.DATE LE Y.DATE.END) THEN
                Y.PROC = 'Y'
            END
        END ELSE
            IF Y.PROG EQ Y.PRGM.ID THEN
                Y.PROC = 'Y'
            END
        END
        IF Y.PROC EQ 'Y' THEN
            Y.REC.COM = Y.PTS.ID:'*':Y.PROG.NAME:'*':Y.PROD:'*':Y.PT:'*':Y.PT.VAL:'*':Y.AV.DATE:'*':Y.DUE.DATE:'*':Y.STAT:'*':Y.US.DATE
            ENQ.DATA<-1> = Y.REC.COM
        END
        POS1 += 1 ;*AUTO R22 CODE CONVERSION

    REPEAT

RETURN

*----------
CHECK.STAT:
*----------

    Y.US.DATE = ''

    Y.CHECK.REC = FIELD(Y.STAT,'.',1)
    IF Y.CHECK.REC EQ 'Sometida' THEN
        Y.US.DATE = FIELD(Y.STAT,'.',2)
        Y.STAT = 'Sometida'
    END

RETURN

END
