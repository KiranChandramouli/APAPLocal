*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE MB.E.SDB.SORT(SDB.OUT, SDB.IN)

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON

    SDB.COMPANY = FIELD(SDB.IN, '.', 1,1)
    SDB.TYPE = FIELD(SDB.IN, '.', 2,1)
    SDB.NUMBER = FIELD(SDB.IN, '.', 3,1)
    SDB.NUMBER = FMT(SDB.NUMBER, "5'0'R")

    SDB.OUT = SDB.COMPANY:".":SDB.TYPE:".":SDB.NUMBER

    RETURN

END
