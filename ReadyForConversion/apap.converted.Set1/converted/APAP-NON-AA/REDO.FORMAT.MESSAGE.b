SUBROUTINE REDO.FORMAT.MESSAGE(Y.MESSAGE,Y.DATA.ORDER,Y.VALUES,Y.MESSAGE.FORMAT)
*----------------------------------------------------------------------
* Description : This routine is to format the message to left align.
* Input  Arg  : MESSAGE,LINE.LENGTH
* Output Arg  : MESSAGE.FORMAT
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------
*   Date            Who                   Reference               Description
* 27 Dec 2011   H Ganesh                PACS00170056 - B.16      Initial Draft
* ----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE

    GOSUB PROCESS

RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

    Y.MESSAGE.FORMAT = Y.MESSAGE
    Y.LOOP.CNT = DCOUNT(Y.DATA.ORDER,@VM)

    Y.LOOP = 1
    LOOP
    WHILE Y.LOOP LE Y.LOOP.CNT
        Y.DATA = Y.DATA.ORDER<1,Y.LOOP>
        GOSUB CHECK.VALUE
        Y.MESSAGE.FORMAT = EREPLACE (Y.MESSAGE.FORMAT,"&",Y.REPLACE.VAL,1,1)
        Y.LOOP += 1
    REPEAT

RETURN
*-----------------------------------------------------------------------------
CHECK.VALUE:
*-----------------------------------------------------------------------------

    BEGIN CASE
        CASE Y.DATA EQ 'DATE'
            Y.REPLACE.VAL = Y.VALUES<1>
        CASE Y.DATA EQ 'LOANNUMBER'
            Y.REPLACE.VAL = Y.VALUES<2>
        CASE Y.DATA EQ 'OLDRATE'
            Y.REPLACE.VAL = Y.VALUES<3>
        CASE Y.DATA EQ 'NEWRATE'
            Y.REPLACE.VAL = Y.VALUES<4>
        CASE Y.DATA EQ 'NEWAMOUNT'
            Y.REPLACE.VAL = Y.VALUES<5>
    END CASE
RETURN
END
