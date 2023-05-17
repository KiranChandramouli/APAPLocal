SUBROUTINE AI.REDO.GET.CNT.CARDS
*---------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON

    CNT.CARDS = DCOUNT(O.DATA,@VM)
    O.DATA = CNT.CARDS

RETURN
END
