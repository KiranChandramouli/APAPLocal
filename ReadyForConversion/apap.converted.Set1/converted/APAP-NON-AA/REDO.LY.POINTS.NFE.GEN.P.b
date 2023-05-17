SUBROUTINE REDO.LY.POINTS.NFE.GEN.P(ENQ.DATA)
*-------------------------------------------------------------------------------------------
*DESCRIPTION:
* This subroutine is performed during enquiry called REDO.LY.POINTS.E.GEN.P (nofile enquiry)
* The functionality is to get the points generated for program per customer
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
* 14-NOV-2013     RMONDRAGON    ODR-2009-12-0276      Initial Creation
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

    LOCATE "PROGRAM.ID" IN D.FIELDS SETTING POS THEN
        Y.PRGM.ID = D.RANGE.AND.VALUE<POS>
    END
    IF Y.PRGM.ID THEN
        GOSUB GET.PROG.NAME
        GOSUB GET.DATA
        LOOP
            REMOVE Y.PTS.ID FROM SEL.LIST SETTING PTS.POS
        WHILE Y.PTS.ID:PTS.POS
            GOSUB GET.INFO
        REPEAT
    END

RETURN

*-------------
GET.PROG.NAME:
*-------------

    R.PROGRAM = ''; PROG.ERR = ''
    CALL F.READ(FN.REDO.LY.PROGRAM,Y.PRGM.ID,R.PROGRAM,F.REDO.LY.PROGRAM,PROG.ERR)
    IF R.PROGRAM THEN
        Y.PROG.NAME = R.PROGRAM<REDO.PROG.NAME>
    END

RETURN

*--------
GET.DATA:
*--------

    SEL.CMD = 'SELECT ':FN.REDO.LY.POINTS:' WITH PROGRAM EQ ':Y.PRGM.ID
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.RECS,PTS.ERR)

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
        VAR.AV.DATE=R.REC.POINTS<REDO.PT.AVAIL.DATE>
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
        Y.AV.DATE.PROD = FIELD(VAR.AV.DATE,@VM,Y.CNTPROD)
        Y.STATUS.PROD = FIELD(VAR.STATUS,@VM,Y.CNTPROD)
        GOSUB GET.INFO3
        Y.CNTPROD += 1
    REPEAT

RETURN

*---------
GET.INFO3:
*---------

    Y.TOT.PRG.PROD = DCOUNT(Y.PROG.PROD,@SM)
    POS1 = 1

    LOOP
    WHILE POS1 LE Y.TOT.PRG.PROD
        Y.PROG = FIELD(Y.PROG.PROD,@SM,POS1)
        Y.STAT = FIELD(Y.STATUS.PROD,@SM,POS1)
        IF (Y.PROG EQ Y.PRGM.ID) AND (Y.STAT EQ 'No.Liberada' OR Y.STAT EQ 'Pendiente.Someter') THEN
            Y.PT = FIELD(Y.PTS.PROD,@SM,POS1)
            Y.PT.VAL = FIELD(Y.PT.VALUE.PROD,@SM,POS1)
            Y.AV.DATE = FIELD(Y.AV.DATE.PROD,@SM,POS1)
            Y.REC.COM = Y.PROG.NAME:'*':Y.PTS.ID:'-':Y.PROD:'*':Y.PT:'*':Y.PT.VAL:'*':Y.AV.DATE:'*':Y.STAT
            ENQ.DATA<-1> = Y.REC.COM
        END
        POS1 += 1
    REPEAT

RETURN

END
