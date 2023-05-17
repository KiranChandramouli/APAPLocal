*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE MB.E.SDB.GET.PAID.DATE

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON

    START.POS = INDEX(O.DATA,'FT',1)
    JUL.DATE = '20':O.DATA[START.POS+2,5]

    GREG.DATE = ''
    CALL JULDATE(GREG.DATE,JUL.DATE)
    O.DATA = GREG.DATE

    RETURN

END
