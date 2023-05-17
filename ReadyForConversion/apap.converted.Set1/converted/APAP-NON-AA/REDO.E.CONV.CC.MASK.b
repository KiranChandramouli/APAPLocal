SUBROUTINE REDO.E.CONV.CC.MASK
*-----------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :S PRADEEP
*Program   Name    :REDO.E.CONV.CC.MASK
*-----------------------------------------------------------------------------------

*DESCRIPTION       :This Program is used for convert | TO *
*LINKED WITH       :REDO.NOF.GEN.CHQ.AGENCY
* -----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON

    Y.VAR = O.DATA
    CHANGE "|" TO "*" IN Y.VAR
    O.DATA=Y.VAR

RETURN
END
