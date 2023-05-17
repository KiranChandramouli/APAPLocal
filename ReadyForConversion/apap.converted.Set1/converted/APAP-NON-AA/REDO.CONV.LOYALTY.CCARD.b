SUBROUTINE REDO.CONV.LOYALTY.CCARD
*---------------------------------------------------
*Description: This is conversion routine to decide on the Version's.
*---------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON

    GOSUB PROCESS
RETURN
*---------------------------------------------------
PROCESS:
*---------------------------------------------------


    IF NUM(O.DATA[1,4]) ELSE
        O.DATA = 'TOTALES'
    END

RETURN
END
