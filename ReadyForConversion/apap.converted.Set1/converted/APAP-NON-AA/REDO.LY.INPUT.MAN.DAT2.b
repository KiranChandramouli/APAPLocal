SUBROUTINE REDO.LY.INPUT.MAN.DAT2
*-----------------------------------------------------------------------------
*DESCRIPTION: This subroutine is performed in REDO.LY.POINTS,REC.MAN2 version as input routine
* The functionality is to populate the fields QUANTITY, QTY.VALUE, STATUS,MAN.DATE and MAN.USER
* automatically when maintenance task is inputted
* Input/Output:
*--------------
* IN : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : @ID
* CALLED BY :
*
* Revision History:
*------------------------------------------------------------------------------------------
*   Date               who           Reference            Description
* 15-DEC-2011       RMONDRAGON       ODR-2011-06-0243     Initial Version
*------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.LY.POINTS

    GOSUB PROCESS

RETURN

*------------------------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------------------------
* This part assign the man.date and man.user for the manually changed sub value field

    Y.QTY.OLD=R.OLD(REDO.PT.QUANTITY)
    Y.QTY.VALUE.OLD=R.OLD(REDO.PT.QTY.VALUE)
    Y.MAN.STATUS.NEW=R.NEW(REDO.PT.MAN.STATUS)
    Y.MAN.STATUS.OLD=R.OLD(REDO.PT.MAN.STATUS)
    Y.PRODUCT=R.NEW(REDO.PT.PRODUCT)
    Y.PRD.CNT=DCOUNT(Y.PRODUCT,@VM)
    Y.PROGRAM=R.NEW(REDO.PT.PROGRAM)
    Y.MULTI.CNT=DCOUNT(Y.PROGRAM,@VM)
    VAR0=1
    LOOP
    WHILE VAR0 LE Y.PRD.CNT
        VAR1=1
        LOOP
        WHILE VAR1 LE Y.MULTI.CNT
            Y.SUB.PROGRAM=Y.PROGRAM<VAR0,VAR1>
            Y.SUB.PRGM.CNT=DCOUNT(Y.SUB.PROGRAM,@SM)
            VAR2=1
            LOOP
            WHILE VAR2 LE Y.SUB.PRGM.CNT
                IF Y.MAN.STATUS.NEW<VAR0,VAR1,VAR2> NE Y.MAN.STATUS.OLD<VAR0,VAR1,VAR2> AND Y.QTY.OLD<VAR0,VAR1,VAR2> EQ '' AND Y.QTY.VALUE.OLD<VAR0,VAR1,VAR2> EQ '' THEN
                    R.NEW(REDO.PT.STATUS)<VAR0,VAR1,VAR2>='No.Liberada'
                    R.NEW(REDO.PT.MAN.QTY)<VAR0,VAR1,VAR2>=R.NEW(REDO.PT.QUANTITY)<VAR0,VAR1,VAR2>
                    R.NEW(REDO.PT.MAN.QTY.VALUE)<VAR0,VAR1,VAR2>=R.NEW(REDO.PT.QTY.VALUE)<VAR0,VAR1,VAR2>
                    R.NEW(REDO.PT.MAN.DATE)<VAR0,VAR1,VAR2>=TODAY
                    R.NEW(REDO.PT.MAN.USER)<VAR0,VAR1,VAR2>=OPERATOR
                END
                VAR2 += 1
            REPEAT
            VAR1 += 1
        REPEAT
        VAR0 += 1
    REPEAT

RETURN

END
