SUBROUTINE REDO.DEAL.ADDR.FMT(Y.ADDRESS)
*---------------------------------------------
*Description: This routine is to format the address in deal slip
*---------------------------------------------
* Input  Arg   := COMI
* Output Arg   := COMI
* Linked With  := DEAL.SLIP.FORMAT>REDO.CHEQUE.ISS
*---------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE


    GOSUB PROCESS
RETURN
*---------------------------------------------
PROCESS:
*---------------------------------------------

    Y.NO.OF.LINES.ADDR = DCOUNT(Y.ADDRESS,@VM)
    Y.VAR1 = 1
    LOOP
    WHILE Y.VAR1 LE Y.NO.OF.LINES.ADDR
        Y.ADDRESS<Y.VAR1> = "     ":Y.ADDRESS<Y.VAR1>
        Y.VAR1 += 1
    REPEAT

RETURN
END
