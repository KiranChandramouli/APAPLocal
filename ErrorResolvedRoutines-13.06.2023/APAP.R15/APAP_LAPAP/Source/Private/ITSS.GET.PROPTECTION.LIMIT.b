$PACKAGE APAP.LAPAP
SUBROUTINE ITSS.GET.PROPTECTION.LIMIT(Y.AA,Y.LIMIT)
*-------------------------------------------------------------------------------------
*Modification
* Date                  who                   Reference              
* 21-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION = TO EQ AND # TO NE
* 21-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.PROTECTION.LIMIT

    Y.ID.AA = Y.AA

    AA.PROPERTY.CLASS.ID = "PROTECTION.LIMIT"

    AA.ARRANGEMENT.ID = Y.ID.AA
    YERR = ''
    AA.PROPERTY.ID = ''
    CALL AA.GET.ARRANGEMENT.CONDITIONS(AA.ARRANGEMENT.ID,AA.PROPERTY.CLASS.ID,'','',AA.PROPERTY.ID,AA.CONDITIONS,YERR)
    IF YERR EQ '' AND AA.PROPERTY.ID NE "" THEN
        PROTECTION.RULES.ID= AA.PROPERTY.ID
        PROTECTION.RULES= AA.CONDITIONS

        R.PROTECTION.LIMIT = RAISE(PROTECTION.RULES<1>)
        PROTECTION.LIMIT.ID = PROTECTION.RULES.ID<1>
        Y.LIMIT = R.PROTECTION.LIMIT<AA.PRCT.LIMIT.AMOUNT>

    END

RETURN
