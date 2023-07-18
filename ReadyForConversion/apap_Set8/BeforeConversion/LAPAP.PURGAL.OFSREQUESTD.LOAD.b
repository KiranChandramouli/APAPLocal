*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE LAPAP.PURGAL.OFSREQUESTD.LOAD
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT LAPAP.BP I_LAPAP.PURGAL.OFSREQUESTD.COMMON
    $INSERT T24.BP I_F.OFS.REQUEST.DETAIL
    $INSERT T24.BP  I_F.DATES

    FN.REQ.PURGA = "F.OFS.REQUEST.DETAIL"
    F.REQ.PURGA = ""
    CALL OPF(FN.REQ.PURGA,F.REQ.PURGA)

    Y.LAST.DAY = R.DATES(EB.DAT.JULIAN.DATE)[3,5]

END
