$PACKAGE APAP.LAPAP
SUBROUTINE DR.REGN16.GET.CLAIM.STATUS
*-------------------------------------------------------------------------------------
*Modification
* Date                  who                   Reference              
* 21-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION -$INSERT T24.BP TO $INSERT AND $INSERT TAM.BP TO $INSERT AND FM TO @FM
* 21-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.ISSUE.CLAIMS

    STATUS.VAL = COMI
    CLAIM.STATUS = ''
    STATUS.1 = "DOCUMENT.PENDING":@FM:"IN-PROCESS":@FM:"OPEN"
    STATUS.2 = "CLOSED":@FM:"RESOLVED":@FM:"RESOLVED-NOTIFIED"
    PR.POS = ''
    LOCATE STATUS.VAL IN STATUS.1 SETTING PR.POS THEN
        CLAIM.STATUS = 'PR'
    END ELSE
        TR.POS = ''
        LOCATE STATUS.VAL IN STATUS.2 SETTING TR.POS THEN
            CLAIM.STATUS = 'TR'
        END
    END
    COMI = CLAIM.STATUS
RETURN
END
