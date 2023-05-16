$PACKAGE APAP.LAPAP
SUBROUTINE DR.REGN16.CLAIMS.ID.FORMAT
*-------------------------------------------------------------------------------------
*Modification
* Date                  who                   Reference              
* 21-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION -$INSERT T24.BP TO $INSERT 
* 21-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-------------------------------------------------------------------------------------

*routine resent for the issue PACS00305494

    $INSERT I_COMMON
    $INSERT I_EQUATE

    CLAIM.ID = COMI
    CHANGE '-' TO '' IN CLAIM.ID
    COMI = CLAIM.ID
RETURN
END
