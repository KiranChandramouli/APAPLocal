SUBROUTINE LAPAP.PURGAL.OFSREQUESTD.LOAD
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_LAPAP.PURGAL.OFSREQUESTD.COMMON
    $INSERT I_F.OFS.REQUEST.DETAIL
    $INSERT I_F.DATES

    FN.REQ.PURGA = "F.OFS.REQUEST.DETAIL"
    F.REQ.PURGA = ""
    CALL OPF(FN.REQ.PURGA,F.REQ.PURGA)

    Y.LAST.DAY = R.DATES(EB.DAT.JULIAN.DATE)[3,5]

END
