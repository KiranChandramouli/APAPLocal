SUBROUTINE REDO.E.CONV.DATE
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON

    Y.DATE = O.DATA

    IF Y.DATE[1,1] EQ "D" THEN
        Y.DATE1 = FIELD(Y.DATE,' ',2)
        Y.DATE1 = Y.DATE1[1,6]
        Y.VAR1  = ICONV(Y.DATE1,"D")
        Y.DD1   = FMT(OCONV(Y.VAR1,"DD"),"R%2")
        Y.MM1   = FMT(OCONV(Y.VAR1,"DM"),"R%2")
        Y.YYYY1 = OCONV(Y.VAR1,"DY4")
        Y.DATE  = Y.YYYY1:Y.MM1:Y.DD1
    END

    IF Y.DATE NE "" THEN
        Y.VAL1 = Y.DATE[1,4]
        Y.VAL2 = Y.DATE[5,2]
        Y.VAL3 = Y.DATE[7,2]

        O.DATA = Y.VAL3:"/":Y.VAL2:"/":Y.VAL1
    END

RETURN
