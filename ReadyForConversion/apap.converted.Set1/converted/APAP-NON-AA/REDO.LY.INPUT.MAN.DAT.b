SUBROUTINE REDO.LY.INPUT.MAN.DAT
*-----------------------------------------------------------------------------
*DESCRIPTION: This subroutine is performed in REDO.LY.POINTS,REC.MAN version as input routine
* The functionality is to populate the fields MAN.DATE and MAN.USER automatically when maintenance
* task is inputted
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
* 30-OCT-2010        Ganesh H        ODR-2009-12-0276     Initial Creation
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
    Y.MAN.QTY.NEW=R.NEW(REDO.PT.MAN.QTY)
    Y.MAN.STATUS.NEW=R.NEW(REDO.PT.MAN.STATUS)
    Y.MAN.QTY.OLD=R.OLD(REDO.PT.MAN.QTY)
    Y.MAN.STATUS.OLD=R.OLD(REDO.PT.MAN.STATUS)
    Y.PROGRAM=R.NEW(REDO.PT.PROGRAM)
    Y.MULTI.CNT=DCOUNT(Y.PROGRAM,@VM)
    VAR1=1
    LOOP
    WHILE VAR1 LE Y.MULTI.CNT
        Y.SUB.PROGRAM=Y.PROGRAM<1,VAR1>
        Y.SUB.PRGM.CNT=DCOUNT(Y.SUB.PROGRAM,@SM)
        VAR2=1
        LOOP
        WHILE VAR2 LE Y.SUB.PRGM.CNT
            IF Y.MAN.QTY.NEW<1,VAR1,VAR2> NE Y.MAN.QTY.OLD<1,VAR1,VAR2> OR Y.MAN.STATUS.NEW<1,VAR1,VAR2> NE Y.MAN.STATUS.OLD<1,VAR1,VAR2> THEN
                R.NEW(REDO.PT.MAN.DATE)<1,VAR1,VAR2>=TODAY
                R.NEW(REDO.PT.MAN.USER)<1,VAR1,VAR2>=OPERATOR
            END
            VAR2 += 1
        REPEAT
        VAR1 += 1
    REPEAT
RETURN
END
