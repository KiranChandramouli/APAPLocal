*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE LAPAP.PURGAL.OFSREQUESTD(PURGA.ID)
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT TAM.BP I_F.REDO.H.CUSTOMER.PROVISIONING
    $INSERT LAPAP.BP I_LAPAP.PURGAL.OFSREQUESTD.COMMON
    $INSERT T24.BP I_F.OFS.REQUEST.DETAIL

    CALL F.DELETE(FN.REQ.PURGA,PURGA.ID)

END
